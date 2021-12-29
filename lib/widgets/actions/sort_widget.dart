import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';

class SortWidget extends StatelessWidget {
  final ForegroundController foregroundController =
      GetIt.instance<ForegroundController>();
  final String _tooltip = 'Sort stocks by';

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => _sortWidget(context, model));

  _sortWidget(BuildContext context, AppModel model) =>
      _validScreen(model.currentScreen)
          ? _sortButtonWidget(context)
          : Container();

  bool _validScreen(int currentScreen) =>
      StockConstants.summaryScreen == currentScreen ||
      StockConstants.stocksScreen == currentScreen;

  IconButton _sortButtonWidget(BuildContext context) {
    final List<String> _sortOptions = [
      'Raw Data',
      StockConstants.daysOld,
      StockConstants.capitalValue,
      StockConstants.profit,
      StockConstants.netGain,
      StockConstants.profitDay,
    ];
    return IconButton(
        icon: const Icon(Icons.sort_rounded),
        tooltip: _tooltip,
        onPressed: () => _onPressed(context, _sortOptions));
  }

  void _onPressed(BuildContext context, List<String> sortOptions) async {
    final List<PopupMenuEntry<String>> popupMenuEntries =
        sortOptions.map((e) => _popupMenuEntry(e)).toList();
    String? selectedSort = await showMenu(
        context: context,
        items: popupMenuEntries,
        position: RelativeRect.fromLTRB(
            context.size!.width, 0, 0, context.size!.height),
        semanticLabel: _tooltip);
    if (selectedSort != null) {
      foregroundController.sortBy(selectedSort);
    }
  }

  PopupMenuItem<String> _popupMenuEntry(String id) =>
      PopupMenuItem<String>(value: id, child: Text(id));
}
