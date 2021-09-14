import 'package:stockmeter/models/stock.dart';

class StockDAO {
  static const String _neutralValue = '0';

  late String symbol;
  String? purchaseDate;
  String? stocks;
  String? purchasePrice;
  String? currency;
  String? fees;
  String? tax;
  String? alertAbove;
  String? alertBelow;
  String? notes;
  late int _rowIndex;

  StockDAO(Stock stock) {
    symbol = stock.symbol;
    stocks = stock.stocks?.toString();
    purchaseDate = stock.purchaseDate;
    purchasePrice = stock.purchasePrice?.toString();
    currency = stock.currency;
    fees = stock.fees?.toString();
    tax = stock.tax?.toString();
    alertAbove = stock.alertAbove?.toString();
    alertBelow = stock.alertBelow?.toString();
    notes = stock.notes;
    _rowIndex = stock.rowIndex;
  }

  void applyOnlyAlert() {
    stocks = _neutralValue;
    purchaseDate = _todayDate();
    purchasePrice ??= _neutralValue;
    currency ??= _neutralValue;
    fees ??= _neutralValue;
    tax ??= _neutralValue;
  }

  String rowInputtedValues() => '{"values": [['
      '"$symbol", '
      '"$purchaseDate", '
      '"$stocks", '
      '"$purchasePrice", '
      '"$currency", '
      '"$fees", '
      '"$tax", '
      '"$alertAbove", '
      '"$alertBelow"'
      ']]}';

  String rowCalculatedValues(int rowIndex) => '{"values": [['
      '"=C$rowIndex*D$rowIndex", '
      '"=IFERROR(GOOGLEFINANCE(A$rowIndex);$_neutralValue)", '
      '"=C$rowIndex*K$rowIndex", '
      '"=IF(D$rowIndex,K$rowIndex/D$rowIndex-1,0)", '
      '"=L$rowIndex-J$rowIndex", '
      '"=IF(N$rowIndex>0,N$rowIndex-N$rowIndex*G$rowIndex-F$rowIndex,N$rowIndex)", '
      '"=IF(C$rowIndex,TODAY()-B$rowIndex,0)", '
      '"=IF(P$rowIndex,N$rowIndex/P$rowIndex,0)", '
      '"=IF(P$rowIndex,O$rowIndex/P$rowIndex,0)", '
      '"=ROW()"'
      ']]}';

  String rowNotesValue() => '{"values": [["=T(\\\"$notes\\\")"]]}';

  String _todayDate() {
    DateTime today = DateTime.now();
    return today.day.toString() +
        '/' +
        today.month.toString() +
        '/' +
        today.year.toString();
  }

  int get rowIndex => _rowIndex;
}
