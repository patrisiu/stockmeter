import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';

class ReloadAction extends StatelessWidget {
  final ForegroundController foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Icon(Icons.cloud_download_rounded),
        onTap: foregroundController.fetchStocks);
  }
}
