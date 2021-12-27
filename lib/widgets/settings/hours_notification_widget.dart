import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';

class HoursNotificationWidget extends StatefulWidget {
  @override
  _HoursNotificationWidgetState createState() =>
      _HoursNotificationWidgetState();
}

class _HoursNotificationWidgetState extends State<HoursNotificationWidget> {
  ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _buildHoursNotificationWidget(
          StockConstants.notificationCheckDisabled != model.notificationCheck));

  Widget _buildHoursNotificationWidget(bool isEnabled) => ListTile(
      enabled: isEnabled,
      title: const Text('Notification Range Hours'),
      subtitle: _hoursRageSliderWithHelpValues(isEnabled));

  Widget _hoursRageSliderWithHelpValues(bool isEnabled) => Column(children: [
        _hoursRageSlider(isEnabled),
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [const Text('00:00h'), const Text('23:59h')])
      ]);

  Widget _hoursRageSlider(bool isEnabled) {
    RangeValues _currentRangeValues =
    _foregroundController.getHoursAlertNotification();
    return RangeSlider(
        values: _currentRangeValues,
        min: 0,
        max: 24,
        divisions: 25,
        labels: RangeLabels(
          _currentRangeValues.start.round().toString() + 'h',
          _currentRangeValues.end.round().toString() + 'h',
        ),
        activeColor: isEnabled ? StockConstants.activeColor : Colors.white12,
        inactiveColor: isEnabled ? Colors.white12 : Colors.white12,
        onChanged: (RangeValues values) {
          if (isEnabled) {
            _foregroundController.setHoursAlertNotification(values);
            setState(() {
              _currentRangeValues = values;
            });
          }
        });
  }
}
