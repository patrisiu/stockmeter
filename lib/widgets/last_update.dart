import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/models/app_model.dart';

class LastUpdate extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) =>
          _buildLastUpdateWidget(model.lastUpdate));

  Widget _buildLastUpdateWidget(DateTime? lastUpdate) => lastUpdate == null
      ? Container()
      : Container(
          padding: const EdgeInsets.all(8.0),
          child: Text('Last Fetch: ${_dateFormatted(lastUpdate)}',
              textAlign: TextAlign.center, textScaleFactor: 0.8));

  String _dateFormatted(DateTime dateTime) =>
      DateFormat('yyyy-MM-dd HH:mm:ss').format(dateTime);
}
