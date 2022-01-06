import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/widgets/functionalities/functionality_card_widget.dart';

class FunctionalityWidgetList {
  static List<Widget> get() => [
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarSummaryIcon,
            navigationBarLabel: StockConstants.navigationBarSummaryLabel,
            title: 'Overall Position',
            subtitle: 'Overview of the total investments tracked.'),
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarStocksIcon,
            navigationBarLabel: StockConstants.navigationBarStocksLabel,
            title: 'Stocks and Alerts',
            subtitle:
                'Add Stocks investments or just price Alerts in your portfolio to monitor them.'),
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarTrendsIcon,
            navigationBarLabel: StockConstants.navigationBarTrendsLabel,
            title: 'Latest Trends',
            subtitle:
                'Trends of the last few days in the Stocks and Alerts of the Portfolio.'),
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarSettingsIcon,
            navigationBarLabel: StockConstants.navigationBarSettingsLabel,
            title: 'Stock Configuration',
            subtitle:
                'Schedule the frequency to check Stock Alerts in your portfolio. '
                'It can be every 15min or every hour within the range of defined hours.',
            trailingIcon:
                Icon(StockConstants.functionalityStockPriceNotification)),
        FunctionalityCardWidget(
            navigationBarIcon: StockConstants.navigationBarSettingsIcon,
            navigationBarLabel: StockConstants.navigationBarSettingsLabel,
            title: 'Manage different Portfolio files',
            subtitle:
                'More than one file can be handled to monitor different portfolio simulations. '
                'Only the selected Portfolio will trigger the configured alerts in your device.',
            trailingIcon: Icon(StockConstants.functionalityStockFile)),
      ];
}
