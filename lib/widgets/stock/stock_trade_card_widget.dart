import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/stock.dart';

class StockTradeCard extends StatefulWidget {
  final Stock _stock;

  StockTradeCard(this._stock);

  @override
  _StockTradeCardState createState() => _StockTradeCardState();
}

class _StockTradeCardState extends State<StockTradeCard> {
  final EdgeInsets _edgeInsets = EdgeInsets.fromLTRB(2, 0, 2, 2);
  final EdgeInsets _edgeInsetsTitle = EdgeInsets.all(4);
  final double _regularTextSize = 14;
  final double _highlightTextSize = 20;

  Color? _stockStatusColor;
  Color? _stockStatusColorLight;
  Color? _alertCardColor;
  FontWeight? _alertAboveFontWeight;
  FontWeight? _alertBelowFontWeight;
  bool details = false;

  @override
  void initState() {
    super.initState();
    _setAlertColors();
    _setProfitColors();
    _setErrorColors();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _cardMainElements = <Widget>[
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _cardHeader(widget._stock.symbol),
        _cardHeader(widget._stock.purchaseDate!)
      ]),
      Table(children: <TableRow>[
        TableRow(children: <Widget>[
          _tableRowHeader(StockConstants.profit),
          _tableRowHeader(StockConstants.grossGain),
          _tableRowHeader(StockConstants.netGain),
        ]),
        TableRow(children: <Widget>[
          _profitabilityPercentage(
              widget._stock.latentProfit, _highlightTextSize),
          _tableRowElementAsFixed(widget._stock.grossCapitalGain,
              _highlightTextSize, _stockStatusColor),
          _tableRowElementAsFixed(widget._stock.netCapitalGain,
              _highlightTextSize, _stockStatusColorLight),
        ]),
        TableRow(children: <Widget>[
          _tableRowHeader(StockConstants.price),
          _tableRowHeader(StockConstants.capitalValue),
          _tableRowHeader(StockConstants.profitDay),
        ]),
        TableRow(children: <Widget>[
          Padding(
              padding: _edgeInsets,
              child: Center(
                  child: Text(widget._stock.price.toStringAsFixed(3),
                      style: TextStyle(fontSize: _regularTextSize)))),
          _tableRowElementAsFixed(
              widget._stock.capitalValue, _regularTextSize, null),
          _tableRowElementAsFixed(
              widget._stock.netProfitDay, _regularTextSize, null),
        ]),
      ])
    ];

    if (details) {
      List<TableRow> _tableRow = [
        TableRow(children: <Widget>[
          _tableRowHeader(StockConstants.purchasePrice),
          _tableRowHeader(StockConstants.purchaseCapital),
          _tableRowHeader(StockConstants.daysOld),
        ]),
        TableRow(children: <Widget>[
          Padding(
              padding: _edgeInsets,
              child: Center(
                  child: Text(widget._stock.purchasePrice!.toStringAsFixed(3),
                      style: TextStyle(fontSize: _regularTextSize)))),
          _tableRowElementAsFixed(
              widget._stock.purchaseCapital, _regularTextSize, null),
          Padding(
              padding: _edgeInsets,
              child: Center(
                  child: Text(widget._stock.daysOld.toString(),
                      style: TextStyle(fontSize: _regularTextSize)))),
        ]),
        TableRow(children: <Widget>[
          _tableRowHeader(StockConstants.stocks),
          _tableRowHeader(StockConstants.fees),
          _tableRowHeader(StockConstants.tax),
        ]),
        TableRow(children: <Widget>[
          Padding(
              padding: _edgeInsets,
              child: Center(
                  child: Text(widget._stock.stocks.toString(),
                      style: TextStyle(fontSize: _regularTextSize)))),
          _tableRowElementAsFixed(widget._stock.fees!, _regularTextSize, null),
          Padding(
              padding: _edgeInsets,
              child: Center(
                  child: Text(
                      '${(widget._stock.tax! * 100).toStringAsPrecision(3)}%',
                      style: TextStyle(fontSize: _regularTextSize))))
        ]),
        TableRow(children: <Widget>[
          _tableRowHeader(StockConstants.currency),
          _tableRowHeader(StockConstants.alertAbove),
          _tableRowHeader(StockConstants.alertBelow),
        ]),
        TableRow(children: <Widget>[
          Padding(
              padding: _edgeInsets,
              child: Center(
                  child: Text(widget._stock.currency,
                      style: TextStyle(fontSize: _highlightTextSize)))),
          _tableRowAlertConfigured(
              widget._stock.alertAbove!, _alertAboveFontWeight),
          _tableRowAlertConfigured(
              widget._stock.alertBelow!, _alertBelowFontWeight),
        ]),
      ];
      _cardMainElements.add(Table(children: _tableRow));
      if (details && widget._stock.notes.isNotEmpty) {
        _cardMainElements.add(ListTile(
          title: Text(StockConstants.notes),
          subtitle: Text(widget._stock.notes),
        ));
      }
    }
    return GestureDetector(
        onTap: _handleOnTap,
        child: Card(
            shape: _buildRoundedRectangleBorder(),
            child: ListBody(children: _cardMainElements)));
  }

  RoundedRectangleBorder? _buildRoundedRectangleBorder() =>
      _alertCardColor != null
          ? RoundedRectangleBorder(
              side: BorderSide(color: _alertCardColor!),
              borderRadius: BorderRadiusDirectional.circular(4))
          : null;

  Padding _cardHeader(String header) =>
      Padding(padding: _edgeInsetsTitle, child: Text(header));

  Widget _tableRowHeader(String header) => Padding(
      padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
      child: Center(
          child: Text(header.toUpperCase(),
              style: TextStyle(color: Colors.white70, fontSize: 8))));

  Widget _profitabilityPercentage(double gain, double fontSize) => Padding(
      padding: _edgeInsets,
      child: Center(
          child: Text('${(gain * 100).toStringAsFixed(2)}%',
              style: TextStyle(color: _stockStatusColor, fontSize: fontSize))));

  Widget _tableRowElementAsFixed(num number, double fontSize, Color? color) =>
      Padding(
          padding: _edgeInsets,
          child: Center(
              child: Text(number.toStringAsFixed(2),
                  style: TextStyle(fontSize: fontSize, color: color))));

  Widget _tableRowAlertConfigured(num number, FontWeight? fontWeight) =>
      Padding(
          padding: _edgeInsets,
          child: Center(
              child: Text(number == 0 ? '-' : number.toStringAsFixed(3),
                  style: TextStyle(fontSize: 20, fontWeight: fontWeight))));

  void _setProfitColors() {
    if (widget._stock.price < widget._stock.purchasePrice!) {
      _stockStatusColor = Colors.red[600];
      _stockStatusColorLight = Colors.red[400];
    }
    if (widget._stock.price > widget._stock.purchasePrice!) {
      _stockStatusColor = Colors.green[600];
      _stockStatusColorLight = Colors.green[400];
    }
  }

  void _setAlertColors() {
    if (widget._stock.alertBelow != 0 &&
        widget._stock.price <= widget._stock.alertBelow!) {
      _alertCardColor = Colors.red.shade300;
      _alertBelowFontWeight = FontWeight.bold;
    }
    if (widget._stock.alertAbove != 0 &&
        widget._stock.price >= widget._stock.alertAbove!) {
      _alertCardColor = Colors.green.shade300;
      _alertAboveFontWeight = FontWeight.bold;
    }
  }

  void _setErrorColors() {
    if (widget._stock.price == 0) {
      _alertCardColor = Colors.deepOrange[800];
    }
  }

  void _handleOnTap() => setState(() {
        details = !details;
      });
}
