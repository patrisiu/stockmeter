import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/builders/summary_builder.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/gain_chart_model.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/models/summary.dart';
import 'package:stockmeter/widgets/summary/summary_card_widget.dart';
import 'package:stockmeter/widgets/summary/summary_gain_chart_card.dart';
import 'package:stockmeter/widgets/user_state_widget.dart';

class SummaryScreen extends StatelessWidget {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => UserStateWidget(
          isUserSigned: model.isUserSigned,
          hasDatasource: model.stockFile != null,
          hasData: model.stocks.isNotEmpty,
          isCreateFileOptionReady: model.createFileOption,
          controller: _foregroundController,
          widget: _buildSummaryScreen(model.stocks)));

  Widget _buildSummaryScreen(List<Stock> stocks) {
    final List<Stock> tradingStocks =
        stocks.where((stock) => stock.stocks! > 0).toList();
    final Set<String> currencies =
        tradingStocks.map((stock) => stock.currency).toSet();
    final List<Summary> summaries = currencies
        .map((currency) => createCurrencySummary(currency, tradingStocks))
        .toList();
    List<Widget> result = [];
    result.addAll(summaries.map((summary) => SummaryCard(summary)).toList());
    result.add(SummaryGainChartCard(
        data: _gainChartData(tradingStocks), title: StockConstants.netGain));
    return ListView(children: result);
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
