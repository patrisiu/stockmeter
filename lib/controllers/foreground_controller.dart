import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/background_controller.dart';
import 'package:stockmeter/controllers/data_controller.dart';
import 'package:stockmeter/daos/stock_dao.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/stock_file.dart';
import 'package:stockmeter/notifications/foreground_notification.dart';
import 'package:stockmeter/services/google_auth_service.dart';

class ForegroundController {
  final GoogleAuthService _googleAuthService =
      GetIt.instance<GoogleAuthService>();
  final DataController _dataController = GetIt.instance<DataController>();

  late final AppModel _appModel;
  late final SharedPreferences _sharedPreferences;
  late final BackgroundController _backgroundController;

  Future<void> initialize(
      AppModel appModel,
      SharedPreferences sharedPreferences,
      BackgroundController backgroundController) async {
    this._appModel = appModel;
    this._sharedPreferences = sharedPreferences;
    this._backgroundController = backgroundController;
    _appModel.setSortBy(
        _sharedPreferences.getString(StockConstants.sortBy) ?? 'Raw Data');
  }

  Future<bool> signInSilentlyAndLoadHugs() async {
    _appModel.user = await _googleAuthService.signInSilently();
    if (_appModel.isUserSigned) {
      _appModel.notificationCheck =
          _sharedPreferences.getString(StockConstants.notificationCheck) ??
              StockConstants.notificationCheckDisabled;
      await _initSignedUser();
      return true;
    } else {
      return false;
    }
  }

