import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';

class TestWidget extends StatelessWidget {
  final ForegroundController foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => ListBody(children: <Widget>[
              Text('testing debug'),
              // Text("model.isUserSigned: ${model.isUserSigned}"),
              // Text("model.authHeaders: ${model.authHeaders}"),
              // Text(
              //     "model.authHeaders.values.first: ${model.authHeaders?.values?.first}"),
              // Text(
              //     "sharedPreferences.authorization: ${foregroundController.sharedPreferences.getString('authorization')}"),
              // Text("model.alertNotification: ${model.alertNotification}"),
              // Text(
              //     "sharedPreferences.alertNotification: ${foregroundController.sharedPreferences.getBool('alertNotification')}"),
              // Text("model.spreadsheetId: ${model.spreadsheetId}"),
              // Text("model.spreadsheetIds: ${model.spreadsheetIds}"),
              // Text(
              //     "sharedPreferences.spreadsheetId: ${foregroundController.sharedPreferences.getString('spreadsheetId')}"),
              // Text("stocks: ${model.stocks}"),
              // Text(
              //     "sharedPreferences.error: ${foregroundController.sharedPreferences.getString('error')}"),
            ]));
  }
}
