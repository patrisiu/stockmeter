import 'package:flutter/material.dart';
import 'package:stockmeter/models/stock.dart';

class StockWarningWidget extends StatelessWidget {
  StockWarningWidget({Key? key, required this.stock}) : super(key: key);

  final Stock stock;
  final EdgeInsets _edgeInsetsTitle = EdgeInsets.all(4);

  @override
  Widget build(BuildContext context) => Card(
          child: ListBody(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.start, children: [
          _cardHeader(stock.symbol),
        ]),
        ListTile(
          leading: Icon(Icons.warning_rounded, size: 40),
          title: const Text('Wrong Stock Data'),
          subtitle: const Text('Long Press here to edit the values'),
        )
      ]));

  Padding _cardHeader(String header) => Padding(
      padding: _edgeInsetsTitle,
      child: Text(
        header,
        style: TextStyle(decorationStyle: TextDecorationStyle.dashed),
      ));
}
