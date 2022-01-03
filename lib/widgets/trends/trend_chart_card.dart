import 'package:flutter/material.dart';
import 'package:stockmeter/models/trend_chart_model.dart';
import 'package:stockmeter/widgets/charts/trend_chart.dart';

class TrendChartCard extends StatefulWidget {
  const TrendChartCard({Key? key, required this.title, required this.data})
      : super(key: key);

  static const EdgeInsets _edgeInsetsTitle = EdgeInsets.fromLTRB(4, 4, 4, 0);
  static const double _height = 100;

  final String title;
  final List<TrendChartModel> data;

  @override
  State<TrendChartCard> createState() => _TrendChartCardState();
}

class _TrendChartCardState extends State<TrendChartCard> {
  late String _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.data.last.value.toString();
  }

  @override
  Widget build(BuildContext context) => Card(
          child: ListBody(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_cardHeader(widget.title), _cardHeader(_selectedValue)]),
        Container(
            padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: TrendChartCard._height,
                minHeight: TrendChartCard._height * 0.4),
            child: widget.data.isEmpty
                ? const Text('Loading...')
                : TrendChart(
                    data: widget.data,
                    animate: true,
                    onSelected: (date, value) => onValueSelected))
      ]));

  Padding _cardHeader(String header) => Padding(
      padding: TrendChartCard._edgeInsetsTitle,
      child: Text(header.toUpperCase()));

  onValueSelected(DateTime date, double value) {
    print('i am hereee');
    setState(() {
      _selectedValue = 'date: $date; value: $value';
    });
  }
}
