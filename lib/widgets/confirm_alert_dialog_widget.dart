import 'package:flutter/material.dart';

class ConfirmAlertDialogWidget {
  Future<bool> show(BuildContext context, String message) async {
    bool? result = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
            title: Text(message),
            content: const Text('Do you want to proceed?'),
            actions: <Widget>[
              TextButton(
                  child: Text('No'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              TextButton(
                  child: Text('Yes'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  })
            ]));
    return result != null && result;
  }
}
