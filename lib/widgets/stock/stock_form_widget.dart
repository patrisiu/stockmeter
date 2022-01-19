import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:stockmeter/configurations/constants.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/daos/stock_dao.dart';
import 'package:stockmeter/models/stock.dart';
import 'package:stockmeter/widgets/stock_elevated_button.dart';

class StockFormWidget extends StatefulWidget {
  const StockFormWidget({Key? key, required this.stock}) : super(key: key);

  final Stock stock;

  @override
  _StockFormWidgetState createState() => _StockFormWidgetState();
}

class _StockFormWidgetState extends State<StockFormWidget> {
  final ForegroundController foregroundController =
      GetIt.instance<ForegroundController>();
  final TextStyle _textStyle = TextStyle(color: StockConstants.activeColor);
  final _formKey = GlobalKey<FormState>();

  late StockDAO _stockDAO = StockDAO.fromStock(widget.stock);
  late bool _tradeInfo = _stockDAO.stocks != '0';
  late bool _hasToNotify = _stockDAO.hasToNotify;
  late bool _pressedSaveButton = false;
  late bool _pressedDeleteButton = false;
  late DateTime _dateTimePicked = _convertDateFromStock(_stockDAO.purchaseDate);
  late TextEditingController _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = _parseDateToString(_dateTimePicked);
  }

  @override
  Widget build(BuildContext context) => Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.all(4),
      child: _buildForm(context));

  Widget _buildForm(BuildContext context) {
    List<Widget> _tradeElements = [
      TextFormField(
          key: UniqueKey(),
          initialValue: _stockDAO.stocks,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabled: _tradeInfo,
              icon: Icon(Icons.bathtub_rounded),
              hintText: 'Stocks quantity purchased',
              labelText: StockConstants.stocks),
          validator: (String? value) => _stocksValidator(value)),
      GestureDetector(
          onTap: () => _tradeInfo ? null : _handleOnTapSelectDate(context),
          child: AbsorbPointer(
              child: TextFormField(
                  key: UniqueKey(),
                  keyboardType: TextInputType.datetime,
                  controller: _dateController,
                  decoration: InputDecoration(
                      enabled: _tradeInfo,
                      icon: Icon(Icons.calendar_today_rounded),
                      hintText: 'dd/mm/yyyy',
                      labelText: StockConstants.purchaseDate),
                  validator: (String? value) =>
                      _dateValidator(_dateTimePicked)))),
      TextFormField(
          key: UniqueKey(),
          initialValue: _stockDAO.purchasePrice,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabled: _tradeInfo,
              icon: Icon(Icons.attach_money_rounded),
              labelText: StockConstants.purchasePrice),
          validator: (String? value) => _purchasePriceValidator(value)),
      TextFormField(
          key: UniqueKey(),
          initialValue: _stockDAO.fees,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabled: _tradeInfo,
              icon: Icon(Icons.theater_comedy),
              hintText: 'Sum of account expenses involved',
              labelText: StockConstants.fees),
          validator: (String? value) => _feesValidator(value)),
      TextFormField(
          key: UniqueKey(),
          initialValue: _stockDAO.tax,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
              enabled: _tradeInfo,
              icon: Icon(Icons.local_police_rounded),
              hintText: 'Tax value as a Decimal Fraction',
              labelText: StockConstants.tax),
          validator: (String? value) => _taxValidator(value!)),
    ];
    List<Widget> _alertElements = [
      TextFormField(
          key: UniqueKey(),
          initialValue: _stockDAO.alertAbove,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              icon: Icon(Icons.trending_up_rounded),
              hintText: 'Alert when Price is equal or above:',
              labelText: 'Alert Above'),
          validator: (String? value) => _alertAboveValidator(value!)),
      TextFormField(
          key: UniqueKey(),
          initialValue: _stockDAO.alertBelow,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
              icon: Icon(Icons.trending_down_rounded),
              hintText: 'Alert when Price is equal or below:',
              labelText: 'Alert Below'),
          validator: (String? value) => _alertBelowValidator(value!)),
      Padding(
          padding: EdgeInsets.fromLTRB(0, 8, 0, 8),
          child: TextFormField(
              key: UniqueKey(),
              cursorColor: StockConstants.activeColor,
              initialValue: _stockDAO.notes,
              keyboardType: TextInputType.text,
              maxLines: 3,
              decoration: InputDecoration(
                  hintText: 'Free text space for self annotations',
                  labelText: StockConstants.notes,
                  border: const OutlineInputBorder()),
              validator: (String? value) {
                _stockDAO.notes = value ?? '';
                return null;
              })),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        StockElevatedButton(
            onPressed: !_pressedSaveButton ? _onPressedSave : null,
            child: const Text('Save')),
        StockElevatedButton(
            onPressed: _stockDAO.rowIndex != 0 && !_pressedSaveButton
                ? _onPressedDelete
                : null,
            child: const Text('Delete')),
        StockElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'))
      ])
    ];
    List<Widget> _formElements = [
      Center(
          child: ToggleButtons(
        borderRadius: BorderRadius.all(Radius.circular(16)),
        splashColor: Colors.white70,
        children: [
          Icon(Icons.add_business_rounded),
          Icon(Icons.notifications_active_rounded)
        ],
        isSelected: [_tradeInfo, _hasToNotify],
        fillColor: StockConstants.activeColor,
        selectedColor: Colors.white,
        onPressed: _handleOnPressedToggleButtons,
      )),
      TextFormField(
          key: UniqueKey(),
          initialValue: _stockDAO.symbol,
          keyboardType: TextInputType.name,
          decoration: InputDecoration(
            focusColor: StockConstants.activeColor,
            icon: Icon(Icons.event_note_rounded),
            hintText: 'NASDAQ:GOOG',
            labelText: StockConstants.symbol,
          ),
          validator: (String? value) => _symbolValidator(value)),
    ];
    if (_tradeInfo) {
      _formElements.addAll(_tradeElements);
    }
    _formElements.addAll(_alertElements);
    return Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(shrinkWrap: true, children: _formElements));
  }

  String? _symbolValidator(String? value) {
    if (!StockDAO.isValidSymbol(value)) {
      return 'Try NASDAQ:GOOG or CURRENCY:BTCUSD';
    } else {
      _stockDAO.symbol = value!.toUpperCase();
      return null;
    }
  }

  String? _stocksValidator(String? value) {
    if (_tradeInfo && !StockDAO.isValidStocks(value)) {
      return 'Should be a natural number';
    } else {
      _stockDAO.stocks = value!;
      return null;
    }
  }

  String? _dateValidator(DateTime? value) {
    if (value != null) {
      _stockDAO.purchaseDate = _parseDateToString(value);
    }
    return null;
  }

  String? _purchasePriceValidator(String? value) {
    if (!_isBlank(value)) {
      String? result = _numberValidator(value);
      if (result == null) {
        _stockDAO.purchasePrice = value;
      }
      return result;
    }
    return null;
  }

  String? _feesValidator(String? value) {
    if (!_isBlank(value)) {
      String? result = _numberValidator(value);
      if (result == null) {
        _stockDAO.fees = value;
      }
      return result;
    }
    return null;
  }

  String? _taxValidator(String? value) {
    if (!_isBlank(value)) {
      double? input = double.tryParse(value!);
      if (input == null) {
        return StockConstants.notANumber;
      } else if (input > 1 || input < 0) {
        return 'Should be expressed as Decimal Fraction.';
      } else {
        _stockDAO.tax = value;
      }
    }
    return null;
  }

  String? _alertAboveValidator(String? value) {
    String? validationError = _alertValidator(value);
    if (validationError == null) {
      _stockDAO.alertAbove = value;
      return null;
    } else {
      return validationError;
    }
  }

  String? _alertBelowValidator(String? value) {
    String? validationError = _alertValidator(value);
    if (validationError == null) {
      _stockDAO.alertBelow = value;
      return null;
    } else {
      return validationError;
    }
  }

  String? _numberValidator(String? value) =>
      _tradeInfo && _isNotNumber(value) ? StockConstants.notANumber : null;

  String? _alertValidator(String? value) =>
      _isBlank(value) || StockDAO.isValidAlert(value)
          ? null
          : StockConstants.notANumber;

  bool _isNotNumber(String? value) =>
      _isBlank(value) || double.tryParse(value!) == null;

  Future<void> _onPressedSave() async {
    setState(() => _pressedSaveButton = true);
    if (_formKey.currentState!.validate()) {
      StockDAO stockDAOToSave = StockDAO.clone(_stockDAO);
      _setNeutralValueOnBlankValidAttributes(stockDAOToSave);
      _setStocksNeutralValueWhenStockAlert(stockDAOToSave);
      await _saveStock(stockDAOToSave)
          .whenComplete(() => foregroundController.fetchStocks());
      Navigator.pop(context);
      setState(() {});
    } else {
      setState(() => _pressedSaveButton = false);
    }
  }

  Future<void> _saveStock(StockDAO stockDAO) async {
    if (stockDAO.rowIndex == 0) {
      await foregroundController.createStock(stockDAO);
    } else {
      await foregroundController.updateStock(stockDAO);
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
                          _pressedSaveButton = true;
                          _pressedDeleteButton = true;
                        });
                        Navigator.of(context).pop();
                      })
                ]));
    if (_pressedDeleteButton) {
      await foregroundController.deleteStock(_stockDAO.rowIndex);
      await foregroundController.fetchStocks();
      Navigator.of(context).pop();
      setState(() {});
    }
  }

  void _handleOnPressedToggleButtons(int index) {
    if (index == 0) {
      _handleOnToggleTradeInfo();
    } else if (index == 1) {
      _handleOnToggleHasToNotify();
    }
  }

  void _handleOnToggleTradeInfo() => setState(() => _tradeInfo = !_tradeInfo);

  void _handleOnToggleHasToNotify() {
    _stockDAO.hasToNotify = !_stockDAO.hasToNotify;
    setState(() => _hasToNotify = _stockDAO.hasToNotify);
  }

  void _handleOnTapSelectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dateTimePicked,
      firstDate: DateTime(1950),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _dateTimePicked)
      setState(() {
        _dateTimePicked = picked;
        _dateController.text = _parseDateToString(picked);
      });
  }

  DateTime _convertDateFromStock(String? date) =>
      _isBlank(date) ? DateTime.now() : _parseStringToDateTime(date!);

  String _parseDateToString(DateTime date) =>
      '${date.day}/${date.month}/${date.year}';

  DateTime _parseStringToDateTime(String date) {
    List<String> splitDate = date.split('/');
    int? year = int.tryParse(splitDate[2]);
    int? month = int.tryParse(splitDate[1]);
    int? day = int.tryParse(splitDate[0]);
    return DateTime(year!, month!, day!);
  }

  void _setStocksNeutralValueWhenStockAlert(StockDAO stockDAO) {
    if (!_tradeInfo) {
      stockDAO.stocks = StockDAO.neutralValue;
    }
  }

  void _setNeutralValueOnBlankValidAttributes(StockDAO stockDAO) {
    if (_isBlank(stockDAO.purchaseDate)) {
      stockDAO.purchaseDate = _parseDateToString(DateTime.now());
    }
    if (_isBlank(stockDAO.purchasePrice)) {
      stockDAO.purchasePrice = StockDAO.neutralValue;
    }
    if (_isBlank(stockDAO.fees)) {
      stockDAO.fees = StockDAO.neutralValue;
    }
    if (_isBlank(stockDAO.tax)) {
      stockDAO.tax = StockDAO.neutralValue;
    }
    if (_isBlank(stockDAO.alertAbove)) {
      stockDAO.alertAbove = StockDAO.neutralValue;
    }
    if (_isBlank(stockDAO.alertBelow)) {
      stockDAO.alertBelow = StockDAO.neutralValue;
    }
  }

  bool _isBlank(String? value) => value == null || value.isEmpty;
}
