import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class DeviceNotificationConstrain extends StatelessWidget {
  const DeviceNotificationConstrain({Key? key}) : super(key: key);

  final String _dontKillMyAppURL = 'https://dontkillmyapp.com?app=StockMeter';

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) =>
          _buildDeviceConstrain(context, _isEnabled(model.notificationCheck)));

  _buildDeviceConstrain(BuildContext context, bool isEnabled) => ListTile(
      enabled: isEnabled,
      title: const Text('Device Notification Constrain'),
      subtitle: const Text(
          'Unfortunately, vendors (e.g. Xiaomi, Huawei, OnePlus or even Samsung…) '
          'have their own battery savers into the firmware with each new Android release.\n'
          'This may produce StockMeter unable to check Stock Alerts in the background '
          'unless you actively use your device at the time.\n'
          'In order to minimize this effect, the "Don\'t kill my app!" site explains '
          'how to configure the App in your device. Press here to visit the website.'),
      trailing: Icon(Icons.app_settings_alt_rounded, size: 40),
      onTap: () => _launchURL(_dontKillMyAppURL),
      onLongPress: AppSettings.openAppSettings);

  bool _isEnabled(String notificationCheck) =>
      StockConstants.notificationCheckDisabled != notificationCheck;

  void _launchURL(String url) async => await launcher.canLaunch(url)
      ? await launcher.launch(url)
      : throw 'Could not launch $url';
}
