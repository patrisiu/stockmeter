import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/trend_chart_model.dart';

class TrendChart extends StatefulWidget {
  const TrendChart({Key? key, required this.data, this.animate})
      : super(key: key);

  final bool? animate;
  final List<TrendModel> data;

  @override
  State<TrendChart> createState() => _TrendChartState();
}

class _TrendChartState extends State<TrendChart> {
  static const double _height = 100;
  final DateFormat _dateFormat = new DateFormat('dd/MM/yyyy HH:mm');

  List<Series<dynamic, DateTime>> seriesList = [];

  String? dateLegend;
  double? valueLegend;

  @override
  void initState() {
    super.initState();
    seriesList = [
      new Series<TrendModel, DateTime>(
          id: 'Trend',
          colorFn: (_, __) => _getColor(),
          domainFn: (TrendModel trend, _) => trend.date,
          measureFn: (TrendModel trend, _) => trend.value,
          data: widget.data)
    ];
  }

  @override
  Widget build(BuildContext context) => Column(children: [
        Container(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: _height,
                minHeight: _height * 0.4),
            child: TimeSeriesChart(
              seriesList,
              animate: widget.animate,
              selectionModels: [
                new SelectionModelConfig(
                  type: SelectionModelType.info,
                  changedListener: (wop) => _onSelectionChanged(context, wop),
                )
              ],
              primaryMeasureAxis: new NumericAxisSpec(
                  renderSpec: new GridlineRendererSpec(
                      labelStyle: TextStyleSpec(color: MaterialPalette.white),
                      lineStyle: LineStyleSpec(thickness: 0)),
                  tickProviderSpec: new BasicNumericTickProviderSpec(
                      desiredMinTickCount: 3, desiredMaxTickCount: 10)),
              domainAxis: new DateTimeAxisSpec(
                  renderSpec: new GridlineRendererSpec(
                      labelStyle: TextStyleSpec(color: MaterialPalette.white),
                      lineStyle:
                          LineStyleSpec(thickness: 0, dashPattern: [2, 10])),
                  tickProviderSpec: new DayTickProviderSpec()),
              // Optionally pass in a [DateTimeFactory] used by the chart. The factory
              // should create the same type of [DateTime] as the data provided. If none
              // specified, the default creates local date time.
              dateTimeFactory: const LocalDateTimeFactory(),
            )),
        _legend()
      ]);

  Container _legend() => dateLegend == null || valueLegend == null
      ? Container()
      : Container(
          padding: EdgeInsets.fromLTRB(24, 0, 24, 4),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [Text(dateLegend!), Text(valueLegend.toString())]));

  Color _getColor() => Color(
      r: StockConstants.activeColor.red,
      g: StockConstants.activeColor.green,
      b: StockConstants.activeColor.blue);

  _onSelectionChanged(BuildContext context, SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime? date;
    final measures = <String, num>{};

    if (selectedDatum.isNotEmpty) {
      date = selectedDatum.first.datum.date;
      print(date);
      selectedDatum.forEach((SeriesDatum datumPair) {
        measures[datumPair.series.displayName!] = datumPair.datum.value;
        print(datumPair.series.displayName!);
      });
    }
    setState(() {
      dateLegend = _dateFormat.format(date!);
      valueLegend = measures['Trend']?.toDouble();
    });
  }
}
