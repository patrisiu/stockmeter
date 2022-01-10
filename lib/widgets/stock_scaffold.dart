import 'package:flutter/material.dart';
import 'package:stockmeter/widgets/actions/action_widget_list.dart';
import 'package:stockmeter/widgets/scoped_navigation_bar.dart';

class StockScaffold extends StatelessWidget {
  StockScaffold({
    Key? key,
    required String title,
    required Widget body,
    bool? connectivity,
    List<Widget>? persistentFooterButtons,
  })  : _title = title,
        _body = body,
        _connectivity = connectivity ?? true,
        _persistentFooterButtons = persistentFooterButtons ?? [],
        super(key: key);

  final String _title;
  final Widget _body;
  final bool _connectivity;
  final List<Widget> _persistentFooterButtons;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(_title), actions: _actionsIfConnectivity()),
      body: _body,
      bottomNavigationBar: ScopedBottomNavigationBar(),
      persistentFooterButtons: _persistentFooterButtons);

  List<Widget>? _actionsIfConnectivity() =>
      _connectivity ? ActionWidgetList.get() : null;
}
