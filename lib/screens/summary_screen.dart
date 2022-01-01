import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/builders/summary_builder.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/gain_chart_model.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/models/summary.dart';
import 'package:stockmeter/widgets/functionalities/functionality_widget_list.dart';
import 'package:stockmeter/widgets/summary/summary_card_widget.dart';
import 'package:stockmeter/widgets/summary/summary_gain_chart_card.dart';

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => model.isUserSigned
          ? ListView(children: _buildSummaryScreen(model.stocks))
          : ListView(children: FunctionalityWidgetList.get()));

  List<Widget> _buildSummaryScreen(List<Stock> stocks) {
    final List<Stock> tradingStocks =
        stocks.where((stock) => stock.stocks! > 0).toList();
    final Set<String> currencies =
        tradingStocks.map((stock) => stock.currency).toSet();
    final List<Summary> summaries = currencies
        .map((currency) => createCurrencySummary(currency, tradingStocks))
        .toList();
    final List<Widget> result = summaries
        .map((summary) => SummaryCard(summary))
        .map((summaryCard) => Container(child: summaryCard))
        .toList();
    result.add(Container(
        child: SummaryGainChartCard(
            data: _gainChartData(tradingStocks),
            title: StockConstants.netGain)));
    return result;
  }

  List<GainChartModel> _gainChartData(List<Stock> stocks) => stocks
      .map((e) => new GainChartModel(e.symbol + '\n' + e.purchaseDate!,
          e.netCapitalGain, e.latentProfit, e.currency))
      .toList();

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
