import 'package:stockmeter/models/stock.dart';

class StockBuilder {
  Stock build(List row) {
    Stock stock = new Stock();
    int index = 0;
    stock.symbol = row.elementAt(index++);
    stock.purchaseDate = row.elementAt(index++);
    stock.stocks = int.tryParse(row.elementAt(index++));
    stock.purchasePrice = double.tryParse(row.elementAt(index++));
    stock.currency = row.elementAt(index++);
    stock.fees = double.tryParse(row.elementAt(index++));
    stock.tax = double.tryParse(row.elementAt(index++));
    stock.alertAbove = double.tryParse(row.elementAt(index++));
    stock.alertBelow = double.tryParse(row.elementAt(index++));
    stock.hasToNotify =
        row.elementAt(index++).toString().toUpperCase() == 'TRUE';
    stock.purchaseCapital = double.tryParse(row.elementAt(index++))!;
    stock.price = double.tryParse(row.elementAt(index++))!;
    stock.capitalValue = double.tryParse(row.elementAt(index++))!;
    stock.latentProfit = double.tryParse(row.elementAt(index++))!;
    stock.grossCapitalGain = double.tryParse(row.elementAt(index++))!;
    stock.netCapitalGain = double.tryParse(row.elementAt(index++))!;
    stock.daysOld = int.tryParse(row.elementAt(index++))!;
    stock.grossProfitDay = double.tryParse(row.elementAt(index++))!;
    stock.netProfitDay = double.tryParse(row.elementAt(index++))!;
    stock.rowIndex = int.tryParse(row.elementAt(index++))!;
    stock.notes = row.length == 21 ? row.elementAt(index++) : '';
    return stock;
  }

  Stock buildBlank() {
    List<String> blankRow = [
      // symbol
      '',
      // purchaseDate
      '',
      // stocks
      '',
      // purchasePrice
      '',
      // currency
      '',
      // commissions
      '',
      // fees
      '',
      // alertAbove
      '',
      // alertBelow
      '',
      // hasToNotify
      'TRUE',
      // purchaseCapital
      '0',
      // price
      '0',
      // capitalValue
      '0',
      // latentProfit
      '0',
      // grossCapitalGain
      '0',
      // netCapitalGain
      '0',
      // daysOld
      '0',
      // grossProfitDay
      '0',
      // netProfitDay
      '0',
      // rowNumber
      '0',
      // notes
      ''
    ];
    return build(blankRow);
  }
}
