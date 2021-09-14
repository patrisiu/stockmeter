import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/configurations/dependencies.dart';
import 'package:stockmeter/controllers/data_controller.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/notifications/background_notification.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() async {
  Workmanager().executeTask((task, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();
    Dependencies.configure();
    await Firebase.initializeApp();
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    BackgroundController backgroundController =
        GetIt.instance<BackgroundController>();
    await backgroundController.notify(sharedPreferences);
    return Future.value(true);
  });
}

class BackgroundController {
  static const String _uniqueNameTask = StockConstants.uniqueNameTask;
  static const String _taskName = StockConstants.taskName;
  static const int _maxRetries = 5;

  final DataController _dataController = GetIt.instance<DataController>();

  Future<void> initialize(SharedPreferences sharedPreferences) async {
    if (!kIsWeb) {
      String notificationCheck =
          sharedPreferences.getString(StockConstants.notificationCheck) ??
              StockConstants.notificationCheckDisabled;
      await _scheduleNotificationCheckTask(notificationCheck);
    }
  }

  Future<void> _initializeWorkmanager() async =>
      await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  Future<void> enableNotificationCheck(String option) async {
    await disableNotificationCheck();
    await _initializeWorkmanager();
    if (StockConstants.notificationCheck2m == option) {
      await _enableNotificationCheckOneOffTask(
          _selectFrequencyDuration(option));
    } else {
      await _enableNotificationCheckPeriodicTask(
          _selectFrequencyDuration(option));
    }
  }

  Future<void> _enableNotificationCheckPeriodicTask(Duration frequency) async =>
      await Workmanager().registerPeriodicTask(_uniqueNameTask, _taskName,
          existingWorkPolicy: ExistingWorkPolicy.replace,
          frequency: frequency,
          constraints: Constraints(networkType: NetworkType.not_required));

  Future<void> _enableNotificationCheckOneOffTask(Duration initialDelay) async {
    String uniqueNameTask =
        _uniqueNameTask + DateTime.now().millisecondsSinceEpoch.toString();
    await Workmanager().registerOneOffTask(uniqueNameTask, _taskName,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        initialDelay: initialDelay,
        constraints: Constraints(networkType: NetworkType.not_required));
  }

  Duration _selectFrequencyDuration(String option) {
    switch (option) {
      case StockConstants.notificationCheck2m:
        return Duration(minutes: 2);
      case StockConstants.notificationCheck15m:
        return Duration(minutes: 15);
      case StockConstants.notificationCheck1h:
        return Duration(hours: 1);
      default:
        return Duration(hours: 2);
    }
  }

  Future<void> disableNotificationCheck() async =>
      await Workmanager().cancelAll();

  Future<void> notify(SharedPreferences sharedPreferences) async {
    String? sheetId = sharedPreferences.getString(StockConstants.sheetId);
    int hourStart =
        sharedPreferences.getInt(StockConstants.startNotification) ?? 9;
    int hourEnd =
        sharedPreferences.getInt(StockConstants.endNotification) ?? 18;
    bool isValidRangePeriodTime = _isValidRangePeriodTime(hourStart, hourEnd);
    if (sheetId != null && isValidRangePeriodTime) {
      Map<String, String>? authHeaders =
          await _getAuthHeadersWithRetry(0, sharedPreferences);
      if (authHeaders != null) {
        List<Stock> stocks = await _getStocksToNotifyWithRetry(
            authHeaders, sheetId, 0, sharedPreferences);
        if (stocks.isNotEmpty) {
          _showNotification(_convertStocksToMessage(stocks));
        }
      }
    } else {
      _debug(sharedPreferences, [
        'sheetId: ${sheetId != null}',
        'isValidRangePeriodTime: $isValidRangePeriodTime'
      ]);
    }
    await _scheduleNotificationCheckTask(
        sharedPreferences.getString(StockConstants.notificationCheck) ??
            StockConstants.notificationCheckDisabled);
  }

