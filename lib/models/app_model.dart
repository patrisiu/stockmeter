import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/auth_model.dart';
import 'package:stockmeter/models/screen.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/models/stock_file.dart';
import 'package:stockmeter/models/summary.dart';
import 'package:stockmeter/models/trend_chart_model.dart';

class AppModel extends Model with ScreenModel, AuthModel {
  BuildContext? context;

  Summary? _summary;
  List<Stock> _stocks = [];
  Map<String, List<TrendModel>> _trends = new Map();
  DateTime? _lastUpdate;
  late String _sortBy;

  StockFile? stockFile;
  List<StockFile> stockFiles = [];

  bool _debugNotification = false;

  bool _createFileOption = false;

  String _notificationCheck = StockConstants.notificationCheckDisabled;

  String get notificationCheck => _notificationCheck;

  set notificationCheck(String value) {
    _notificationCheck = value;
    notifyListeners();
  }

  bool get debugNotification => _debugNotification;

  set debugNotification(bool value) {
    _debugNotification = value;
    notifyListeners();
  }

  bool get createFileOption => _createFileOption;

  set createFileOption(bool value) {
    _createFileOption = value;
    notifyListeners();
  }

  Summary? get summary => _summary;

  set summary(Summary? value) {
    _summary = value;
    _lastUpdate = DateTime.now();
    notifyListeners();
  }

  DateTime? get lastUpdate => _lastUpdate;

  List<Stock> get stocks => _stocks;

  set stocks(List<Stock> value) {
    _stocks = value;
    _lastUpdate = DateTime.now();
    if (_stocks.isNotEmpty) {
      _sortStocks();
    } else {
      _trends = new Map();
    }
    notifyListeners();
  }

  Map<String, List<TrendModel>> get trends => _trends;

  set trends(Map<String, List<TrendModel>> value) {
    _trends = value;
    notifyListeners();
  }

  void removeUnneededTrends(Set<String> symbols) {
    _trends.removeWhere((key, value) => symbols.any((symbol) => symbol == key));
    notifyListeners();
  }

  void updateTrend(String symbol, List<TrendModel> trend) {
    _trends.update(symbol, (value) => trend, ifAbsent: () => trend);
    notifyListeners();
  }

  void setSortBy(String value) {
    _sortBy = value;
  }

  void _sortStocks() {
    switch (_sortBy) {
      case StockConstants.daysOld:
        _stocks.sort((a, b) => b.daysOld.compareTo(a.daysOld));
        break;
      case StockConstants.profitDay:
        _stocks.sort((a, b) => b.netProfitDay.compareTo(a.netProfitDay));
        break;
      case StockConstants.capitalValue:
        _stocks.sort((a, b) => b.capitalValue.compareTo(a.capitalValue));
        break;
      case StockConstants.netGain:
        _stocks.sort((a, b) => b.netCapitalGain.compareTo(a.netCapitalGain));
        break;
      case StockConstants.profit:
        _stocks.sort((a, b) => b.latentProfit.compareTo(a.latentProfit));
        break;
      default:
        break;
    }
  }
}
