import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/builders/summary_builder.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/models/summary.dart';
import 'package:stockmeter/widgets/summary/summary_card_widget.dart';

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _buildSummaryScreen(model));

  Widget _buildSummaryScreen(AppModel model) {
    final List<Stock> tradingStocks =
        model.stocks.where((stock) => stock.stocks! > 0).toList();
    final Set<String> currencies =
        tradingStocks.map((stock) => stock.currency).toSet();
    List<Summary> summaries = currencies
        .map((currency) => createCurrencySummary(currency, tradingStocks))
        .toList();
    return ListView(
        children:
            summaries.map((summary) => new SummaryCard(summary)).toList());
  }

  Summary createCurrencySummary(String currency, List<Stock> stocks) {
    SummaryBuilder summaryBuilder = new SummaryBuilder(currency);
    stocks
        .where((currencyStocks) => currencyStocks.currency == currency)
        .forEach((stock) {
      summaryBuilder.addStocks = stock.stocks!;
      summaryBuilder.addPurchaseCapital = stock.purchaseCapital;
      summaryBuilder.addCapitalValue = stock.capitalValue;
      summaryBuilder.addGrossCapitalGain = stock.grossCapitalGain;
      summaryBuilder.addNetCapitalGain = stock.netCapitalGain;
      summaryBuilder.addGrossProfitDay = stock.grossProfitDay;
      summaryBuilder.addNetProfitDay = stock.netProfitDay;
    });
    return summaryBuilder.build();
  }
}
