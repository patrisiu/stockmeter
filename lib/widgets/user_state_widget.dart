import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/widgets/functionalities/functionality_widget_list.dart';
import 'package:stockmeter/widgets/generate_examples_button.dart';
import 'package:stockmeter/widgets/settings/create_file_button_widget.dart';
import 'package:stockmeter/widgets/stock/add_stock_action.dart';
import 'package:stockmeter/widgets/stock_elevated_button.dart';

class UserStateWidget extends StatelessWidget {
  const UserStateWidget(
      {Key? key,
      required this.isUserSigned,
      required this.hasDatasource,
      required this.hasData,
      required this.isCreateFileOptionReady,
      required this.widget,
      required this.controller})
      : super(key: key);

  final bool isUserSigned;
  final bool hasDatasource;
  final bool hasData;
  final bool isCreateFileOptionReady;
  final Widget widget;

  final ForegroundController controller;

  @override
  Widget build(BuildContext context) => isUserSigned
      ? !hasDatasource && isCreateFileOptionReady
          ? _createPortfolioFile()
          : hasDatasource
              ? hasData
                  ? widget
                  : ListView(
                      children: [_introToStocks(), _generateStockExamples()])
              : _loadingFile()
      : ListView(children: _elementsWhenSignOut());

  List<Widget> _elementsWhenSignOut() {
    List<Widget> elements = [_loginWithAccount()];
    elements.addAll(FunctionalityWidgetList.get());
    return elements;
  }

  Widget _loginWithAccount() => Card(
      child: ListTile(
          enabled: !isUserSigned,
          title: const Text('Google Account required'),
          subtitle: const Text(
              'StockMeter uses Google Sheets to store and calculate the financial data. '
              'Because of this, it is required a Google Account and granted access to Google Drive. '
              'In any case, the application stores personal data or access other files '
              'beyond the strictly Google Sheets files required to work.'),
          trailing: isUserSigned
              ? null
              : StockElevatedButton(
                  child: const Text('SIGN IN'), onPressed: controller.signIn)));

  Widget _createPortfolioFile() => Card(
      child: ListTile(
          enabled: hasDatasource,
          title: const Text('Create a Portfolio!'),
          subtitle: const Text(
              'Create the first Stock File to start adding your financial data '
              'or configure price alerts.'),
          trailing: hasDatasource ? CreateFileButtonWidget() : null));

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
              child:
                  GenerateExamplesButton(foregroundController: controller))));

  Widget _loadingFile() => Padding(
      padding: const EdgeInsets.all(8.0),
      child: const Text('Loading file...',
          textAlign: TextAlign.center, textScaleFactor: 0.8));
}
