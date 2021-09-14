import 'package:flutter/material.dart';
import 'package:stockmeter/models/summary.dart';

class SummaryDebugWidget extends StatelessWidget {
  final Summary summary;

  const SummaryDebugWidget(this.summary);

  @override
  Widget build(BuildContext context) {
    return Card(
        child: Column(children: <Widget>[
      Text('currency; ${summary.currency}'),
      Text("stocks: ${summary.stocks}"),
      Text("buyingValue: ${summary.purchaseCapital}"),
      Text("currentValue: ${summary.capitalValue}"),
      Text("latentProfitability: ${summary.latentProfit}"),
      Text("latentCapitalGain: ${summary.grossCapitalGain}"),
      Text("netCapitalGain: ${summary.netCapitalGain}"),
      Text("grossSalary: ${summary.grossProfitDay}"),
      Text("netSalary: ${summary.netProfitDay}"),
    ]));
  }
}