  Future<void> _scheduleNotificationCheckTask(String notificationCheck) async {
    if (StockConstants.notificationCheck2m == notificationCheck) {
      await disableNotificationCheck();
      _enableNotificationCheckOneOffTask(
          _selectFrequencyDuration(notificationCheck));
    }
  }

  bool _isValidRangePeriodTime(int hourStart, int hourEnd) {
    DateTime currentDateTime = DateTime.now();
    int weekday = currentDateTime.weekday;
    int hour = currentDateTime.hour;
    return weekday != DateTime.saturday &&
        weekday != DateTime.sunday &&
        hour >= hourStart &&
        hour < hourEnd;
  }

  Future<Map<String, String>?> _getAuthHeadersWithRetry(
      int retry, SharedPreferences sharedPreferences) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(scopes: StockConstants.scopes);
      GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signInSilently(suppressErrors: false);
      return await googleSignInAccount?.authHeaders;
    } on Exception catch (e) {
      if (retry < _maxRetries) {
        await Future<void>.delayed(Duration(seconds: ++retry));
        _debug(sharedPreferences, ['getAuthHeadersWithRetry', 'retry: $retry']);
        return _getAuthHeadersWithRetry(retry, sharedPreferences);
      } else {
        BackgroundNotification().show(DateTime.now().toString(), e.toString());
        _debug(sharedPreferences,
            ['getAuthHeadersWithRetry', 'retry: $retry', e.toString()]);
        return null;
      }
    }
  }

  Future<List<Stock>> _getStocksToNotifyWithRetry(
      Map<String, String> authHeaders,
      String spreadsheetId,
      int retry,
      SharedPreferences sharedPreferences) async {
    try {
      return await _fetchStocksToNotify(authHeaders, spreadsheetId);
    } on Exception catch (e) {
      if (retry < _maxRetries) {
        await Future<void>.delayed(Duration(seconds: ++retry));
        _debug(
            sharedPreferences, ['getStocksToNotifyWithRetry', 'retry: $retry']);
        return _getStocksToNotifyWithRetry(
            authHeaders, spreadsheetId, retry, sharedPreferences);
      } else {
        BackgroundNotification().show(DateTime.now().toString(), e.toString());
        _debug(sharedPreferences,
            ['getStocksToNotifyWithRetry', 'retry: $retry', e.toString()]);
        return [];
      }
    }
  }

  Future<List<Stock>> _fetchStocksToNotify(
      Map<String, String> authHeaders, String spreadsheetId) async {
    final List<Stock> stocks =
        await _dataController.fetchStocks(authHeaders, spreadsheetId);
    stocks.retainWhere(_satisfiesShowNotification);
    return stocks;
  }

  bool _satisfiesShowNotification(Stock stock) =>
      (stock.alertBelow != 0 && stock.price <= stock.alertBelow!) ||
      (stock.alertAbove != 0 && stock.price >= stock.alertAbove!);

  List<String> _convertStocksToMessage(List<Stock> stocks) {
    final symbols = stocks.map((e) => e.symbol).toSet();
    stocks.retainWhere((element) => symbols.remove(element.symbol));
    return stocks.map((stock) => _stockAlertMessage(stock)).toList();
  }

  String _stockAlertMessage(Stock stock) =>
      '${stock.symbol} ${stock.price} ${stock.currency}';

  void _showNotification(List<String> messages) {
    DateTime dateTimeNow = DateTime.now();
    String onDate = DateFormat.yMd().format(dateTimeNow);
    String atTime = DateFormat.Hm().format(dateTimeNow);
    BackgroundNotification.showList(
        'Stock Notification on $onDate at $atTime', messages);
  }

  void _debug(SharedPreferences sharedPreferences, List<String> details) {
    List<String> messages = [DateTime.now().toString()];
    messages.addAll(details);
    sharedPreferences.setStringList(StockConstants.debug, messages);
  }
}
