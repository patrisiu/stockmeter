import 'package:flutter/material.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/widgets/stock/stock_alert_card_widget.dart';
import 'package:stockmeter/widgets/stock/stock_form_dialog.dart';
import 'package:stockmeter/widgets/stock/stock_trade_card_widget.dart';
import 'package:stockmeter/widgets/stock/stock_warning_widget.dart';

class StockCardWidget extends StatelessWidget {
  const StockCardWidget({Key? key, required this.stock}) : super(key: key);

  final Stock stock;

  @override
  Widget build(BuildContext context) => GestureDetector(
      onLongPress: () => _onLongPress(context, stock),
      child: _stockCard(stock));

  Widget _stockCard(Stock stock) => stock.price == 0
      ? StockWarningWidget(stock: stock)
      : stock.stocks == 0
          ? StockAlertCard(key: UniqueKey(), stock: stock)
          : StockTradeCard(key: UniqueKey(), stock: stock);

  void _onLongPress(BuildContext context, Stock stock) => showDialog(
      context: context,
      builder: (BuildContext context) => StockFormDialog(stock: stock));
}
