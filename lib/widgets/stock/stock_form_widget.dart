import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/daos/stock_dao.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/widgets/StockElevatedButton.dart';

class StockFormWidget extends StatefulWidget {
  final Stock stock;

  StockFormWidget(this.stock);

  @override
  _StockFormWidgetState createState() => _StockFormWidgetState(stock);
}

class _StockFormWidgetState extends State<StockFormWidget> {
  final ForegroundController foregroundController =
      GetIt.instance<ForegroundController>();
  final TextStyle _textStyle = TextStyle(color: StockConstants.activeColor);
  final _formKey = GlobalKey<FormState>();
  final Stock stock;

  _StockFormWidgetState(this.stock);

  late StockDAO _stockDAO = StockDAO(stock);
  late bool _onlyAlert = _stockDAO.stocks == '0';
  late bool _hasToNotify = _stockDAO.hasToNotify;
  late bool _onPressedButton = false;
  late bool _onDeleteButton = false;
  late DateTime _dateTimePicked = _convertDateFromStock(_stockDAO.purchaseDate);
  late TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _parseDateToString(_dateTimePicked);
  }

  @override
  Widget build(BuildContext context) => Center(
      child: Container(
          // width: MediaQuery.of(context).size.width - 10,
          // height: MediaQuery.of(context).size.height -  80,
          // padding: EdgeInsets.all(20),
          color: Colors.black45,
          child: _buildForm(context)));

  Widget _buildForm(BuildContext context) {
    List<Widget> _tradeElements = [
      TextFormField(
          initialValue: _stockDAO.stocks,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabled: !_onlyAlert,
              icon: Icon(Icons.bathtub_rounded),
              hintText: 'Stock quantity purchased',
              labelText: StockConstants.stocks),
          onSaved: (String? value) => _stockDAO.stocks = value,
          validator: (String? value) => _stocksValidator(value)),
      GestureDetector(
          onTap: () => !_onlyAlert ? _onTapSelectDate(context) : null,
          child: AbsorbPointer(
              child: TextFormField(
                  keyboardType: TextInputType.datetime,
                  controller: _dateController,
                  decoration: InputDecoration(
                      enabled: !_onlyAlert,
                      icon: Icon(Icons.calendar_today_rounded),
                      hintText: 'dd/mm/yyyy',
                      labelText: StockConstants.purchaseDate),
                  onSaved: (String? value) => _stockDAO.purchaseDate =
                      _parseDateToString(_dateTimePicked)))),
      TextFormField(
          initialValue: _stockDAO.purchasePrice,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabled: !_onlyAlert,
              icon: Icon(Icons.attach_money_rounded),
              labelText: StockConstants.purchasePrice),
          onSaved: (String? value) =>
              _stockDAO.purchasePrice = _setValueOrDefault(value),
          validator: (String? value) => _numberValidator(value)),
      TextFormField(
          initialValue: _stockDAO.fees,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabled: !_onlyAlert,
              icon: Icon(Icons.theater_comedy),
              hintText: 'Sum of account expenses involved',
              labelText: StockConstants.fees),
          onSaved: (String? value) =>
              _stockDAO.fees = _setValueOrDefault(value),
          validator: (String? value) => _numberValidator(value)),
      TextFormField(
          initialValue: _stockDAO.tax,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabled: !_onlyAlert,
              icon: Icon(Icons.local_police_rounded),
              hintText: 'Tax value as a Decimal Fraction',
              labelText: StockConstants.tax),
          onSaved: (String? value) => _stockDAO.tax = _setValueOrDefault(value),
          validator: (String? value) => _taxValidator(value!)),
    ];
    List<Widget> _alertElements = [
      TextFormField(
          initialValue: _stockDAO.alertAbove,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              icon: Icon(Icons.trending_up_rounded),
              hintText: 'Alert when Price is equal or above:',
              labelText: 'Alert Above'),
          onSaved: (String? value) =>
              _stockDAO.alertAbove = _setValueOrDefault(value),
          validator: (String? value) => _alertValidator(value!)),
      TextFormField(
          initialValue: _stockDAO.alertBelow,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              icon: Icon(Icons.trending_down_rounded),
              hintText: 'Alert when Price is equal or below:',
              labelText: 'Alert Below'),
          onSaved: (String? value) =>
              _stockDAO.alertBelow = _setValueOrDefault(value),
          validator: (String? value) => _alertValidator(value!)),
      ListTile(
          leading: Icon(Icons.notifications_rounded),
          title: const Text('Skip Trade Info'),
          subtitle: const Text('Only enter the Alert values'),
          trailing: Switch(
              value: _onlyAlert,
              onChanged: _onChangedAlertNotificationsOnly,
              activeColor: StockConstants.activeColor)),
      ListTile(
          leading: Icon(Icons.notifications_rounded),
          title: const Text('Has to Notify'),
          subtitle: const Text(
              'Receive a notification when the alert has been triggered'),
          trailing: Switch(
              value: _hasToNotify,
              onChanged: _onChangedHasToNotify,
              activeColor: StockConstants.activeColor)),
      TextFormField(
          initialValue: _stockDAO.notes,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              icon: Icon(Icons.note_alt_rounded),
              hintText: 'Free text space for self annotations',
              labelText: StockConstants.notes),
          onSaved: (String? value) => _stockDAO.notes = value ?? ''),
      StockElevatedButton(
          onPressed: !_onPressedButton ? _onPressedSave : null,
          child: const Text('Save')),
      StockElevatedButton(
          onPressed: _stockDAO.rowIndex != 0 && !_onPressedButton
              ? _onPressedDelete
              : null,
          child: const Text('Delete')),
      StockElevatedButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      )
    ];
    List<Widget> _formElements = [
      TextFormField(
          initialValue: _stockDAO.symbol,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
              icon: Icon(Icons.event_note_rounded),
              hintText: 'NASDAQ:GOOG',
              labelText: StockConstants.symbol),
          onSaved: (String? value) => _stockDAO.symbol = value!.toUpperCase(),
          validator: (String? value) => _symbolValidator(value)),
    ];
    if (!_onlyAlert) {
      _formElements.addAll(_tradeElements);
    }
    _formElements.addAll(_alertElements);
    return Form(
      key: _formKey,
      child: ListView(children: _formElements),
    );
  }

  String _setValueOrDefault(String? value) =>
      value == null || value.isEmpty ? '0' : value;

  String? _symbolValidator(String? value) =>
      value != null && value.contains(':')
          ? null
          : ' Valid examples may be NASDAQ:GOOG or CURRENCY:BTCUSD';

  String? _stocksValidator(String? value) {
    if (!_onlyAlert) {
      int? input = int.tryParse(value!);
      if (input == null || input < 1) {
        return 'Should be a natural number';
      }
    }
    return null;
  }

  String? _numberValidator(String? value) =>
      !_onlyAlert && _isNotNumber(value) ? StockConstants.notANumber : null;

  String? _alertValidator(String? value) =>
      _isNotNumber(value) ? StockConstants.notANumber : null;

  bool _isNotNumber(String? value) =>
      value == null || (value.isNotEmpty && double.tryParse(value) == null);

  String? _taxValidator(String value) {
    if (!_onlyAlert && value.isNotEmpty) {
      double? input = double.tryParse(value);
      if (input == null) {
        return StockConstants.notANumber;
      }
      if (input > 1 || input < 0) {
        return 'Should be expressed as Decimal Fraction.';
      }
    }
    return null;
  }

  Future<void> _onPressedSave() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _onPressedButton = true);
      _formKey.currentState!.save();
      await _saveStock();
      Navigator.pop(context);
      await foregroundController.fetchStocks();
      setState(() {});
    }
  }

  Future<void> _saveStock() async {
    if (_onlyAlert) {
      _stockDAO.applyOnlyAlert();
    }
    if (_stockDAO.rowIndex == 0) {
      await foregroundController.createStock(_stockDAO);
    } else {
      await foregroundController.updateStock(_stockDAO);
    }
  }

  Future<void> _onPressedDelete() async {
    await showDialog<bool>(
        context: context,
        builder: (BuildContext context) => AlertDialog(
                title: const Text('Delete action will not be reversible.'),
                content: const Text('Do you want to proceed?'),
                actions: <Widget>[
                  TextButton(
                      child: Text('No', style: _textStyle),
                      onPressed: () => Navigator.of(context).pop()),
                  TextButton(
                      child: Text('Yes', style: _textStyle),
                      onPressed: () {
                        setState(() {
                          _onPressedButton = true;
                          _onDeleteButton = true;
                        });
                        Navigator.of(context).pop();
                      })
                ]));
    if (_onDeleteButton) {
      await foregroundController.deleteStock(_stockDAO.rowIndex);
      await foregroundController.fetchStocks();
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  void _onChangedAlertNotificationsOnly(bool value) => setState(() {
        _onlyAlert = value;
      });

  void _onChangedHasToNotify(bool value) {
    _stockDAO.hasToNotify = value;
    setState(() {
      _hasToNotify = value;
    });
  }

  void _onTapSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTimePicked,
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dateTimePicked)
      setState(() {
        _dateTimePicked = picked;
        _dateController.text = _parseDateToString(picked);
      });
  }

  DateTime _convertDateFromStock(String? date) => date == null || date == ''
      ? DateTime.now()
      : _parseStringToDateTime(date);

  String _parseDateToString(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  DateTime _parseStringToDateTime(String date) {
    List<String> splitDate = date.split('/');
    int? year = int.tryParse(splitDate[2]);
    int? month = int.tryParse(splitDate[1]);
    int? day = int.tryParse(splitDate[0]);
    return DateTime(year!, month!, day!);
  }
}
