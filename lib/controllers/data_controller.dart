import 'dart:convert';

import 'package:get_it/get_it.dart';
import 'package:stockmeter/builders/stock_builder.dart';
import 'package:stockmeter/daos/stock_dao.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/services/google_drive_service.dart';
import 'package:stockmeter/services/google_spreadsheet_service.dart';

class DataController {
  static const String _stocksRange = 'stocks!A3:T999';
  static const String _stockAppendRange = 'stocks!A3:T3:append';
  static const String _spreadsheetName = 'stocks!J1';

  final GoogleDriveService _googleDriveService =
      GetIt.instance<GoogleDriveService>();
  final GoogleSpreadsheetService _googleSpreadsheetService =
      GetIt.instance<GoogleSpreadsheetService>();

  Future<void> createSheetFile(Map<String, String> authHeaders) async =>
      await _googleDriveService.createSheetFile(authHeaders);

  Future<List<String>> getSpreadsheetIds(
          Map<String, String> authHeaders) async =>
      await _googleDriveService.getSpreadsheetIds(authHeaders);

  Future<String> getSpreadsheetIdsError(Map<String, String> authHeaders) async {
    return await _googleDriveService.getSpreadsheetIdsError(authHeaders);
  }

  Future<List<Stock>> fetchStocks(
      Map<String, String> authHeaders, String spreadsheetId) async {
    final Map<String, dynamic> dataRows = await _googleSpreadsheetService
        .getDataRows(authHeaders, spreadsheetId, _stocksRange);
    final List rowsValues = _googleSpreadsheetService.getRowValues(dataRows);
    rowsValues.removeWhere((element) => element.length == 0);
    return rowsValues.map((row) => StockBuilder().build(row)).toList();
  }

  Future<void> createStock(Map<String, String> authHeaders,
      String spreadsheetId, StockDAO stockDAO) async {
    final String response = await _googleSpreadsheetService.appendDataRows(
        authHeaders,
        spreadsheetId,
        _stockAppendRange,
        stockDAO.rowInputtedValues());
    final String updatedRange = _mapUpdatedRange(response);
    final int row = _mapUpdatedRow(updatedRange);
    await _googleSpreadsheetService.setDataRows(authHeaders, spreadsheetId,
        _stockCreateRange(row), stockDAO.rowCalculatedValues(row));
    await _googleSpreadsheetService.setDataRows(authHeaders, spreadsheetId,
        _stockNotesRange(row), stockDAO.rowNotesValue());
  }

  Future<void> updateStock(Map<String, String> authHeaders,
      String spreadsheetId, StockDAO stockDAO) async {
    await _googleSpreadsheetService.setDataRows(authHeaders, spreadsheetId,
        _stockUpdateRange(stockDAO.rowIndex), stockDAO.rowInputtedValues());
    await _googleSpreadsheetService.setDataRows(authHeaders, spreadsheetId,
        _stockNotesRange(stockDAO.rowIndex), stockDAO.rowNotesValue());
  }

  Future<void> deleteStock(Map<String, String> authHeaders,
          String spreadsheetId, int rowIndex) async =>
      await _googleSpreadsheetService.clearDataRows(
          authHeaders, spreadsheetId, _stockDeleteRange(rowIndex));

  _mapUpdatedRange(String response) =>
      jsonDecode(response)['updates']['updatedRange'];

  int _mapUpdatedRow(String element) {
    final String replaced = element.replaceAll('stocks!A', '');
    final List<String> splitted = replaced.split(':');
    return int.parse(splitted[0]);
  }

  String _stockCreateRange(int rowIndex) => 'stocks!J$rowIndex:S$rowIndex';

  String _stockUpdateRange(int rowIndex) => 'stocks!A$rowIndex:I$rowIndex';

  String _stockDeleteRange(int rowIndex) => 'stocks!A$rowIndex:W$rowIndex';

  String _stockFileNameRange() => 'stocks!J1:J1';

  String _stockNotesRange(int rowIndex) => 'stocks!T$rowIndex:T$rowIndex';

  Future<String?> fetchStockFileName(
      Map<String, String> authHeaders, String spreadsheetId) async {
    final Map<String, dynamic> dataRows = await _googleSpreadsheetService
        .getDataRows(authHeaders, spreadsheetId, _spreadsheetName);
    final List rowsValues = _googleSpreadsheetService.getRowValues(dataRows);
    final List result = rowsValues.expand((rowValue) => rowValue).toList();
    return result.isEmpty
        ? null
        : result.map((rowValue) => rowValue.toString()).toList().first;
  }

  Future<void> deleteSpreadsheetFile(
          Map<String, String> authHeaders, String spreadsheetId) async =>
      await _googleDriveService.deleteDriveFile(authHeaders, spreadsheetId);

  Future<void> setStockFileName(Map<String, String> authHeaders,
          String spreadsheetId, String positionFileName) async =>
      await _googleSpreadsheetService.setDataRows(authHeaders, spreadsheetId,
          _stockFileNameRange(), '{"values": [["$positionFileName"]]}');
}
