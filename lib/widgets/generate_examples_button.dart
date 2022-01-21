import 'package:flutter/material.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/daos/stock_dao.dart';
import 'package:stockmeter/widgets/stock_elevated_button.dart';

class GenerateExamplesButton extends StatefulWidget {
  const GenerateExamplesButton({Key? key, required this.foregroundController})
      : super(key: key);

  final ForegroundController foregroundController;

  @override
  State<GenerateExamplesButton> createState() => _GenerateExamplesButtonState();
}

class _GenerateExamplesButtonState extends State<GenerateExamplesButton> {
  bool _pressedButton = false;

  @override
  Widget build(BuildContext context) => StockElevatedButton(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Text('Generate'),
        const Text('Examples'),
      ]),
      onPressed: _pressedButton ? null : _handleOnPressed);

  void _handleOnPressed() {
    setState(() => _pressedButton = true);
    _generateExamples();
  }

  void _generateExamples() async {
    await widget.foregroundController
        .createStock(_generateNasdaqGoog())
        .whenComplete(() async => await widget.foregroundController
            .createStock(_generateIndexEuroBelTwenty()))
        .whenComplete(() async => await widget.foregroundController
            .createStock(_generateCurrencyBtcEur()))
        .whenComplete(() async => await widget.foregroundController
            .createStock(_generateCurrencyEurYen()))
        .whenComplete(() => widget.foregroundController.fetchStocks());
  }

  StockDAO _generateNasdaqGoog() => StockDAO(
      'NASDAQ:GOOG',
      '02/02/2021',
      '2',
      '1234.567',
      '87',
      '0.23',
      '0',
      '34.42',
      false,
      'NASDAQ:GOOG Alphabet Inc Class C',
      0);

  StockDAO _generateCurrencyBtcEur() => StockDAO(
      'CURRENCY:BTCEUR',
      '09/02/2018',
      '1',
      '6979.28',
      '0',
      '0',
      '38076.12',
      '10000',
      false,
      'Bitcoin to Euro',
      0);

  StockDAO _generateIndexEuroBelTwenty() => StockDAO('INDEXEURO:BEL20',
      '03/01/2020', '0', '0', '0', '0', '0', '4202.13', false, 'BEL 20', 0);

  StockDAO _generateCurrencyEurYen() => StockDAO(
      'CURRENCY:EURJPY',
      '01/01/2022',
      '0',
      '0',
      '0',
      '0',
      '0',
      '0',
      false,
      'Euro to Japanese yen',
      0);
}
