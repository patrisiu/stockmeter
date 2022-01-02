import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/models/trend_chart_model.dart';
import 'package:stockmeter/widgets/trends/trend_chart_card.dart';

class TrendsScreen extends StatefulWidget {
  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  List<TrendChartModel> data = [];

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _build(context, model.stocks));

  Widget _build(BuildContext context, List<Stock> stocks) {
    Set<String> symbols = _getSymbols(stocks);

    Map<String, double> lastPrices = new Map.fromIterable(symbols,
        key: (symbol) => symbol,
        value: (symbol) =>
            stocks.firstWhere((stock) => stock.symbol == symbol).price);

    Map<String, List<TrendChartModel>> trendsMap = new Map.fromIterable(symbols,
        key: (symbol) => symbol, value: (symbol) => []);

    trendsMap.forEach(
        (key, value) async => value.addAll(await _getSheetValues(key)));

    trendsMap.forEach((key, value) =>
        value.add(new TrendChartModel(DateTime.now(), lastPrices[key]!)));

    List<Widget> _children = trendsMap.entries
        .map((e) => TrendChartCard(title: e.key, data: e.value))
        .toList();

    return ListView(children: _children);
  }

  Future<List<TrendChartModel>> _getSheetValues(String symbol) async =>
      await _foregroundController.generateTrend(symbol);

  Set<String> _getSymbols(List<Stock> stocks) {
    return stocks.map((stock) => stock.symbol).toSet();
  }
}
