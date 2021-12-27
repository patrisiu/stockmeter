import 'package:flutter/material.dart';
import 'package:stockmeter/configurations/constants.dart';

class ForegroundNotification {
  static const int _tip_seconds_duration = 2;
  static const int _info_seconds_duration = 3;
  static const int _info_with_action_seconds_duration = 3;
  static const int _error_seconds_duration = 3;

  void error(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(_errorSnackBar(
          message, Duration(seconds: _error_seconds_duration), null));

  void info(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(_infoSnackBar(
          message, Duration(seconds: _info_seconds_duration), null));

  void tip(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(_infoSnackBar(
          message, Duration(seconds: _tip_seconds_duration), null));

  void infoWithAction(BuildContext context, String message,
          SnackBarAction snackBarAction) =>
      ScaffoldMessenger.of(context).showSnackBar(_infoSnackBar(
          message,
          Duration(seconds: _info_with_action_seconds_duration),
          snackBarAction));

  void infoWithIcon(BuildContext context, IconData iconData, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(_infoListTileSnackBar(
          message,
          Icon(iconData, size: 40, color: Colors.white),
          Duration(seconds: _info_seconds_duration),
          null));

  SnackBar _errorSnackBar(
          String message, Duration duration, SnackBarAction? snackBarAction) =>
      _genericSnackBar(
          Text(message, style: TextStyle(color: Colors.white70)),
          duration,
          Colors.grey[800]!,
          StockConstants.activeColor,
          snackBarAction);

  SnackBar _infoSnackBar(
          String message, Duration duration, SnackBarAction? snackBarAction) =>
      _genericSnackBar(
          Text(message, style: TextStyle(color: Colors.white)),
          duration,
          StockConstants.activeColor,
          StockConstants.activeColor,
          snackBarAction);

  SnackBar _infoListTileSnackBar(String message, Widget leading,
          Duration duration, SnackBarAction? snackBarAction) =>
      _genericSnackBar(
          ListTile(
              leading: leading,
              title: Text(message, style: TextStyle(color: Colors.white))),
          duration,
          StockConstants.activeColor,
          StockConstants.activeColor,
          snackBarAction);

  SnackBar _genericSnackBar(
          Widget content,
          Duration duration,
          Color backgroundColor,
          Color borderSideColor,
          SnackBarAction? snackBarAction) =>
      SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
              side: BorderSide(color: borderSideColor),
              borderRadius: BorderRadiusDirectional.circular(4)),
          content: content,
          duration: duration,
          action: snackBarAction);
}
