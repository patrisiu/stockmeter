import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/widgets/stock/add_stock_action.dart';

class AddStockWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => model.isUserSigned &&
              model.stockFile != null &&
              StockConstants.stocksScreen == model.currentScreen
          ? AddStockAction()
          : Container());
}
