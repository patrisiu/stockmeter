import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/daos/stock_dao.dart';
import 'package:stockmeter/widgets/functionalities/functionality_widget_list.dart';
import 'package:stockmeter/widgets/settings/create_file_button_widget.dart';
import 'package:stockmeter/widgets/stock/add_stock_action.dart';
import 'package:stockmeter/widgets/stock_elevated_button.dart';

class UserStateWidget extends StatelessWidget {
  const UserStateWidget(
      {Key? key,
      required this.isUserSigned,
      required this.isStockFileMissing,
      required this.isStocksEmpty,
      required this.widgetToDisplay,
      required this.foregroundController})
      : super(key: key);

  final bool isUserSigned;
  final bool isStockFileMissing;
  final bool isStocksEmpty;
  final Widget widgetToDisplay;

  final ForegroundController foregroundController;

  @override
  Widget build(BuildContext context) => isUserSigned
      ? isStockFileMissing
          ? _createPortfolioFile()
          : isStocksEmpty
              ? ListView(children: [_introToStocks(), _generateStockExamples()])
              : widgetToDisplay
      : ListView(children: _elementsWhenSignOut());

  List<Widget> _elementsWhenSignOut() {
    List<Widget> elements = [_loginWithAccount()];
    elements.addAll(FunctionalityWidgetList.get());
    return elements;
  }

  Widget _loginWithAccount() => Card(
      child: ListTile(
          enabled: !isUserSigned,
          title: const Text('Required a Google Account'),
          subtitle: const Text(
              'StockMeter uses Google Sheets to store and calculate the financial data. '
              'Because of this, it is required a Google Account and granted access to Google Drive. '
              'In any case, the application stores personal data or access other files '
              'beyond the strictly Google Sheets files required to work.'),
          trailing: isUserSigned
              ? null
              : StockElevatedButton(
                  child: const Text('SIGN IN'),
                  onPressed: foregroundController.signIn)));

  Widget _createPortfolioFile() => Card(
      child: ListTile(
          enabled: isStockFileMissing,
          title: const Text('Create a Portfolio!'),
          subtitle: const Text(
              'Create the first Stock File to start adding your financial data '
              'or configure price alerts.'),
          trailing: isStockFileMissing ? CreateFileButtonWidget() : null));

  Widget _introToStocks() => Card(
      child: ListTile(
          leading: const Icon(StockConstants.navigationBarStocksIcon, size: 40),
          title: const Text('Add the first Stock!'),
          subtitle: const Text(
              'Create a new Stock investment or just monitor its latest price.\n'
              'A price Alert can be set and trigger a notification.\n'
              'Remember to visit Settings to configure the Stock Notification.'),
          trailing: StockElevatedButton(child: AddStockAction())));

  Widget _generateStockExamples() => Card(
      child: ListTile(
          title: const Text('Lack of inspiration?!'),
          subtitle: const Text(
              'StockMeter requires introduce the Stocks with the symbol as provided by Google Finance. '
              'As it might be quite tricky at first, here some examples can be generated '
              'with different Exchange Codes to see how it works.'),
          trailing: Container(
              height: double.infinity,
              child: StockElevatedButton(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Generate'),
                        const Text('Examples')
                      ]),
                  onPressed: _generateExamples))));

  void _generateExamples() async {
    await foregroundController
        .createStock(_generateNasdaqGoog())
        .whenComplete(() async =>
            await foregroundController.createStock(_generateCurrencyBtcEur()))
        .whenComplete(() async => await foregroundController
            .createStock(_generateCurrencyBelTwenty()))
        .whenComplete(() => foregroundController.fetchStocks());
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

  StockDAO _generateCurrencyBelTwenty() => StockDAO('INDEXEURO:BEL20',
      '03/01/2020', '0', '0', '0', '0', '0', '4202.13', false, 'BEL 20', 0);
}
