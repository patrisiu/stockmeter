import 'package:flutter/material.dart';

class ForegroundNotification {
  static const int _tip_seconds_duration = 1;
  static const int _info_seconds_duration = 3;
  static const int _info_with_action_seconds_duration = 4;
  static const int _error_seconds_duration = 4;

  void error(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(_genericSnackBar(message,
          Duration(seconds: _error_seconds_duration), Colors.redAccent, null));

  void info(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(_genericSnackBar(message,
          Duration(seconds: _info_seconds_duration), Colors.white70, null));

  void tip(BuildContext context, String message) =>
      ScaffoldMessenger.of(context).showSnackBar(_genericSnackBar(message,
          Duration(seconds: _tip_seconds_duration), Colors.white70, null));

  void infoWithAction(BuildContext context, String message,
      SnackBarAction snackBarAction) =>
      ScaffoldMessenger.of(context).showSnackBar(_genericSnackBar(
          message,
          Duration(seconds: _info_with_action_seconds_duration),
          Colors.white70,
          snackBarAction));

  SnackBar _genericSnackBar(String message, Duration duration, Color color,
      SnackBarAction? snackBarAction) =>
      SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: EdgeInsets.all(10),
          backgroundColor: Colors.grey[800],
          shape: RoundedRectangleBorder(
              side: BorderSide(color: color),
              borderRadius: BorderRadiusDirectional.circular(4)),
          content: Text(
            message,
            style: TextStyle(color: Colors.white70),
          ),
          duration: duration,
          action: snackBarAction);
}
