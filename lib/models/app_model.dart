import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/auth_model.dart';
import 'package:stockmeter/models/screen.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/models/stock_file.dart';
import 'package:stockmeter/models/summary.dart';

class AppModel extends Model with ScreenModel, AuthModel {
  BuildContext? context;

  Summary? _summary;
  List<Stock> _stocks = [];
  DateTime? _lastUpdate;
  late String _sortBy;

  StockFile? _stockFile;
  List<StockFile> _stockFiles = [];

  StockFile? get stockFile => _stockFile;

  set stockFile(StockFile? value) {
    _stockFile = value;
  }

  bool _createFileOption = false;

  String _notificationCheck = StockConstants.notificationCheckDisabled;

  String get notificationCheck => _notificationCheck;

  set notificationCheck(String value) {
    _notificationCheck = value;
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

  String get lastUpdate => _lastUpdate?.toString() ?? 'None';

  List<Stock> get stocks => _stocks;

  set stocks(List<Stock> value) {
    _stocks = value;
    _lastUpdate = DateTime.now();
    if (_stocks.isNotEmpty && _sortBy != 'Raw Data') {
      _sortStocks();
    }
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
    }
  }

  List<StockFile> get stockFiles => _stockFiles;

  set stockFiles(List<StockFile> value) {
    _stockFiles = value;
  }
}