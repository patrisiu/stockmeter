import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/models/app_model.dart';

class ScreenOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => _buildOverviewWidget(model));
  }

  Widget _buildOverviewWidget(AppModel model) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text("Overview Screen:"),
          Text("userSigned: ${model.isUserSigned}"),
          // Text("accessToken: ${model.getAccessToken}"),
          // Text("idToken: ${model.getIdToken}"),
          Text(""),
          // Text("authHeaders: ${model.authHeaders}"),
          // Text("scopes: ${model.scopes}"),
          // Text("spreadsheetId: ${model.spreadsheetId}"),
          Text("stocks: ${model.stocks}"),
        ]);
  }
}
