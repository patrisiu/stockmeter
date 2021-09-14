import 'package:flutter/material.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/widgets/stock/stock_form_widget.dart';

class StockDebugWidget extends StatelessWidget {
  final Stock stock;

  StockDebugWidget(this.stock);

  @override
  Widget build(BuildContext context) {
    final Color? _backgroundColor = _selectBackgroundColor();
    final Color? _stockValue = _selectStockValueTextColor();

    return GestureDetector(
        onLongPress: () => _onLongPress(context, stock),
        child: Card(
            color: _backgroundColor,
            child: Column(children: <Widget>[
              Text("symbol: ${stock.symbol}"),
              Text("buyingDate: ${stock.purchaseDate}"),
              Text("stocks: ${stock.stocks}"),
              Text("buyingStockPrice: ${stock.purchasePrice}"),
              Text("currency: ${stock.currency}"),
              Text("commissions: ${stock.fees}"),
              Text("tax: ${stock.tax}"),
              Text("alert above: ${stock.alertAbove}"),
              Text("alert below: ${stock.alertBelow}"),
              Text("buyingValue: ${stock.purchaseCapital}"),
              Text("currentStockPrice: ${stock.price}"),
              Text(
                "currentValue: ${stock.capitalValue}",
                style: TextStyle(color: _stockValue),
              ),
              Text(
                "latentProfitability: ${stock.latentProfit}",
                style: TextStyle(color: _stockValue),
              ),
              Text("latentCapitalGain: ${stock.grossCapitalGain}"),
              Text("netCapitalGain: ${stock.netCapitalGain}"),
              Text("daysOld: ${stock.daysOld}"),
              Text("grossSalary: ${stock.grossProfitDay}"),
              Text("netSalary: ${stock.netProfitDay}"),
              Text("rowNumber: ${stock.rowIndex}"),
            ])));
  }

  void _onLongPress(BuildContext context, Stock stock) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              // shape: RoundedRectangleBorder(
              // borderRadius: BorderRadius.circular(20.0)), //this right here
              child: StockFormWidget(stock));
        });
  }

  Color? _selectStockValueTextColor() {
    if (stock.price <= stock.purchasePrice!) {
      return Colors.red[300];
    }
    if (stock.price >= stock.purchasePrice!) {
      return Colors.green[300];
    }
    return null;
  }

  Color? _selectBackgroundColor() {
    if (stock.alertBelow != 0 &&
        stock.price <= stock.alertBelow!) {
      return Colors.blueGrey;
    }
    if (stock.alertAbove != 0 &&
        stock.price >= stock.alertAbove!) {
      return Colors.blueGrey;
    }
    return null;
  }
}
