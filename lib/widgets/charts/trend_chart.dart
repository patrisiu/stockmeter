import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:stockmeter/models/trend_chart_model.dart';

class TrendChart extends StatelessWidget {
  const TrendChart({Key? key, required this.data, this.animate})
      : super(key: key);

  final bool? animate;
  final List<TrendChartModel> data;

  @override
  Widget build(BuildContext context) {
    List<Series<dynamic, DateTime>> seriesList = [
      new Series<TrendChartModel, DateTime>(
        id: 'Trend',
        colorFn: (_, __) => MaterialPalette.blue.shadeDefault,
        domainFn: (TrendChartModel trend, _) => trend.date,
        measureFn: (TrendChartModel trend, _) => trend.value,
        data: data,
      )
    ];
    return TimeSeriesChart(
      seriesList,
      animate: animate,
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const LocalDateTimeFactory(),
    );
  }
}
