import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';

class DebugWidget extends StatefulWidget {
  @override
  _DebugWidgetState createState() => _DebugWidgetState();
}

class _DebugWidgetState extends State<DebugWidget> {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  List<Widget> _columnChildren = [];

  @override
  void initState() {
    super.initState();
    List<String> debug = _foregroundController.debugLastBackgroundExecution();
    _columnChildren = debug.map((e) => Text(e)).toList();
  }

  @override
  Widget build(BuildContext context) => ListTile(
        title: const Text('Test Background Execution'),
        subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: _columnChildren),
        trailing: IconButton(
          icon: Icon(Icons.bug_report_outlined),
          onPressed: () => _handleOnTap(context),
        ),
        onLongPress: _foregroundController.debugBackgroundExecution,
      );

  void _handleOnTap(BuildContext context) {
    List<String> debug = _foregroundController.debugLastBackgroundExecution();
    setState(() {
      _columnChildren = debug.map((e) => Text(e)).toList();
    });
  }
}
