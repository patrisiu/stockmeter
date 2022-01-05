import 'package:intl/intl.dart';
import 'package:stockmeter/models/stock.dart';

class StockDAO {
  static const String _neutralValue = '0';
  static const String _errorValue = '404';

  late String symbol;
  String? purchaseDate;
  String? stocks;
  String? purchasePrice;

  // String? currency;
  String? fees;
  String? tax;
  String? alertAbove;
  String? alertBelow;
  late bool hasToNotify;
  String? notes;
  late int _rowIndex;

  StockDAO(Stock stock) {
    symbol = stock.symbol;
    stocks = stock.stocks?.toString();
    purchaseDate = stock.purchaseDate;
    purchasePrice = stock.purchasePrice?.toString();
    fees = stock.fees?.toString();
    tax = stock.tax?.toString();
    alertAbove = stock.alertAbove?.toString();
    alertBelow = stock.alertBelow?.toString();
    hasToNotify = stock.hasToNotify;
    notes = stock.notes;
    _rowIndex = stock.rowIndex;
  }

  void applyOnlyAlert() {
    stocks = _neutralValue;
    purchaseDate = _todayDate();
    purchasePrice ??= _neutralValue;
    fees ??= _neutralValue;
    tax ??= _neutralValue;
  }

  String rowInputtedValues() => '{"values": [['
      '"$symbol", '
      '"$purchaseDate", '
      '"$stocks", '
      '"$purchasePrice", '
      '"${_currency(symbol)}", '
      '"$fees", '
      '"$tax", '
      '"$alertAbove", '
      '"$alertBelow", '
      '"$hasToNotify"'
      ']]}';

  String rowCalculatedValues(int rowIndex) => '{"values": [['
      '"=C$rowIndex*D$rowIndex", '
      '"=IFERROR(GOOGLEFINANCE(A$rowIndex);$_neutralValue)", '
      '"=C$rowIndex*L$rowIndex", '
      '"=IF(D$rowIndex,L$rowIndex/D$rowIndex-1,0)", '
      '"=M$rowIndex-K$rowIndex", '
      '"=IF(O$rowIndex>0,O$rowIndex-O$rowIndex*G$rowIndex-F$rowIndex,O$rowIndex)", '
      '"=IF(C$rowIndex,TODAY()-B$rowIndex,0)", '
      '"=IF(Q$rowIndex,O$rowIndex/Q$rowIndex,0)", '
      '"=IF(Q$rowIndex,P$rowIndex/Q$rowIndex,0)", '
      '"=ROW()"'
      ']]}';

  String rowNotesValue() => '{"values": [["=T(\\\"$notes\\\")"]]}';

  String _todayDate() => DateFormat('dd/MM/yyyy').format(DateTime.now());

  String _currency(String symbol) {
    List<String> symbolParts = symbol.split(':');
    return symbolParts[0] == 'CURRENCY' || symbolParts[0] == 'INDEXEURO'
        ? symbolParts[1]
        : '=IFERROR(GOOGLEFINANCE(\\"$symbol\\";\\"currency\\");\\"$_errorValue\\")';
  }

  int get rowIndex => _rowIndex;
}
