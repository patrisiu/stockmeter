import 'dart:ui';

import 'package:flutter/material.dart';

class StockConstants {
  static const String appTitle = 'StockMeter';
  static const String mimeType = 'application/vnd.google-apps.spreadsheet';
  static const String fileName = 'com.patrisiu.stockmeter';
  static const String apiKey = 'AIzaSyCglma1HiRgyoM3uDrXFArXuaNUJzRwnV8';

  static const List<String> scopes = [
    'email',
    'https://www.googleapis.com/auth/drive.file'
  ];
  static const int summaryScreen = 0;
  static const int stocksScreen = 1;
  static const int trendsScreen = 2;
  static const int settingsScreen = 3;

  static const String uniqueNameTask = 'StockMeterPeriodicTask';
  static const String taskName = 'StockMeterPositionUpdate';

  static const String sheetId = 'spreadsheetId';

  static const String navigationBarSummaryLabel = 'Summary';
  static const IconData navigationBarSummaryIcon = Icons.dashboard_rounded;
  static const String navigationBarStocksLabel = 'Stocks';
  static const IconData navigationBarStocksIcon = Icons.card_travel_rounded;
  static const String navigationBarTrendsLabel = 'Trends';
  static const IconData navigationBarTrendsIcon = Icons.trending_up_rounded;
  static const String navigationBarSettingsLabel = 'Settings';
  static const IconData navigationBarSettingsIcon = Icons.settings;

  static const IconData functionalityStockPriceNotification =
      Icons.notifications_on_rounded;
  static const IconData functionalityStockFile = Icons.file_copy_rounded;

  static const String notificationCheck = 'notificationCheck';
  static const String notificationCheckDisabled = 'Disabled';
  static const String notificationCheck2m = '2m';
  static const String notificationCheck15m = '15m';
  static const String notificationCheck1h = '1h';

  static const String startNotification = 'startNotification';
  static const String endNotification = 'endNotification';

  static const String sortBy = 'sortBy';
  static const String symbol = 'Symbol';
  static const String stocks = 'Stocks';
  static const String currency = 'Currency';
  static const String purchaseDate = 'Purchase Date';
  static const String purchasePrice = 'Purchase Price';

  static const String purchaseCapital = 'Purchase Capital';
  static const String notes = 'Notes';
  static const String fees = 'Commissions & Fees';
  static const String tax = 'Tax';
  static const String alertAbove = 'Alert Above';
  static const String alertBelow = 'Alert Below';
  static const String price = 'Price';

  static const String grossGain = 'Gross Gain';

  static const String netGain = 'Net Gain';
  static const String profit = 'Latent Profit';
  static const String capitalValue = 'Capital Value';
  static const String profitDay = 'Profit/Day';

  static const String daysOld = 'Days Old';

  static const String notANumber = 'Not a Number';

  static const String debug = 'debug';
  static const String debugNotification = 'debugNotification';

  static const Color activeColor = Color(0xFF0097A7);
}
