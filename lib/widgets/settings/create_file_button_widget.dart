import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/widgets/stock_elevated_button.dart';

class CreateFileButtonWidget extends StatelessWidget {
  CreateFileButtonWidget({Key? key}) : super(key: key);

  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  Widget build(BuildContext context) => StockElevatedButton(
      child: const Text('Create File'),
      onPressed: _foregroundController.createStockFile);
}
