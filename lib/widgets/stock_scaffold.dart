import 'package:flutter/material.dart';
import 'package:stockmeter/widgets/actions/actions_widget.dart';
import 'package:stockmeter/widgets/navigation_bar.dart';

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
      appBar: AppBar(title: Text(_title), actions: ActionsWidget().build()),
      body: _body,
      bottomNavigationBar: ScopedBottomNavigationBar(),
      persistentFooterButtons: _persistentFooterButtons);
}
