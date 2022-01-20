import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:stockmeter/builders/stock_builder.dart';
import 'package:stockmeter/daos/stock_dao.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/services/google_drive_service.dart';
import 'package:stockmeter/services/google_sheets_service.dart';

class DataController {
  static const String _stocksRange = 'stocks!A3:U999';
  static const String _stockAppendRange = 'stocks!A3:J3:append';
  static const String _spreadsheetName = 'stocks!I1';

  final GoogleDriveService _googleDriveService =
      GetIt.instance<GoogleDriveService>();
  final GoogleSheetsService _googleSheetsService =
      GetIt.instance<GoogleSheetsService>();

  Future<String> createSheetFile(Map<String, String> authHeaders) async =>
      _mapSheetId(await _googleSheetsService.createSheetFile(authHeaders));

  Future<String> copySheetFile(
          Map<String, String> authHeaders, String sheetId) async =>
      _mapDriveId(
          await _googleSheetsService.copyDriveFile(authHeaders, sheetId));

  Future<List<String>> getSheetIds(Map<String, String> authHeaders) async {
    String response = await _googleDriveService.getDriveFiles(authHeaders);
    final Map<String, dynamic> data = json.decode(response);
    final List<dynamic> files = data['files'];
    return files.map((file) => file['id']).map((e) => e.toString()).toList();
  }

  Future<List<Stock>> fetchStocks(
      Map<String, String> authHeaders, String spreadsheetId) async {
    final String response = await _googleSheetsService.getDataRows(
        authHeaders, spreadsheetId, _stocksRange);
    final List rowsValues = _getRowValues(json.decode(response));
    rowsValues.removeWhere((element) => element.length == 0);
    return rowsValues.map((row) => StockBuilder().build(row)).toList();
  }

  Future<void> createStock(Map<String, String> authHeaders, String sheetId,
      StockDAO stockDAO) async {
    await _googleSheetsService
        .appendDataRows(authHeaders, sheetId, _stockAppendRange,
            stockDAO.rowInputtedValues())
        .then((response) => _setStockCalculatedValues(
            authHeaders, sheetId, stockDAO, _getUpdatedRowIndex(response)));
  }

  Future<void> updateStock(Map<String, String> authHeaders, String sheetId,
      StockDAO stockDAO) async {
    await _googleSheetsService
        .setDataRows(authHeaders, sheetId, _stockUpdateRange(stockDAO.rowIndex),
            stockDAO.rowInputtedValues())
        .whenComplete(() => _setStockCalculatedValues(
            authHeaders, sheetId, stockDAO, stockDAO.rowIndex));
  }

  Future<void> _setStockCalculatedValues(Map<String, String> authHeaders,
      String sheetId, StockDAO stockDAO, int rowIndex) async {
    await _googleSheetsService
        .setDataRows(authHeaders, sheetId, _stockCreateRange(rowIndex),
            stockDAO.rowCalculatedValues(rowIndex))
        .whenComplete(() async => await _googleSheetsService.setDataRows(
            authHeaders,
            sheetId,
            _stockNotesRange(rowIndex),
            stockDAO.rowNotesValue()));
  }

  Future<void> deleteStock(Map<String, String> authHeaders,
          String spreadsheetId, int rowIndex) async =>
      await _googleSheetsService.clearDataRows(
          authHeaders, spreadsheetId, _stockDeleteRange(rowIndex));

  Future<List> getTrends(
      Map<String, String> authHeaders, String sheetId, String symbol) async {
    final String response = await _googleSheetsService
        .addSheet(authHeaders, sheetId,
            '{"requests":[{"addSheet":{"properties":{"gridProperties":{"columnCount":6,"rowCount":999},"title":"$symbol"}}}]}')
        .then((value) async => await _googleSheetsService.setDataRows(
            authHeaders,
            sheetId,
            _trendSetRange(symbol),
            '{"values": [["=GOOGLEFINANCE(\\"$symbol\\";\\"price\\";TODAY()-100;TODAY())"]]}'))
        .then((value) async => await _googleSheetsService.getDataRows(
            authHeaders, sheetId, _trendGetRange(symbol)));
    return _getRowValues(jsonDecode(response));
  }

  String _mapSheetId(String response) => jsonDecode(response)['spreadsheetId'];

  String _mapDriveId(String response) => jsonDecode(response)['id'];

  int _getUpdatedRowIndex(String response) =>
      _mapUpdatedRow(_mapUpdatedRange(response));

  String _mapUpdatedRange(String response) =>
      jsonDecode(response)['updates']['updatedRange'];

  int _mapUpdatedRow(String element) {
    final String replaced = element.replaceAll('stocks!A', '');
    final List<String> split = replaced.split(':');
    return int.parse(split[0]);
  }

  String _stockCreateRange(int rowIndex) => 'stocks!J$rowIndex:T$rowIndex';

  String _stockUpdateRange(int rowIndex) => 'stocks!A$rowIndex:I$rowIndex';

  String _stockDeleteRange(int rowIndex) => 'stocks!A$rowIndex:X$rowIndex';

  String _stockFileNameRange() => 'stocks!I1:I1';

  String _stockNotesRange(int rowIndex) => 'stocks!U$rowIndex:U$rowIndex';

  String _trendSetRange(String symbol) => '$symbol!A1:A1';

  String _trendGetRange(String symbol) => '$symbol!A2:B999';

  Future<String?> fetchStockFileName(
      Map<String, String> authHeaders, String sheetId) async {
    final String response = await _googleSheetsService.getDataRows(
        authHeaders, sheetId, _spreadsheetName);
    final List rowsValues = _getRowValues(json.decode(response));
    final List result = rowsValues.expand((rowValue) => rowValue).toList();
    return result.isEmpty
        ? null
        : result.map((rowValue) => rowValue.toString()).toList().first;
  }

  Future<void> deleteSheetFile(
          Map<String, String> authHeaders, String sheetId) async =>
      await _googleDriveService.deleteDriveFile(authHeaders, sheetId);

  Future<void> setStockFileName(Map<String, String> authHeaders, String sheetId,
          String stockFileName) async =>
      await _googleSheetsService.setDataRows(authHeaders, sheetId,
          _stockFileNameRange(), '{"values": [["$stockFileName"]]}');

  List<dynamic> _getRowValues(Map<String, dynamic> dataRows) =>
      dataRows.containsKey('values') ? dataRows['values'] : [];
}
