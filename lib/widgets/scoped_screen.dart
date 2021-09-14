import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/screens/settings_screen.dart';
import 'package:stockmeter/screens/stocks_screen.dart';
import 'package:stockmeter/screens/summary_screen.dart';
import 'package:stockmeter/screens/trends_screen.dart';

class ScopedScreen extends StatelessWidget {
  final List<Widget> _screens = [
    SummaryScreen(),
    StocksScreen(),
    TrendsScreen(),
    SettingsScreen(),
    const Text('Screen Overflow'),
  ];

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => buildScreen(context, model));

  Widget buildScreen(BuildContext context, AppModel model) {
    model.context = context;
    return _screens[model.currentScreen];
  }
}
