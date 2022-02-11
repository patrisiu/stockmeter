import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/widgets/last_update.dart';
import 'package:stockmeter/widgets/stock/google_finance_disclaimer_widget.dart';
import 'package:stockmeter/widgets/stock/stock_card_widget.dart';
import 'package:stockmeter/widgets/user_state_widget.dart';

class StocksScreen extends StatelessWidget {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => UserStateWidget(
          isUserSigned: model.isUserSigned,
          hasDatasource: model.stockFile != null,
          hasData: model.stocks.isNotEmpty,
          isCreateFileOptionReady: model.createFileOption,
          controller: _foregroundController,
          widget: _buildStocksScreen(model.stocks)));

  Widget _buildStocksScreen(List<Stock> stocks) {
    List<Widget> _children = [];
    _children.addAll(
        stocks.map((stock) => new StockCardWidget(stock: stock)).toList());
    _children.addAll([LastUpdate(), GoogleFinanceDisclaimerWidget()]);
    return RefreshIndicator(
        onRefresh: () async => await _foregroundController.fetchStocks(),
        child: ListView(
            children: _children,
            physics: const AlwaysScrollableScrollPhysics()));
  }
}
