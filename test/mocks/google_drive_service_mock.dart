import 'package:mockito/mockito.dart';
import 'package:stockmeter/services/google_drive_service.dart';

class GoogleDriveServiceMock extends Mock implements GoogleDriveService {
  // Future<List<dynamic>> getSpreadsheetIds(
  //     Map<String, String> authHeaders) async {
  //   List<String> spreadsheetIds = [];
  //   if (authHeaders.containsValue('aValue')) {
  //     spreadsheetIds = ['googleSpreadsheetId1'];
  //   } else if (authHeaders.containsValue('someValues')) {
  //     spreadsheetIds = ['googleSpreadsheetId1', 'googleSpreadsheetId2'];
  //   }
  //   return spreadsheetIds;
  // }
}
