import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';

class ConfirmAlertDialogWidget {
  final TextStyle _textStyle = TextStyle(color: StockConstants.activeColor);

  Future<bool> show(BuildContext context, String message) async {
    bool? result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: Text(message),
                content: const Text('Do you want to proceed?'),
                actions: <Widget>[
                  TextButton(
                      child: Text('No', style: _textStyle),
                      onPressed: () => Navigator.of(context).pop()),
                  TextButton(
                      child: Text('Yes', style: _textStyle),
                      onPressed: () => Navigator.of(context).pop(true))
                ]));
    return result != null && result;
  }
}
