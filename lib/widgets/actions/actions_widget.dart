import 'package:flutter/material.dart';
import 'package:stockmeter/widgets/actions/sort_widget.dart';
import 'package:stockmeter/widgets/actions/stock_add_button_widget.dart';

class ActionsWidget {
  List<Widget> build() => <Widget>[
        StockAddButtonWidget(),
        SortWidget(),
      ];
}
