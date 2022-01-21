import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/trend.dart';
import 'package:stockmeter/widgets/trends/trend_chart_card.dart';
import 'package:stockmeter/widgets/user_state_widget.dart';

class TrendsScreen extends StatefulWidget {
  @override
  State<TrendsScreen> createState() => _TrendsScreenState();
}

class _TrendsScreenState extends State<TrendsScreen> {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  static const _chartLongPressTipDisclaimer =
      'Press and hold on any chart to navigate to full-time evolution.';

  @override
  void initState() {
    super.initState();
    load();
  }

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => UserStateWidget(
          isUserSigned: model.isUserSigned,
          isStockFileMissing: model.stockFile == null && model.createFileOption,
          isStocksEmpty: model.stocks.isEmpty,
          foregroundController: _foregroundController,
          widgetToDisplay: _buildTrendsScreen(model.trends)));

  Widget _buildTrendsScreen(Map<String, List<Trend>> trends) {
    List<Widget> _children = [];
    _children.addAll(trends.entries
        .map((trend) => TrendChartCard(
            key: UniqueKey(), symbol: trend.key, data: trend.value))
        .toList());
    _children.add(_chartLongPressTip(_chartLongPressTipDisclaimer));
    return RefreshIndicator(
        onRefresh: () async => await _foregroundController
            .fetchStocks()
            .whenComplete(() => load()),
        child: ListView(
            children: _children,
            physics: const AlwaysScrollableScrollPhysics()));
  }

  Widget _chartLongPressTip(String text) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(text, textAlign: TextAlign.center, textScaleFactor: 0.8));

  Future<void> load() async => await _foregroundController.lazyLoadTrends();
}
