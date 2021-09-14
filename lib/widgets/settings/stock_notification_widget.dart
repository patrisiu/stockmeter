import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/background_controller.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/notifications/foreground_notification.dart';

class StockNotificationWidget extends StatelessWidget {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();
  final BackgroundController _backgroundController =
      GetIt.instance<BackgroundController>();

  final Widget _configurationDisclaimer =
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const Text(
        'Autostart Permission should be enabled to ensure Stock Notification '
        'works when the application runs in the background.'),
    const Text('Long Press here to open App Settings.')
  ]);

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _buildStockNotificationWidget(
          context,
          model.isUserSigned && model.stockFile != null,
          model.notificationCheck));

  Widget _buildStockNotificationWidget(
          BuildContext context, bool isEnabled, String notificationCheck) =>
      ListTile(
        enabled: isEnabled,
        title: const Text('Stock Notification'),
        subtitle: _configurationDisclaimer,
        trailing: ElevatedButton(
            child: Text(notificationCheck),
            onPressed: isEnabled
                ? () => _showNotificationCheckOptions(context)
                : null),
        onLongPress: AppSettings.openAppSettings,
      );

  void _showNotificationCheckOptions(BuildContext context) {
    List<String> _options = [
      StockConstants.notificationCheck2m,
      StockConstants.notificationCheck15m,
      StockConstants.notificationCheck1h,
    ];
    List<Widget> _elements = [
      Divider(thickness: 1),
      ListTile(
          title: const Text(
              'Enable Stock Notification in your Stock File selected.'),
          subtitle: _configurationDisclaimer,
          onLongPress: AppSettings.openAppSettings),
      Divider(thickness: 1),
      ListTile(
          onTap: () => _disableNotificationCheck(context),
          leading: Icon(Icons.location_disabled_rounded),
          title: const Text('Disable Stock Notification')),
      Divider(thickness: 1),
    ];

    _options.forEach((option) {
      _elements.add(ListTile(
          onTap: () => _enableNotificationCheck(context, option),
          leading: Icon(Icons.update_rounded),
          title: Text('Stock Notification every $option.')));
      _elements.add(Divider(thickness: 1));
    });

    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) => ListView(children: _elements));
  }

  void _disableNotificationCheck(BuildContext context) {
    Navigator.of(context).pop();
    _foregroundController.notificationCheck =
        StockConstants.notificationCheckDisabled;
    _backgroundController.disableNotificationCheck();
  }

  Future<void> _enableNotificationCheck(
      BuildContext context, String option) async {
    Navigator.of(context).pop();
    _foregroundController.notificationCheck = option;
    _backgroundController.enableNotificationCheck(option);
    if (option == StockConstants.notificationCheck2m) {
      _infoBatteryWarning(context);
    } else if (option != StockConstants.notificationCheckDisabled) {
      _infoAppSettingsRequirement(context);
    }
  }

  void _infoBatteryWarning(BuildContext context) => ForegroundNotification()
      .info(context, 'This option may drain the battery!');

  void _infoAppSettingsRequirement(BuildContext context) {
    ForegroundNotification().infoWithAction(
        context,
        'Autostart Permission must be enabled to allow StockMeter run in the background.',
        SnackBarAction(
            label: 'App Settings',
            textColor: Colors.white70,
            onPressed: AppSettings.openAppSettings));
  }
}
