import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:stockmeter/configurations/constants.dart';

class GoogleSpreadsheetService {
  static const String _apiKey = StockConstants.apiKey;

  Future<Map<String, dynamic>> getDataRows(Map<String, String> authHeaders,
      String spreadsheetId, String range) async {
    final http.Response response = await http.get(
        new GoogleSpreadsheetApiUriRequestBuilder(spreadsheetId, range).build(),
        headers: authHeaders);
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    return json.decode(response.body);
  }

  List getRowValues(Map<String, dynamic> dataRows) => dataRows['values'];

  Future<void> setDataRows(Map<String, String> authHeaders,
      String spreadsheetId, String range, String body) async {
    authHeaders.addAll(
        {'Accept': 'application/json', 'Content-Type': 'application/json'});
    final http.Response response = await http.put(
      _builderUri(spreadsheetId, range),
      headers: authHeaders,
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
  }

  Uri _builderUri(String spreadsheetId, String range) {
    return Uri.https(
        'sheets.googleapis.com',
        '/v4/spreadsheets/$spreadsheetId/values/$range',
        {'valueInputOption': 'USER_ENTERED', 'key': _apiKey});
  }

  Future<String> appendDataRows(Map<String, String> authHeaders,
      String spreadsheetId, String range, String body) async {
    authHeaders.addAll(
        {'Accept': 'application/json', 'Content-Type': 'application/json'});
    final http.Response response = await http.post(
      _builderUri(spreadsheetId, range),
      headers: authHeaders,
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
    return response.body;
  }

  Future<void> clearDataRows(Map<String, String> authHeaders,
      String spreadsheetId, String range) async {
    final http.Response response = await http.post(
        Uri.https(
            'sheets.googleapis.com',
            '/v4/spreadsheets/$spreadsheetId/values/$range:clear',
            {'key': _apiKey}),
        headers: authHeaders,
        body: '{}');
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}

class GoogleSpreadsheetApiUriRequestBuilder {
  final String _baseApiUrl = 'sheets.googleapis.com';
  final String wop = '/v4/spreadsheets/';
  final String _spreadsheetId;
  final String _values = '/values/';
  final String _range;

  final Map<String, String> _majorDimension = {'majorDimension': 'ROWS'};

  GoogleSpreadsheetApiUriRequestBuilder(this._spreadsheetId, this._range);

  Uri build() => Uri.https(
      _baseApiUrl, wop + _spreadsheetId + _values + _range, _majorDimension);
}

class GoogleSpreadsheetApiUriRequestSetDataBuilder {
  final String _baseApiUrl = 'sheets.googleapis.com';
  final String wop = '/v4/spreadsheets/';
  final String _spreadsheetId;
  final String _values = '/values/';
  final String _range;

  final Map<String, String> _majorDimension = {'majorDimension': 'ROWS'};

  GoogleSpreadsheetApiUriRequestSetDataBuilder(this._spreadsheetId, this._range);

  Uri build() => Uri.https(
      _baseApiUrl, wop + _spreadsheetId + _values + _range, _majorDimension);
}
