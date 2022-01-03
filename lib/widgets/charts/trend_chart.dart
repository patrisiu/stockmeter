import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/trend_chart_model.dart';
import 'package:stockmeter/notifications/foreground_notification.dart';

class TrendChart extends StatelessWidget {
  const TrendChart(
      {Key? key, required this.data, this.animate, required this.onSelected})
      : super(key: key);

  final bool? animate;
  final List<TrendChartModel> data;
  final Function(DateTime, num) onSelected;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(BuildContext context, SelectionModel model) {
    final selectedDatum = model.selectedDatum;

    DateTime? date;
    final measures = <String, num>{};

    // We get the model that updated with a list of [SeriesDatum] which is
    // simply a pair of series & datum.
    //
    // Walk the selection updating the measures map, storing off the sales and
    // series name for each selection point.
    if (selectedDatum.isNotEmpty) {
      date = selectedDatum.first.datum.date;
      print(date);
      selectedDatum.forEach((SeriesDatum datumPair) {
        measures[datumPair.series.displayName!] = datumPair.datum.value;
        print(datumPair.series.displayName!);
      });
    }
    print(measures);

    // Request a build.
    // setState(() {
    //   _date = date;
    //   _measures = measures;
    // });

    if (date != null) {
      ForegroundNotification()
          .tip(context, 'Date: $date; Value: ${measures['Trend']}');
      onSelected(date, measures['Trend']!);
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Series<dynamic, DateTime>> seriesList = [
      new Series<TrendChartModel, DateTime>(
        id: 'Trend',
        colorFn: (_, __) => _getColor(),
        domainFn: (TrendChartModel trend, _) => trend.date,
        measureFn: (TrendChartModel trend, _) => trend.value,
        data: data,
      )
    ];

    // // If there is a selection, then include the details.
    // if (_date != null) {
    //   // children.add(new Padding(
    //   //     padding: new EdgeInsets.only(top: 5.0),
    //   //     child: new Text(_time.toString())));
    //   ForegroundNotification().tip(context, _date.toString());
    // }
    // _measures?.forEach((String series, num value) {
    //   // children.add(new Text('${series}: ${value}'));
    // });

    return TimeSeriesChart(
      seriesList,
      animate: animate,
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
              lineStyle: LineStyleSpec(thickness: 0, dashPattern: [2, 10])),
          tickProviderSpec: new DayTickProviderSpec()),
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const LocalDateTimeFactory(),
    );
  }

  Color _getColor() => Color(
      r: StockConstants.activeColor.red,
      g: StockConstants.activeColor.green,
      b: StockConstants.activeColor.blue);
}
