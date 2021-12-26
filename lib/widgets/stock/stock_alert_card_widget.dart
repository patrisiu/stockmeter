import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/stock.dart';

class StockAlertCard extends StatefulWidget {
  final Stock _stock;

  StockAlertCard(this._stock);

  @override
  _StockAlertCardState createState() => _StockAlertCardState();
}

class _StockAlertCardState extends State<StockAlertCard> {
  final EdgeInsets _edgeInsets = EdgeInsets.fromLTRB(2, 0, 2, 2);
  final EdgeInsets _edgeInsetsTitle = EdgeInsets.all(4);

  FontWeight? _alertAboveFontWeight;
  FontWeight? _alertBelowFontWeight;
  bool details = false;

  @override
  Widget build(BuildContext context) {
    List<Widget> _children = [
      Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [_cardHeaderPadding(_cardHeaderWidgetSymbolAndAlert())]),
      Table(children: <TableRow>[
        TableRow(children: <Widget>[
          _tableRowHeader(StockConstants.price),
          _tableRowHeader(StockConstants.alertAbove),
          _tableRowHeader(StockConstants.alertBelow)
        ]),
        TableRow(children: <Widget>[
          Padding(
              padding: _edgeInsets,
              child: Center(
                  child: Text(widget._stock.price.toStringAsFixed(3),
                      style: TextStyle(fontSize: 20)))),
          _tableRowAlertConfigured(
              widget._stock.alertAbove!, _alertAboveFontWeight),
          _tableRowAlertConfigured(
              widget._stock.alertBelow!, _alertBelowFontWeight)
        ])
      ])
    ];
    if (details && widget._stock.notes.isNotEmpty) {
      _children.add(ListTile(
        title: Text(StockConstants.notes),
        subtitle: Text(widget._stock.notes),
      ));
    }
    return GestureDetector(
        onTap: _handleOnTap,
        child: Card(
            shape: _buildRoundedRectangleBorder(),
            child: ListBody(children: _children)));
  }

  Padding _cardHeaderPadding(Widget header) =>
      Padding(padding: _edgeInsetsTitle, child: header);

  Widget _cardHeaderWidgetSymbolAndAlert() =>
      widget._stock.alertAbove == 0 && widget._stock.alertBelow == 0
          ? Text(widget._stock.symbol)
          : widget._stock.hasToNotify
              ? _cardHeaderRowSymbolAndAlert(
                  widget._stock.symbol, Icons.notifications_on_rounded)
              : _cardHeaderRowSymbolAndAlert(
                  widget._stock.symbol, Icons.notifications_off_rounded);

  Row _cardHeaderRowSymbolAndAlert(String symbol, IconData iconData) =>
      Row(children: [Icon(iconData, size: 14), Text(' ' + symbol)]);

  Widget _tableRowHeader(String header) => Padding(
      padding: EdgeInsets.fromLTRB(2, 2, 2, 0),
      child: Center(
          child: Text(header.toUpperCase(),
              style: TextStyle(color: Colors.white70, fontSize: 8))));

  Widget _tableRowAlertConfigured(num number, FontWeight? fontWeight) =>
      Padding(
          padding: _edgeInsets,
          child: Center(
              child: Text(number == 0 ? '-' : number.toStringAsFixed(3),
                  style: TextStyle(fontSize: 20, fontWeight: fontWeight))));

  RoundedRectangleBorder? _buildRoundedRectangleBorder() {
    Color? alertColor = _selectAlertColor();
    return _selectAlertColor() != null
        ? RoundedRectangleBorder(
            side: BorderSide(color: alertColor!),
            borderRadius: BorderRadiusDirectional.circular(4))
        : null;
  }

  Color? _selectAlertColor() {
    if (widget._stock.price == 0) {
      return Colors.indigo.shade300;
    } else if (widget._stock.alertBelow != 0 &&
        widget._stock.price <= widget._stock.alertBelow!) {
      _alertBelowFontWeight = FontWeight.bold;
      return Colors.red.shade300;
    } else if (widget._stock.alertAbove != 0 &&
        widget._stock.price >= widget._stock.alertAbove!) {
      _alertAboveFontWeight = FontWeight.bold;
      return Colors.green.shade300;
    } else {
      return null;
    }
  }

  void _handleOnTap() => setState(() {
        details = !details;
      });
}
