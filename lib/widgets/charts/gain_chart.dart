import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/gain_chart_model.dart';

class GainChart extends StatelessWidget {
  const GainChart({Key? key, this.animate, required this.data})
      : super(key: key);

  final bool? animate;
  final List<GainChartModel> data;

  @override
  Widget build(BuildContext context) {
    List<Series<dynamic, String>> seriesList = [
      new Series<GainChartModel, String>(
        id: 'GainChart',
        seriesColor: _getColor(),
        domainFn: (GainChartModel stock, _) => stock.label,
        measureFn: (GainChartModel stock, _) => stock.gain,
        data: data,
        labelAccessorFn: _labelAccessorFn,
        insideLabelStyleAccessorFn: _labelStyleAccessorFn,
        outsideLabelStyleAccessorFn: _labelStyleAccessorFn,
      )
    ];
    return BarChart(seriesList,
        animate: animate,
        vertical: false,
        primaryMeasureAxis: new NumericAxisSpec(
            renderSpec: new GridlineRendererSpec(
                labelStyle: TextStyleSpec(color: MaterialPalette.white),
                lineStyle: LineStyleSpec(thickness: 0)),
            tickProviderSpec: new BasicNumericTickProviderSpec(
                desiredMinTickCount: 8, desiredMaxTickCount: 12)),
        domainAxis: new OrdinalAxisSpec(
            renderSpec: new GridlineRendererSpec(
                labelStyle: TextStyleSpec(color: MaterialPalette.white),
                lineStyle: LineStyleSpec(thickness: 0, dashPattern: [2, 10]))),
        barRendererDecorator: new BarLabelDecorator());
  }

  String _labelAccessorFn(GainChartModel stock, _) =>
      '${stock.gain} ${stock.currency} '
      ' ${(stock.profit * 100).toStringAsFixed(2)}%';

  TextStyleSpec _labelStyleAccessorFn(
          GainChartModel stock, _) =>
      new TextStyleSpec(
          color: (stock.gain < 0)
              ? MaterialPalette.red.shadeDefault
              : MaterialPalette.white);

  Color _getColor() => Color(
      r: StockConstants.activeColor.red,
      g: StockConstants.activeColor.green,
      b: StockConstants.activeColor.blue);
}
