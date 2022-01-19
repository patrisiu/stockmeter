import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/widgets/stock_elevated_button.dart';

class StockFileNameWidget extends StatefulWidget {
  const StockFileNameWidget({Key? key, required this.stockFileName})
      : super(key: key);

  final String stockFileName;

  @override
  State<StockFileNameWidget> createState() => _StockFileNameWidgetState();
}

class _StockFileNameWidgetState extends State<StockFileNameWidget> {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  final _formKey = GlobalKey<FormState>();
  late bool _onPressedButton;
  String? _stockFileName;

  @override
  void initState() {
    super.initState();
    _onPressedButton = false;
  }

  @override
  Widget build(BuildContext context) => ListTile(
      title: Form(
        key: _formKey,
        child: TextFormField(
            cursorColor: StockConstants.activeColor,
            keyboardType: TextInputType.text,
            initialValue: widget.stockFileName,
            decoration: InputDecoration(
                labelText: 'Stock File Name',
                labelStyle: TextStyle(color: StockConstants.activeColor)),
            onSaved: (String? value) => _stockFileName = value ?? '',
            validator: (String? value) => _stockFileNameValidator(value)),
      ),
      subtitle: Padding(
          padding: EdgeInsets.fromLTRB(0, 4, 0, 0),
          child: const Text('Set a name to identify it easier.')),
      trailing: _onPressedButton
          ? null
          : StockElevatedButton(
              child: Icon(Icons.drive_file_rename_outline_rounded),
              onPressed: () async => await _onPressed()));

  String? _stockFileNameValidator(String? stockFileName) => null;

  Future<void> _onPressed() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _onPressedButton = true;
      });
      _formKey.currentState!.save();
      Navigator.of(context).pop();
      await _foregroundController.setStockFileName(_stockFileName!);
    }
  }
}
