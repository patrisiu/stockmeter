import 'package:flutter/material.dart';
import 'package:stockmeter/models/gain_chart_model.dart';
import 'package:stockmeter/widgets/charts/gain_chart.dart';

class SummaryGainChartCard extends StatelessWidget {
  const SummaryGainChartCard(
      {Key? key, required this.data, required this.title})
      : super(key: key);

  static const EdgeInsets _edgeInsetsTitle = EdgeInsets.fromLTRB(4, 4, 4, 0);

  final String title;
  final List<GainChartModel> data;

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
              child: GainChart(data: data))
        ]));

  double maxHeight() => (data.length + 0.8) * 45;

  Padding _cardHeader(String header) =>
      Padding(padding: _edgeInsetsTitle, child: Text(header.toUpperCase()));
}
