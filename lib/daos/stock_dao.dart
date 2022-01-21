import 'package:stockmeter/models/stock.dart';

class StockDAO {
  static const String neutralValue = '0';
  static const String _errorValue = '404';
  static const String _symbolSeparator = ':';

  late String symbol;
  String? purchaseDate;
  String? stocks;
  String? purchasePrice;

  String? fees;
  String? tax;
  String? alertAbove;
  String? alertBelow;
  late bool hasToNotify;
  String? notes;
  late int _rowIndex;

  StockDAO(
      this.symbol,
      this.purchaseDate,
      this.stocks,
      this.purchasePrice,
      this.fees,
      this.tax,
      this.alertAbove,
      this.alertBelow,
      this.hasToNotify,
      this.notes,
      this._rowIndex);

  StockDAO.clone(StockDAO stockDAO)
      : this(
            stockDAO.symbol,
            stockDAO.purchaseDate,
            stockDAO.stocks,
            stockDAO.purchasePrice,
            stockDAO.fees,
            stockDAO.tax,
            stockDAO.alertAbove,
            stockDAO.alertBelow,
            stockDAO.hasToNotify,
            stockDAO.notes,
            stockDAO._rowIndex);

  StockDAO.fromStock(Stock stock) {
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

  String rowInputtedValues() => '{"values": [['
      '"$symbol", '
      '"$purchaseDate", '
      '"$stocks", '
      '"$purchasePrice", '
      '"$fees", '
      '"$tax", '
      '"$alertAbove", '
      '"$alertBelow", '
      '"$hasToNotify"'
      ']]}';

  String rowCalculatedValues(int rowIndex) => '{"values": [['
      '"${_currency(symbol, rowIndex)}", '
      '"=C$rowIndex*D$rowIndex", '
      '"=IFERROR(GOOGLEFINANCE(A$rowIndex);$neutralValue)", '
      '"=C$rowIndex*L$rowIndex", '
      '"=IF(D$rowIndex,L$rowIndex/D$rowIndex-1,0)", '
      '"=M$rowIndex-K$rowIndex", '
      '"=IF(O$rowIndex>0,O$rowIndex-O$rowIndex*F$rowIndex-E$rowIndex,O$rowIndex)", '
      '"=IF(C$rowIndex,TODAY()-B$rowIndex,0)", '
      '"=IF(Q$rowIndex,O$rowIndex/Q$rowIndex,0)", '
      '"=IF(Q$rowIndex,P$rowIndex/Q$rowIndex,0)", '
      '"=ROW()"'
      ']]}';

  String rowNotesValue() => '{"values": [["=T(\\\"$notes\\\")"]]}';

  int get rowIndex => _rowIndex;

  String _currency(String symbol, int rowIndex) {
    List<String> symbolParts = symbol.split(':');
    return symbolParts[0] == 'CURRENCY' || symbolParts[0] == 'INDEXEURO'
        ? symbolParts[1]
        : '=IFERROR(GOOGLEFINANCE(A$rowIndex;\\"currency\\");\\"$_errorValue\\")';
  }

  static bool isValidSymbol(String? value) {
    if (_isBlank(value) || !value!.contains(_symbolSeparator)) {
      return false;
    } else {
      List<String> split = value.split(_symbolSeparator);
      return split[0].isNotEmpty && split[1].isNotEmpty;
    }
  }

  static bool isValidStocks(String? value) {
    if (_isBlank(value)) {
      return false;
    } else {
      int? input = int.tryParse(value!);
      return input != null && input >= 1;
    }
  }

  static bool isValidPurchasePrice(String? value) => !_isNotNumber(value);

  static bool isValidFees(String? value) => !_isNotNumber(value);

  static bool isValidTax(String? value) {
    double? input = double.tryParse(value!);
    return input != null && input >= 0 && input <= 1;
  }

  static bool isValidAlert(String? value) => !_isNotNumber(value);

  static bool _isNotNumber(String? value) =>
      value == null || (value.isNotEmpty && double.tryParse(value) == null);

  static bool _isBlank(String? value) {
    return value == null || value.isEmpty;
  }
}
