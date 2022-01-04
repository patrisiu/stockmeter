import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
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
      builder: (context, child, model) => ListView(
          children: model.trends.entries
              .map((trend) =>
                  TrendChartCard(title: trend.key, data: trend.value))
              .toList()));

  Future<void> load() async => await _foregroundController.lazyLoadTrends();
}
