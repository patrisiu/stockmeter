import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/app_model.dart';

class ScopedBottomNavigationBar extends StatelessWidget {
  const ScopedBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => BottomNavigationBar(
          items: _navigationBarItems(model),
          currentIndex: model.currentScreen,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.white70,
          onTap: model.updateScreen));

  List<BottomNavigationBarItem> _navigationBarItems(AppModel model) {
    List<BottomNavigationBarItem> items = [
      BottomNavigationBarItem(
          icon: Icon(Icons.dashboard_rounded),
          label: StockConstants.navigationBarSummaryLabel),
      BottomNavigationBarItem(
          icon: Icon(Icons.card_travel_rounded),
          label: StockConstants.navigationBarStocksLabel),
      BottomNavigationBarItem(
          icon: Icon(Icons.trending_up_rounded),
          label: StockConstants.navigationBarTrendsLabel),
    ];
    Widget accountIcon = model.isUserSigned
        ? CircleAvatar(
            backgroundImage: NetworkImage(model.photoUrl!), radius: 12.0)
        : Icon(Icons.settings);
    items.add(BottomNavigationBarItem(
        icon: accountIcon, label: StockConstants.navigationBarSettingsLabel));
    return items;
  }
}