  Future<void> signIn() async {
    try {
      _appModel.user = await _googleAuthService.signIn();
      if (_appModel.isUserSigned) {
        await _initSignedUser();
        fetchStocks();
      }
    } on FirebaseAuthException catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<void> signOut() async {
    await _googleAuthService.signOut();
    _backgroundController.disableNotificationCheck();
    _appModel.user = null;
    _appModel.authHeaders = null;
    _appModel.stockFile = null;
    _appModel.stockFiles = [];
    _appModel.createFileOption = false;
    _appModel.summary = null;
    _appModel.stocks = [];
    _appModel.notificationCheck = StockConstants.notificationCheckDisabled;
    _sharedPreferences.clear();
  }

  Future<void> _initSignedUser() async {
    List<String> sheetIds = await _getSpreadsheetIds(await _getAuthHeaders());

    _appModel.createFileOption = false;
    String? spreadsheetId =
        _sharedPreferences.getString(StockConstants.sheetId);

    List<StockFile> stockFiles =
        sheetIds.map((sheetId) => new StockFile(sheetId)).toList();
    _appModel.stockFiles = stockFiles;

    if (spreadsheetId != null &&
        stockFiles.any((stockFile) => stockFile.id == spreadsheetId)) {
      _appModel.stockFile =
          stockFiles.firstWhere((stockFile) => stockFile.id == spreadsheetId);
      _appModel.stockFile!.name =
          await _getSpreadsheetName(_appModel.stockFile!.id);
    } else if (stockFiles.isNotEmpty) {
      _appModel.stockFile = stockFiles.first;
      _sharedPreferences.setString(
          StockConstants.sheetId, _appModel.stockFile!.id);
      _appModel.stockFile!.name =
          await _getSpreadsheetName(_appModel.stockFile!.id);
    } else {
      _appModel.createFileOption = true;
    }
    await updateStockFileWithName();
  }

  Future<void> updateStockFileWithName() async {
    List<String> sheetIds =
        _appModel.stockFiles.map((stockFile) => stockFile.id).toList();
    List<StockFile> stockFilesWithName = [];
    try {
      await Future.wait(sheetIds.map((sheetId) async {
        String? spreadsheetName = await _getSpreadsheetName(sheetId);
        StockFile stockFile = new StockFile(sheetId);
        stockFile.name = spreadsheetName;
        stockFilesWithName.add(stockFile);
      }).toList());
      _appModel.stockFiles = stockFilesWithName;
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<String?> _getSpreadsheetName(String spreadsheetId) async {
    try {
      return await _dataController.fetchStockFileName(
          await _getAuthHeaders(), spreadsheetId);
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<void> createStockFile() async {
    _appModel.createFileOption = false;
    try {
      String sheetId =
          await _dataController.createSheetFile(await _getAuthHeaders());
      StockFile stockFile = new StockFile(sheetId);
      _appModel.stockFiles.add(stockFile);
      updateSelectedSpreadsheetId = stockFile;
      await _refreshAuthHeaders();
    } on Exception catch (e) {
      _appModel.createFileOption = _appModel.stockFile == null;
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<void> createStock(StockDAO stockDAO) async {
    try {
      await _dataController.createStock(
          await _getAuthHeaders(), _appModel.stockFile!.id, stockDAO);
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<void> updateStock(StockDAO stockDAO) async {
    try {
      await _dataController.updateStock(
          await _getAuthHeaders(), _appModel.stockFile!.id, stockDAO);
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<void> deleteStock(int rowIndex) async {
    try {
      await _dataController.deleteStock(
          await _getAuthHeaders(), _appModel.stockFile!.id, rowIndex);
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<List<String>> _getSpreadsheetIds(
      Map<String, String> authHeaders) async {
    try {
      return await _dataController.getSheetIds(authHeaders);
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
      return [];
    }
  }

  Future<void> fetchStocks() async {
    if (_appModel.isUserSigned && _appModel.stockFile != null) {
      _fetchStocks(await _getAuthHeaders(), _appModel.stockFile!.id);
    }
  }

  Future<void> _fetchStocks(
      Map<String, String> authHeaders, String spreadsheetId) async {
    try {
      _appModel.stocks =
          await _dataController.fetchStocks(authHeaders, spreadsheetId);
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<Map<String, String>> _getAuthHeaders() async =>
      await _googleAuthService.authHeaders;

  void refreshAuthHeaders() async {
    try {
      _appModel.authHeaders = await _googleAuthService.refreshAuthHeaders();
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  set updateSelectedSpreadsheetId(StockFile? stockFile) {
    _updateSpreadsheetIdOnSharedPreferences(stockFile);
    _appModel.stockFile = stockFile;
  }

  void _updateSpreadsheetIdOnSharedPreferences(StockFile? stockFile) {
    if (stockFile == null) {
      _sharedPreferences.remove(StockConstants.sheetId);
    } else {
      _sharedPreferences.setString(StockConstants.sheetId, stockFile.id);
    }
  }

  BuildContext get context => _appModel.context!;

  Map<String, String>? get authHeaders => _appModel.authHeaders;

  String get notificationCheck => _appModel.notificationCheck;

  set notificationCheck(String value) {
    _appModel.notificationCheck = value;
    _sharedPreferences.setString(StockConstants.notificationCheck, value);
  }

  RangeValues getHoursAlertNotification() {
    int start =
        _sharedPreferences.getInt(StockConstants.startNotification) ?? 9;
    int end = _sharedPreferences.getInt(StockConstants.endNotification) ?? 18;
    return RangeValues(start.toDouble(), end.toDouble());
  }

  void setHoursAlertNotification(RangeValues values) {
    _sharedPreferences.setInt(
        StockConstants.startNotification, values.start.round());
    _sharedPreferences.setInt(
        StockConstants.endNotification, values.end.round());
  }

  void sortBy(String sortBy) {
    _sharedPreferences.setString(StockConstants.sortBy, sortBy);
    _appModel.setSortBy(sortBy);
    fetchStocks();
  }

  Future<void> refreshFileContent(StockFile stockFile) async {
    updateSelectedSpreadsheetId = stockFile;
    await _refreshAuthHeadersAndFechStocks();
  }

  Future<void> _refreshAuthHeadersAndFechStocks() async =>
      await _refreshAuthHeaders()
          .whenComplete(() async => {await fetchStocks()});

  Future<void> _refreshAuthHeaders() async {
    try {
      _appModel.authHeaders = await _googleAuthService.refreshAuthHeaders();
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<void> deletePositionFile() async {
    try {
      String spreadsheetId = _appModel.stockFile!.id;
      await _dataController.deleteSpreadsheetFile(
          await _getAuthHeaders(), spreadsheetId);
      List<StockFile> stockFiles = _appModel.stockFiles
          .where((stockFile) => stockFile.id != spreadsheetId)
          .toList();
      _appModel.stockFiles = stockFiles;
      if (stockFiles.isEmpty) {
        _appModel.createFileOption = true;
        updateSelectedSpreadsheetId = null;
      } else {
        updateSelectedSpreadsheetId = stockFiles.first;
      }
      await _refreshAuthHeaders();
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  Future<void> setPositionFileName(String positionFileName) async {
    try {
      await _dataController.setStockFileName(
          await _getAuthHeaders(), _appModel.stockFile!.id, positionFileName);
      _appModel.stockFile!.name = positionFileName;
    } on Exception catch (e) {
      ForegroundNotification().error(context, e.toString());
    }
  }

  List<String> debugLastBackgroundExecution() =>
      _sharedPreferences.getStringList(StockConstants.debug) ??
      _sharedPreferences.getKeys().map((e) => e.toString()).toList();

  void debugBackgroundExecution() =>
      _backgroundController.notify(_sharedPreferences);
}