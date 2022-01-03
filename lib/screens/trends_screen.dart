import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/trend_chart_model.dart';
import 'package:stockmeter/widgets/trends/trend_chart_card.dart';

class TrendsScreen extends StatefulWidget {
  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _build(context, model));

  Widget _build(BuildContext context, AppModel model) {
    Set<String> symbols = model.stocks.map((stock) => stock.symbol).toSet();
    Map<String, double> lastPrices = new Map.fromIterable(symbols,
        key: (symbol) => symbol,
        value: (symbol) =>
            model.stocks.firstWhere((stock) => stock.symbol == symbol).price);

    Map<String, List<TrendChartModel>> trends = model.trends;
    trends.forEach((key, value) =>
        value.add(new TrendChartModel(DateTime.now(), lastPrices[key]!)));
    List<Widget> _children = trends.entries
        .map((trend) => TrendChartCard(title: trend.key, data: trend.value))
        .toList();
    return ListView(children: _children);
  }

  Future<void> load() async => await _foregroundController.loadTrendsLazy();
}
