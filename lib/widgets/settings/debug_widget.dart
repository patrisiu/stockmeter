import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/secrets/secrets.dart';

class DebugWidget extends StatefulWidget {
  @override
  _DebugWidgetState createState() => _DebugWidgetState();
}

class _DebugWidgetState extends State<DebugWidget> {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  List<Widget> _columnChildren = [];

  @override
  void initState() {
    super.initState();
    List<String> debug = _foregroundController.debugLastBackgroundExecution();
    _columnChildren = debug.map((e) => Text(e)).toList();
  }

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _displayIfValidUser(context, model));

  Widget _displayIfValidUser(BuildContext context, AppModel model) =>
      model.isUserSigned && _isTestUser(model.user)
          ? _buildDebugWidget(context, model.debugNotification)
          : Container();

  Widget _buildDebugWidget(BuildContext context, bool debugNotification) =>
      ListTile(
          title: const Text('Debug Stock Notification'),
          subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: _columnChildren),
          trailing: Switch(
              value: debugNotification,
              onChanged: (bool value) => _handleOnChanged(value),
              activeColor: StockConstants.activeColor),
          onTap: _handleOnTap,
          onLongPress: _foregroundController.debugBackgroundExecution);

  void _handleOnTap() {
    List<String> debug = _foregroundController.debugLastBackgroundExecution();
    setState(() => _columnChildren = debug.map((e) => Text(e)).toList());
  }

  void _handleOnChanged(bool value) =>
      _foregroundController.debugHugNotification = value;

  bool _isTestUser(User? user) => Secrets.testUsers.contains(user?.email);
}
