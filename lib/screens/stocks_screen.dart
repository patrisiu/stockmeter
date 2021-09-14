import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/widgets/lastupdate.dart';
import 'package:stockmeter/widgets/stock/google_finance_disclaimer_widget.dart';
import 'package:stockmeter/widgets/stock/stock_card_widget.dart';

class StocksScreen extends StatelessWidget {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _buildStocksScreen(model));

  Widget _buildStocksScreen(AppModel model) {
    List<Widget> _children = [];
    if (model.isUserSigned && model.stockFile != null) {
      _children.addAll(model.stocks
          .map((stock) => new StockCardWidget(stock: stock))
          .toList());
      _children.isNotEmpty
          ? _children.addAll([LastUpdate(), GoogleFinanceDisclaimerWidget()])
          : _children.add(_firstStockDisclaimer());
    }
    return RefreshIndicator(
        onRefresh: () async => await _foregroundController.fetchStocks(),
        child: ListView(
          children: _children,
          physics: const AlwaysScrollableScrollPhysics(),
        ));
  }

  Widget _firstStockDisclaimer() => Container(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: const Text('Add here the first Stock')));
}
