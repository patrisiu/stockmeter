import 'package:get_it/get_it.dart';
import 'package:stockmeter/controllers/background_controller.dart';
import 'package:stockmeter/controllers/data_controller.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/services/google_auth_service.dart';
import 'package:stockmeter/services/google_drive_service.dart';
import 'package:stockmeter/services/google_spreadsheet_service.dart';

class Dependencies {
  static Future<void> configure() async {
    GetIt.I.registerSingleton<GoogleAuthService>(GoogleAuthService());
    GetIt.I.registerSingleton<GoogleSpreadsheetService>(
        GoogleSpreadsheetService());
    GetIt.I.registerSingleton<GoogleDriveService>(GoogleDriveService());
    GetIt.I.registerSingleton<DataController>(DataController());
    GetIt.I.registerSingleton<BackgroundController>(BackgroundController());
    GetIt.I.registerSingleton<ForegroundController>(ForegroundController());
  }
}
