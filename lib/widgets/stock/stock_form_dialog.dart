import 'package:flutter/material.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/widgets/stock/stock_form_widget.dart';

class StockFormDialog extends StatelessWidget {
  const StockFormDialog({Key? key, required this.stock}) : super(key: key);

  final Stock stock;

  @override
  Widget build(BuildContext context) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      child: StockFormWidget(key: UniqueKey(), stock: stock));
}
