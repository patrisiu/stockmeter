import 'dart:async';
import 'dart:developer' as developer;

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/background_controller.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/notifications/foreground_notification.dart';
import 'package:stockmeter/screens/init_screen.dart';
import 'package:stockmeter/widgets/scoped_screen.dart';
import 'package:stockmeter/widgets/stock_scaffold.dart';

class StockMeterApp extends StatefulWidget {
  @override
  _StockMeterAppState createState() => _StockMeterAppState();
}

class _StockMeterAppState extends State<StockMeterApp>
    with WidgetsBindingObserver {
  static final AppModel _appModel = new AppModel();
  static final String _title = StockConstants.appTitle;
  static AppLifecycleState _appLifecycleState = AppLifecycleState.resumed;
  static ConnectivityResult _connectionStatus = ConnectivityResult.none;
  final Connectivity _connectivity = Connectivity();

  late final SharedPreferences _sharedPreferences;
  late final ForegroundController _foregroundController;
  late final BackgroundController _backgroundController;
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  late Stream<String> _stream;
  bool _appLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);

    initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);

    _foregroundController = GetIt.instance<ForegroundController>();
    _backgroundController = GetIt.instance<BackgroundController>();

    _stream = _appInitStream();
  }

  Stream<String> _appInitStream() => (() async* {
        if (_connectivityIsWorking()) {
          if (!_appLoaded) {
            yield 'Loading Stored Preferences...';
            _sharedPreferences = await SharedPreferences.getInstance();
            yield 'Init Background Controller...';
            _backgroundController.initialize(_sharedPreferences);
            yield 'Init Foreground Controller...';
            await _foregroundController.initialize(
                _appModel, _sharedPreferences, _backgroundController);
            yield 'Signing in to Google...';
            if (await _foregroundController.signInSilentlyAndLoadHugs()) {
              yield 'Fetching Stocks...';
              await _foregroundController.fetchStocks();
            }
            yield 'Starting StockMeter...';
            Timer.periodic(
                Duration(seconds: 42),
                (timer) async =>
                    await _fetchStocksWhenAppLifecycleStateResumed());
            _appLoaded = true;
            yield 'Loaded';
          } else {
            yield 'Loaded';
          }
        } else {
          yield 'Connectivity is lost!';
        }
      })()
          .asBroadcastStream();

  bool _connectivityIsWorking() => ConnectivityResult.none != _connectionStatus;

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      setState(() => _appLifecycleState = state);

  Future<void> _fetchStocksWhenAppLifecycleStateResumed() async {
    if (AppLifecycleState.resumed == _appLifecycleState &&
        _connectivityIsWorking()) {
      await _foregroundController.fetchStocks();
    }
  }

  @override
  Widget build(BuildContext context) => ScopedModel<AppModel>(
      model: _appModel,
      child: MaterialApp(
          title: _title,
          theme: ThemeData.dark(),
          darkTheme: ThemeData.dark(),
          home: StreamBuilder<String>(
              stream: _stream,
              builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
                  _streamBuilder(context, snapshot))));

  Widget _streamBuilder(BuildContext context, AsyncSnapshot<String> snapshot) {
    if (snapshot.hasError) {
      ForegroundNotification().error(context, snapshot.error.toString());
      return _buildStockScaffold(ScopedScreen());
    } else {
      if (snapshot.hasData) {
        if (snapshot.data == 'Loaded') {
          return _buildStockScaffold(ScopedScreen());
        } else if (snapshot.data == 'Connectivity is lost!') {
          return _buildStockScaffoldWithLoadingInfo(
              InitScreen(), _loadingInfo(snapshot.data.toString()));
        } else {
          return _buildStockScaffoldWithLoadingInfo(
              ScopedScreen(), _loadingInfo(snapshot.data.toString()));
        }
      } else {
        return _buildStockScaffold(InitScreen());
      }
    }
  }

  List<Widget> _loadingInfo(String message) => [
        Text(message),
        SizedBox(
            child: CircularProgressIndicator(color: StockConstants.activeColor),
            width: 18,
            height: 18)
      ];

  StockScaffold _buildStockScaffold(Widget body) =>
      StockScaffold(title: _title, body: body);

  StockScaffold _buildStockScaffoldWithLoadingInfo(
          Widget body, List<Widget>? persistentFooterButtons) =>
      StockScaffold(
          title: _title,
          body: body,
          connectivity: _connectivityIsWorking(),
          persistentFooterButtons: persistentFooterButtons);

  Future<void> initConnectivity() async {
    late ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      developer.log('Could not check connectivity status', error: e);
      return;
    }
    if (!mounted) {
      return Future.value(null);
    }
    return _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
      _stream = _appInitStream();
    });
  }
}
