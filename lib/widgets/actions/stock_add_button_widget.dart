import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/builders/stock_builder.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/widgets/stock/stock_form_dialog.dart';

class StockAddButtonWidget extends StatelessWidget {
  final String _tooltip = 'Add Stock';

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _addStockWidget(context, model));

  Widget _addStockWidget(BuildContext context, AppModel model) =>
      model.isUserSigned && StockConstants.stocksScreen == model.currentScreen
          ? _addStockButtonWidget(context)
          : Container();

  IconButton _addStockButtonWidget(BuildContext context) => IconButton(
      icon: const Icon(Icons.library_add_rounded),
      tooltip: _tooltip,
      onPressed: () => _showMaterialDialog(context));

  _showMaterialDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          StockFormDialog(stock: StockBuilder().buildBlank()));
}
