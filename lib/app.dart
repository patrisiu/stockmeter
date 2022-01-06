import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/background_controller.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/notifications/foreground_notification.dart';
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

  late final SharedPreferences _sharedPreferences;
  late final ForegroundController _foregroundController;
  late final BackgroundController _backgroundController;
  late final Stream<String> _stream;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    _foregroundController = GetIt.instance<ForegroundController>();
    _backgroundController = GetIt.instance<BackgroundController>();
    _stream = (() async* {
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
      Timer.periodic(Duration(seconds: 42),
          (timer) async => await _fetchStocksWhenAppLifecycleStateResumed());
      yield 'Loaded';
    })().asBroadcastStream();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) =>
      setState(() => _appLifecycleState = state);

  Future<void> _fetchStocksWhenAppLifecycleStateResumed() async {
    if (AppLifecycleState.resumed == _appLifecycleState) {
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
      return _buildHugScaffold(ScopedScreen());
    } else {
      if (snapshot.hasData) {
        if (snapshot.data == 'Loaded') {
          return _buildHugScaffold(ScopedScreen());
        } else {
          return _buildHugScaffoldWithLoadingInfo(ScopedScreen(), [
            Text(snapshot.data.toString()),
            SizedBox(
                child: CircularProgressIndicator(
                    color: StockConstants.activeColor),
                width: 18,
                height: 18)
          ]);
        }
      } else {
        return _buildHugScaffold(_initialDisplay());
      }
    }
  }

  Widget _initialDisplay() => _centerMessage(StockConstants.appTitle);

  Center _centerMessage(String message) => Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[Text(message)]));

  StockScaffold _buildHugScaffold(Widget body) =>
      StockScaffold(title: _title, body: body);

  StockScaffold _buildHugScaffoldWithLoadingInfo(
          Widget body, List<Widget>? persistentFooterButtons) =>
      StockScaffold(
          title: _title,
          body: body,
          persistentFooterButtons: persistentFooterButtons);
}
