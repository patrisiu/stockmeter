import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:stockmeter/app.dart';
import 'package:stockmeter/configurations/dependencies.dart';
import 'package:stockmeter/firebase_options.dart';

void main() async {
  Dependencies.configure();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(StockMeterApp());
}
