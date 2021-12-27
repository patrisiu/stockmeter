import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/models/app_model.dart';

class ScopedBottomNavigationBar extends StatelessWidget {
  const ScopedBottomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> _navigationBarItems(AppModel model) {
      List<BottomNavigationBarItem> items = [
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded), label: 'Summary'),
        BottomNavigationBarItem(
            icon: Icon(Icons.card_travel_rounded), label: 'Stocks'),
        BottomNavigationBarItem(
            icon: Icon(Icons.trending_up_rounded), label: 'Trends'),
      ];
      Widget accountIcon = model.isUserSigned
          ? CircleAvatar(
              backgroundImage: NetworkImage(model.photoUrl!), radius: 12.0)
          : Icon(Icons.account_circle_rounded);
      items.add(BottomNavigationBarItem(icon: accountIcon, label: 'Settings'));
      return items;
    }

    return ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => BottomNavigationBar(
            items: _navigationBarItems(model),
            currentIndex: model.currentScreen,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white70,
            onTap: model.updateScreen));
  }
}
