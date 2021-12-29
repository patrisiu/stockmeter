import 'package:flutter/material.dart';
import 'package:stockmeter/widgets/actions/sort_widget.dart';
import 'package:stockmeter/widgets/actions/stock_add_button_widget.dart';

class ActionsWidgetList {
  static List<Widget> get() => <Widget>[StockAddButtonWidget(), SortWidget()];
}
