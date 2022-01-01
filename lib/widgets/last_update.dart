import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/models/app_model.dart';

class LastUpdate extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _buildLastUpdateWidget(model));

  Widget _buildLastUpdateWidget(AppModel model) => Container(
      padding: const EdgeInsets.all(8.0),
      child: Text('Last Fetch: ${model.lastUpdate}',
          textAlign: TextAlign.center, textScaleFactor: 0.8));
}
