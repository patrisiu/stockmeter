import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/widgets/functionalities/functionality_widget_list.dart';

class AppInfoWidget extends StatelessWidget {
  const AppInfoWidget({Key? key}) : super(key: key);
  final String _tooltip = 'Info';

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _appInfoWidget(context, model));

  _appInfoWidget(BuildContext context, AppModel model) =>
      StockConstants.settingsScreen == model.currentScreen
          ? _appInfoButton(context)
          : Container();

  _appInfoButton(BuildContext context) => IconButton(
      icon: const Icon(Icons.info_outline_rounded),
      tooltip: _tooltip,
      onPressed: () => _functionalities(context));

  _functionalities(BuildContext context) async => await showModalBottomSheet(
      context: context,
      builder: (BuildContext context) =>
          ListView(children: FunctionalityWidgetList.get()));
}
