import 'dart:convert';

import "package:http/http.dart" as http;
import 'package:stockmeter/configurations/constants.dart';

class GoogleDriveService {
  static const String _mimeType = StockConstants.mimeType;
  static const String _fileName = StockConstants.fileName;
  static const String _apiKey = StockConstants.apiKey;
  static const String _templateId = StockConstants.templateId;

  Future<void> createSheetFile(Map<String, String> authHeaders) async {
    String data = '{"mimeType": "$_mimeType", "name": "$_fileName"}';
    authHeaders.addAll(
        {'Accept': 'application/json', 'Content-Type': 'application/json'});
    final http.Response response = await http.post(
      Uri.https('www.googleapis.com', '/drive/v3/files/$_templateId/copy',
          {'key': _apiKey}),
      headers: authHeaders,
      body: data,
    );
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
  }

  Future<List<String>> getSpreadsheetIds(
      Map<String, String> authHeaders) async {
    final http.Response response = await http.get(
        GoogleDriveApiUriRequestBuilder(_mimeType, _fileName).build(),
        headers: authHeaders);
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    final Map<String, dynamic> data = json.decode(response.body);
    final List<dynamic> files = data['files'];
    return files.map((file) => file['id']).map((e) => e.toString()).toList();
  }

  Future<String> getSpreadsheetIdsError(authHeaders) async {
    Uri uri = GoogleDriveApiUriRequestBuilder(_mimeType, _fileName).build();
    final http.Response response = await http.get(uri, headers: authHeaders);
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    return uri.toString();
  }

  Future<void> deleteDriveFile(
      Map<String, String> authHeaders, String fileId) async {
    final http.Response response = await http.delete(
        GoogleDriveApiUriRequestDeleteFileBuilder(fileId, _apiKey).build(),
        headers: authHeaders);
    if (response.statusCode != 204) {
      throw Exception(response.reasonPhrase);
    }
  }
}

class GoogleDriveApiUriRequestDeleteFileBuilder {
  final String _authority = 'www.googleapis.com';
  final String _unencodedPath = '/drive/v3/files/';
  final String _fileId;
  final String _apiKey;

  GoogleDriveApiUriRequestDeleteFileBuilder(this._fileId, this._apiKey);

  Uri build() {
    return Uri.https(_authority, _unencodedPath + _fileId, {'key': _apiKey});
  }
}

class GoogleDriveApiUriRequestBuilder {
  final String _authority = 'www.googleapis.com';
  final String _unencodedPath = '/drive/v3/files';
  final String _mimeType;
  final String _fileName;

  GoogleDriveApiUriRequestBuilder(this._mimeType, this._fileName);

  String _encodeQ(String mimeType, String fileName) {
    return 'mimeType = "$mimeType" and name = "$fileName"';
  }

  Uri build() {
    return Uri.https(
        _authority, _unencodedPath, {'q': _encodeQ(_mimeType, _fileName)});
  }
}
