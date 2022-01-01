import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/widgets/functionalities/functionality_card_widget.dart';

class FunctionalityWidgetList {
  static List<Widget> get() => [
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarSummaryIcon,
            navigationBarLabel: StockConstants.navigationBarSummaryLabel,
            title: 'Quick view to the Stocks position',
            subtitle: 'Summery of the investments and values'),
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarStocksIcon,
            navigationBarLabel: StockConstants.navigationBarStocksLabel,
            title:
                'Add Stocks investments or monitoring alarms to your portfolio',
            subtitle:
                'Track the current investments or just alerts points on market options'),
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarTrendsIcon,
            navigationBarLabel: StockConstants.navigationBarTrendsLabel,
            title: 'Check positions historic track',
            subtitle: 'Work In Progress'),
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarSettingsIcon,
            navigationBarLabel: StockConstants.navigationBarSettingsLabel,
            title: 'Configure receive stock price notifications',
            subtitle:
                'Every 15min or hourly, during the schedule hours configured.',
            trailingIcon:
                Icon(StockConstants.functionalityStockPriceNotification)),
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarSettingsIcon,
            navigationBarLabel: StockConstants.navigationBarSettingsLabel,
            title: 'Handle different stock position files',
            subtitle: 'Manage different files',
            trailingIcon: Icon(StockConstants.functionalityStockFile)),
      ];
}
