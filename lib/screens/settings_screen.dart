import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stockmeter/widgets/settings/about_widget.dart';
import 'package:stockmeter/widgets/settings/datasource_widget.dart';
import 'package:stockmeter/widgets/settings/debug_widget.dart';
import 'package:stockmeter/widgets/settings/device_notification_constrain.dart';
import 'package:stockmeter/widgets/settings/hours_notification_widget.dart';
import 'package:stockmeter/widgets/settings/signinout_widget.dart';
import 'package:stockmeter/widgets/settings/stock_notification_widget.dart';

class SettingsScreen extends StatelessWidget {
  SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ListView(children: <Widget>[
        SignInOutWidget(),
        Divider(),
        DataSourceWidget(),
        Divider(),
        StockNotificationWidget(),
        Divider(),
        HoursNotificationWidget(),
        Divider(),
        buildIfNotWeb(DeviceNotificationConstrain()),
        buildIfNotWeb(Divider()),
        AboutWidget(),
        buildIfNotWeb(Divider()),
        buildIfNotWeb(DebugWidget()),
      ]);

  Widget buildIfNotWeb(Widget widget) => kIsWeb ? Container() : widget;
}
