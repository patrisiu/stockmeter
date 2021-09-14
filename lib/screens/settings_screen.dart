import 'package:flutter/material.dart';
import 'package:stockmeter/widgets/settings/about_widget.dart';
import 'package:stockmeter/widgets/settings/datasource_widget.dart';
import 'package:stockmeter/widgets/settings/debug_widget.dart';
import 'package:stockmeter/widgets/settings/hours_notification_widget.dart';
import 'package:stockmeter/widgets/settings/signinout_widget.dart';
import 'package:stockmeter/widgets/settings/stock_notification_widget.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(children: <Widget>[
        SignInOutWidget(),
        Divider(thickness: 1),
        DataSourceWidget(),
        Divider(thickness: 1),
        StockNotificationWidget(),
        Divider(thickness: 1),
        HoursNotificationWidget(),
        Divider(thickness: 1),
        AboutWidget(),
        Divider(thickness: 1),
        DebugWidget(),
      ]);
}
