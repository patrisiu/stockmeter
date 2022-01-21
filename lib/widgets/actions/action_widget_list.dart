import 'package:flutter/material.dart';
import 'package:stockmeter/widgets/actions/app_info_widget.dart';
import 'package:stockmeter/widgets/actions/sort_widget.dart';
import 'package:stockmeter/widgets/actions/add_stock_widget.dart';

class ActionWidgetList {
  static List<Widget> get() => <Widget>[
        AddStockWidget(),
        SortWidget(),
        AppInfoWidget(),
      ];
}
