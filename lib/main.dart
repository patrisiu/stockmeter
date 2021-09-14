import 'package:flutter/material.dart';
import 'package:stockmeter/app.dart';
import 'package:stockmeter/configurations/dependencies.dart';

void main() async {
  Dependencies.configure();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(StockMeterApp());
}
