import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';

class StockElevatedButton extends StatelessWidget {
  const StockElevatedButton({Key? key, required this.child, this.onPressed})
      : super(key: key);

  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => ElevatedButton(
      child: child,
      onPressed: onPressed,
      style: ButtonStyle(
          backgroundColor:
          MaterialStateProperty.all<Color>(StockConstants.activeColor)));
}