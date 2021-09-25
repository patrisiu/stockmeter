import "package:http/http.dart" as http;
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/utils/sheet_data.dart';

class GoogleSheetsService {
  static const String _apiKey = StockConstants.apiKey;
  static const Map<String, String> _applicationJsonHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  Future<String> createSheetFile(Map<String, String> authHeaders) async {
    authHeaders.addAll(_applicationJsonHeaders);
    final http.Response response = await http.post(
      GoogleSheetsApiUriRequestCreateFileBuilder(_apiKey).build(),
      headers: authHeaders,
      body: SheetData().create(),
    );
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    return response.body;
  }

  Future<String> getDataRows(
      Map<String, String> authHeaders, String sheetId, String range) async {
    final http.Response response = await http.get(
        new GoogleSheetsApiUriRequestGetDataBuilder(sheetId, range).build(),
        headers: authHeaders);
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    return response.body;
  }

  Future<void> setDataRows(Map<String, String> authHeaders, String sheetId,
      String range, String body) async {
    authHeaders.addAll(_applicationJsonHeaders);
    final http.Response response = await http.put(
      GoogleSheetsApiUriRequestInputDataBuilder(sheetId, range, _apiKey)
          .build(),
      headers: authHeaders,
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<String> appendDataRows(Map<String, String> authHeaders, String sheetId,
      String range, String body) async {
    authHeaders.addAll(_applicationJsonHeaders);
    final http.Response response = await http.post(
      GoogleSheetsApiUriRequestInputDataBuilder(sheetId, range, _apiKey)
          .build(),
      headers: authHeaders,
      body: body,
    );
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
    return response.body;
  }

  Future<void> clearDataRows(
      Map<String, String> authHeaders, String sheetId, String range) async {
    final http.Response response = await http.post(
        GoogleSheetsApiUriRequestClearDataBuilder(sheetId, range, _apiKey)
            .build(),
        headers: authHeaders,
        body: '{}');
    if (response.statusCode != 200) {
      throw Exception(response.body);
    }
  }
}

class GoogleSheetsApiUriRequestCreateFileBuilder {
  final String _baseApiUrl = 'sheets.googleapis.com';
  final String _unencodedPath = '/v4/spreadsheets';
  final String _apiKey;

  GoogleSheetsApiUriRequestCreateFileBuilder(this._apiKey);

  Uri build() => Uri.https(_baseApiUrl, _unencodedPath, {'key': _apiKey});
}

class GoogleSheetsApiUriRequestGetDataBuilder {
  final Map<String, String> _majorDimension = {'majorDimension': 'ROWS'};
  final String _baseApiUrl = 'sheets.googleapis.com';
  final String wop = '/v4/spreadsheets/';
  final String _values = '/values/';
  final String _sheetId;
  final String _range;

  GoogleSheetsApiUriRequestGetDataBuilder(this._sheetId, this._range);

  Uri build() => Uri.https(
      _baseApiUrl, wop + _sheetId + _values + _range, _majorDimension);
}

class GoogleSheetsApiUriRequestInputDataBuilder {
  final String _baseApiUrl = 'sheets.googleapis.com';
  final String _unencodedPath = '/v4/spreadsheets/';
  final String _values = '/values/';
  final String _sheetId;
  final String _range;
  final String _apiKey;

  GoogleSheetsApiUriRequestInputDataBuilder(
      this._sheetId, this._range, this._apiKey);

  Uri build() => Uri.https(
      _baseApiUrl,
      _unencodedPath + _sheetId + _values + _range,
      {'valueInputOption': 'USER_ENTERED', 'key': _apiKey});
}

class GoogleSheetsApiUriRequestClearDataBuilder {
  final String _baseApiUrl = 'sheets.googleapis.com';
  final String _unencodedPath = '/v4/spreadsheets/';
  final String _values = '/values/';
  final String _clear = ':clear';
  final String _sheetId;
  final String _range;
  final String _apiKey;

  GoogleSheetsApiUriRequestClearDataBuilder(
      this._sheetId, this._range, this._apiKey);

  Uri build() => Uri.https(_baseApiUrl,
      _unencodedPath + _sheetId + _values + _range + _clear, {'key': _apiKey});
}