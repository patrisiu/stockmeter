import 'package:flutter/material.dart';
import 'package:stockmeter/widgets/actions/action_widget_list.dart';
import 'package:stockmeter/widgets/scoped_navigation_bar.dart';

class StockScaffold extends StatelessWidget {
  StockScaffold({
    Key? key,
    List<Widget>? persistentFooterButtons,
    required String title,
    required Widget body,
  })  : _title = title,
        _body = body,
        _persistentFooterButtons = persistentFooterButtons,
        super(key: key);

  final String _title;
  final Widget _body;
  List<Widget>? _persistentFooterButtons;

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: Text(_title), actions: ActionWidgetList.get()),
      body: _body,
      bottomNavigationBar: ScopedBottomNavigationBar(),
      persistentFooterButtons: _persistentFooterButtons);
}
