import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/summary.dart';

class SummaryCard extends StatefulWidget {
  final Summary _summary;

  SummaryCard(this._summary);

  @override
  _SummaryCardState createState() => _SummaryCardState();
}

class _SummaryCardState extends State<SummaryCard> {
  static const EdgeInsets _edgeInsets = EdgeInsets.fromLTRB(2, 0, 2, 2);
  static const EdgeInsets _edgeInsetsTitle = EdgeInsets.all(4);
  static const double _regularTextSize = 20;
  static const double _highlightTextSize = 26;

  Color? _summaryStatusColor;
  Color? _summaryStatusColorLight;

  @override
  Widget build(BuildContext context) {
    _selectSummaryValueTextColor();

    return Card(
        child: ListBody(children: <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        _cardHeader(widget._summary.currency!),
      ]),
      Table(children: <TableRow>[
        TableRow(children: <Widget>[
          _tableRowHeader(StockConstants.profit),
          _tableRowHeader(StockConstants.grossGain),
          _tableRowHeader(StockConstants.netGain),
        ]),
        TableRow(children: <Widget>[
          _profitabilityPercentage(
              widget._summary.latentProfit!, _regularTextSize),
          _tableRowElementAsFixed(widget._summary.grossCapitalGain!,
              _regularTextSize, _summaryStatusColor),
          _tableRowElementAsFixed(widget._summary.netCapitalGain!,
              _regularTextSize, _summaryStatusColorLight),
        ]),
        TableRow(children: <Widget>[
          _tableRowHeader(StockConstants.stocks),
          _tableRowHeader(StockConstants.capitalValue),
          _tableRowHeader(StockConstants.profitDay),
        ]),
        TableRow(children: <Widget>[
          Padding(
              padding: _edgeInsets,
              child: Center(
                  child: Text(widget._summary.stocks.toString(),
                      style: TextStyle(fontSize: _highlightTextSize)))),
          _tableRowElementAsFixed(
              widget._summary.capitalValue!, _highlightTextSize, null),
          _tableRowElementAsFixed(
              widget._summary.netProfitDay!, _highlightTextSize, null),
        ]),
      ])
    ]));
  }

  Padding _cardHeader(String header) =>
      Padding(padding: _edgeInsetsTitle, child: Text(header));

  Widget _tableRowHeader(String header) => Padding(
      padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
      child: Center(
          child: Text(header.toUpperCase(),
              style: TextStyle(color: Colors.white70, fontSize: 8))));

  Widget _tableRowElementAsFixed(num number, double fontSize, Color? color) =>
      Padding(
          padding: _edgeInsets,
          child: Center(
              child: Text(number.toStringAsFixed(2),
                  style: TextStyle(fontSize: fontSize, color: color))));

  Widget _profitabilityPercentage(double gain, double fontSize) => Padding(
      padding: _edgeInsets,
      child: Center(
          child: Text('${(gain * 100).toStringAsFixed(2)}%',
              style:
                  TextStyle(color: _summaryStatusColor, fontSize: fontSize))));

  void _selectSummaryValueTextColor() {
    if (widget._summary.latentProfit! < 0) {
      _summaryStatusColor = Colors.red[600];
      _summaryStatusColorLight = Colors.red[400];
    }
    if (widget._summary.latentProfit! > 0) {
      _summaryStatusColor = Colors.green[600];
      _summaryStatusColorLight = Colors.green[400];
    }
  }
}
