import "package:http/http.dart" as http;
import 'package:stockmeter/configurations/constants.dart';

class GoogleDriveService {
  static const String _mimeType = StockConstants.mimeType;
  static const String _fileName = StockConstants.fileName;
  static const String _apiKey = StockConstants.apiKey;

  Future<String> getDriveFiles(Map<String, String> authHeaders) async {
    final http.Response response = await http.get(
        GoogleDriveApiUriRequestGetFilesBuilder(_mimeType, _fileName).build(),
        headers: authHeaders);
    if (response.statusCode != 200) {
      throw Exception(response.reasonPhrase);
    }
    return response.body;
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

  Uri build() =>
      Uri.https(_authority, _unencodedPath + _fileId, {'key': _apiKey});
}

class GoogleDriveApiUriRequestGetFilesBuilder {
  final String _authority = 'www.googleapis.com';
  final String _unencodedPath = '/drive/v3/files';
  final String _mimeType;
  final String _fileName;

  GoogleDriveApiUriRequestGetFilesBuilder(this._mimeType, this._fileName);

  String _encodeQ(String mimeType, String fileName) =>
      'mimeType = "$mimeType" and name = "$fileName"';

  Uri build() => Uri.https(
      _authority, _unencodedPath, {'q': _encodeQ(_mimeType, _fileName)});
}

class GoogleDriveApiUriRequestCopyFileBuilder {
  final String _authority = 'www.googleapis.com';
  final String _unencodedPath = '/drive/v3/files/';
  final String _copy = 'copy';
  final String _apiKey;
  final String _templateId;

  GoogleDriveApiUriRequestCopyFileBuilder(this._apiKey, this._templateId);

  Uri build() => Uri.https(
      _authority, _unencodedPath + _templateId + _copy, {'key': _apiKey});
}
