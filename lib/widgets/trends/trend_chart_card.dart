import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/models/trend.dart';
import 'package:stockmeter/widgets/charts/trend_chart.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class TrendChartCard extends StatelessWidget {
  const TrendChartCard({Key? key, required this.symbol, required this.data})
      : super(key: key);

  static const EdgeInsets _edgeInsetsTitle = EdgeInsets.fromLTRB(4, 4, 4, 0);
  static const String _googleFinanceQuote =
      'https://www.google.com/finance/quote/';

  final String symbol;
  final List<Trend> data;

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _buildTrendChartCard(model.stocks));

  Widget _buildTrendChartCard(List<Stock> stocks) => GestureDetector(
      onLongPress: () => _launchURL(_googleFinanceSymbol(symbol)),
      child: Card(
          child: ListBody(children: <Widget>[
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          _cardHeader(_cardTitle(symbol)),
          _cardHeader(_lastPriceCompared(
              data, stocks.firstWhere((stock) => stock.symbol == symbol)))
        ]),
        TrendChart(data: data, animate: true)
      ])));

  Text _cardTitle(String symbol) {
    List<String> symbolParts = symbol.split(':');
    return symbolParts[0] == 'CURRENCY' || symbolParts[0].contains('INDEX')
        ? Text(symbolParts[0])
        : Text(symbol);
  }

  Padding _cardHeader(Widget header) =>
      Padding(padding: TrendChartCard._edgeInsetsTitle, child: header);

  Widget _lastPriceCompared(List<Trend> data, Stock stock) {
    List<Widget> _children = [
      Text('${stock.price.toStringAsFixed(3)} ${stock.currency}')
    ];
    if (data.isNotEmpty) {
      _children.addAll(_todayVariation(data.last.value, stock.price));
    }
    return Row(children: _children);
  }

  List<Widget> _todayVariation(double last, double today) {
    Color? color;
    Color? colorLight;
    double percentage = (today / last - 1) * 100;
    double absolute = today - last;

    if (percentage > 0) {
      color = Colors.green[600];
      colorLight = Colors.green[400];
    } else if (percentage < 0) {
      color = Colors.red[600];
      colorLight = Colors.red[400];
    }
    return [
      _textSeparator(),
      _textPercentage(percentage, color),
      _textSeparator(),
      _textAbsolute(absolute, colorLight),
      _textSeparator(),
      _textToday(color)
    ];
  }

  Text _textToday(Color? negativeColor) =>
      Text('Today', style: new TextStyle(color: negativeColor));

  Text _textAbsolute(double absolute, Color? negativeColorLight) {
    String sign = '+';
    if (absolute < 0) {
      sign = '';
    }
    return Text(sign + '${absolute.toStringAsFixed(3)}',
        style: new TextStyle(color: negativeColorLight));
  }

  Text _textPercentage(double percentage, Color? negativeColor) =>
      Text('${percentage.toStringAsFixed(2)}%',
          style: new TextStyle(color: negativeColor));

  Text _textSeparator() => Text(' ');

  String _googleFinanceSymbol(String symbol) {
    List<String> quote = symbol.split(':');
    return quote[0] == 'CURRENCY'
        ? _googleFinanceQuote +
            quote[1].substring(0, 3) +
            '-' +
            quote[1].substring(3)
        : _googleFinanceQuote + quote[1] + ':' + quote[0];
  }

  void _launchURL(String url) async => await launcher.canLaunch(url)
      ? await launcher.launch(url)
      : throw 'Could not launch $url';
}
