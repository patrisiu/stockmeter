import 'package:flutter/material.dart';
import 'package:stockmeter/models/trend_chart_model.dart';
import 'package:stockmeter/widgets/charts/trend_chart.dart';

class TrendChartCard extends StatelessWidget {
  const TrendChartCard({Key? key, required this.title, required this.data})
      : super(key: key);

  static const EdgeInsets _edgeInsetsTitle = EdgeInsets.fromLTRB(4, 4, 4, 0);

  final String title;
  final List<TrendChartModel> data;

  @override
  Widget build(BuildContext context) => data.isEmpty
      ? Container()
      : Card(
          child: ListBody(children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [_cardHeader(title)]),
          Container(
              padding: EdgeInsets.fromLTRB(4, 0, 4, 0),
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                  maxHeight: maxHeight()),
              child: TrendChart(data: data))
        ]));

  double maxHeight() => 100;

  Padding _cardHeader(String header) =>
      Padding(padding: _edgeInsetsTitle, child: Text(header.toUpperCase()));
}
