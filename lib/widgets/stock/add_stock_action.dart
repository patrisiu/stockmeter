import 'package:flutter/material.dart';
import 'package:stockmeter/builders/stock_builder.dart';
import 'package:stockmeter/widgets/stock/stock_form_dialog.dart';

class AddStockAction extends StatelessWidget {
  const AddStockAction({Key? key}) : super(key: key);

  static const String _tooltip = 'Add Stock';

  @override
  Widget build(BuildContext context) => IconButton(
      icon: const Icon(Icons.library_add_rounded, color: Colors.white),
      tooltip: _tooltip,
      onPressed: () => _showMaterialDialog(context));

  _showMaterialDialog(BuildContext context) => showDialog(
      context: context,
      builder: (BuildContext context) =>
          StockFormDialog(stock: StockBuilder().buildBlank()));
}
