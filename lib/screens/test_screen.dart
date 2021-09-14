import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/notifications/background_notification.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/notifications/foreground_notification.dart';
import 'package:stockmeter/widgets/test_widget.dart';

class TestScreen extends StatelessWidget {
  TestScreen({Key? key, this.text: "initial text"}) : super(key: key);

  final ForegroundController foregroundController =
      GetIt.instance<ForegroundController>();
  final String text;

  Widget myTest(AppModel model) {
    return ListView(children: <Widget>[
      // ElevatedButton(
      //   child: const Text('Test Evaluate Alerts'),
      //   onPressed: model.loadAndNotify,
      // ),
      ElevatedButton(
        child: const Text('New Load All'),
        onPressed: foregroundController.fetchStocks,
      ),
      ElevatedButton(
        child: const Text('Test SnackBar'),
        onPressed: () {
          ForegroundNotification().info(foregroundController.context, "Testing SnackBar");
        },
      ),
      ElevatedButton(
        child: const Text('Notification Task'),
        onPressed: () {
          BackgroundNotification().show(
              "Des del butonet", "a les ${DateTime.now().toString()}");
        },
      ),
      TestWidget(),
      // ElevatedButton(
      //   child: const Text('Run reloadTask'),
      //   onPressed: () {
      //     BackgroundController().publicRegisterNextLoad(
      //         "testButtonTask", "reloadTask");
      //   },
      // ),
      // ElevatedButton(
      //   child: const Text('Cancel All WorkManager Tasks'),
      //   onPressed: () {
      //     BackgroundController.cancelAll();
      //   },
      // ),
      // ElevatedButton(
      //   child: const Text('Enable/Disable AutoReload'),
      //   onPressed: () {
      //     appModel.setAutoReload(!model.autoReload);
      //   },
      // ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<AppModel>(
        builder: (context, child, model) => myTest(model));
  }
}
