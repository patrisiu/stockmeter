import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/mockito.dart';
import 'package:stockmeter/controllers/data_controller.dart';
import 'package:stockmeter/services/google_drive_service.dart';
import 'package:stockmeter/services/google_spreadsheet_service.dart';

import '../mocks/google_drive_service_mock.dart';
import '../mocks/google_speradhseet_service_mock.dart';

class MockDataController extends Mock implements DataController {}

void main() {
  GetIt.I.registerSingleton<GoogleDriveService>(GoogleDriveServiceMock());
  GetIt.I.registerSingleton<GoogleSpreadsheetService>(
      GoogleSpreadsheetServiceMock());

  group('getSpreadsheetIds', () {

    test('should return any value', () async {
      Map<String, String> authHeaders = {'authHeaders': 'anyValue'};
      List<dynamic> result =
      await DataController().getSpreadsheetIds(authHeaders);
      expect(result.length, 0);
    });

    test('should return one value', () async {
      Map<String, String> authHeaders = {'authHeaders': 'aValue'};
      List<dynamic> result =
          await DataController().getSpreadsheetIds(authHeaders);
      expect(result.length, 1);
      expect(result[0], 'googleSpreadsheetId1');
    });

    test('should return two values', () async {
      Map<String, String> authHeaders = {'authHeaders': 'someValues'};
      List<dynamic> result =
      await DataController().getSpreadsheetIds(authHeaders);
      expect(result.length, 2);
      expect(result[0], 'googleSpreadsheetId1');
      expect(result[1], 'googleSpreadsheetId2');
    });
  });
}
