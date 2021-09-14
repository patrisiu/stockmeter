import 'package:stockmeter/models/summary.dart';

class SummaryBuilder {
  String? _currency;
  int _stocks = 0;
  double _purchaseCapital = 0;
  double _capitalValue = 0;
  double _grossCapitalGain = 0;
  double _netCapitalGain = 0;
  double _grossProfitDay = 0;
  double _netProfitDay = 0;

  SummaryBuilder(this._currency);

  set addNetProfitDay(double value) {
    _netProfitDay += value;
  }

  set addGrossProfitDay(double value) {
    _grossProfitDay += value;
  }

  set addNetCapitalGain(double value) {
    _netCapitalGain += value;
  }

  set addGrossCapitalGain(double value) {
    _grossCapitalGain += value;
  }

  set addCapitalValue(double value) {
    _capitalValue += value;
  }

  set addPurchaseCapital(double value) {
    _purchaseCapital += value;
  }

  set addStocks(int value) {
    _stocks += value;
  }

  Summary build() {
    Summary summary = new Summary();
    summary.currency = _currency;
    summary.stocks = _stocks;
    summary.purchaseCapital = _purchaseCapital;
    summary.capitalValue = _capitalValue;
    summary.latentProfit =
        _calculateLatentProfit(_capitalValue, _purchaseCapital);
    summary.grossCapitalGain = _grossCapitalGain;
    summary.netCapitalGain = _netCapitalGain;
    summary.grossProfitDay = _grossProfitDay;
    summary.netProfitDay = _netProfitDay;
    return summary;
  }

  double _calculateLatentProfit(double capitalValue, double purchaseCapital) =>
      purchaseCapital == 0 ? 0 : (capitalValue / purchaseCapital) - 1;
}
