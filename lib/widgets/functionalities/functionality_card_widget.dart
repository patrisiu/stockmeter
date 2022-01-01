import 'package:flutter/material.dart';

class FunctionalityCardWidget extends StatelessWidget {
  const FunctionalityCardWidget({
    Key? key,
    required this.navigationBarIcon,
    required this.navigationBarLabel,
    required this.title,
    this.subtitle,
    this.trailingIcon,
  }) : super(key: key);

  static const double _size = 60;

  final IconData navigationBarIcon;
  final String navigationBarLabel;
  final String title;
  final String? subtitle;
  final Icon? trailingIcon;

  @override
  Widget build(BuildContext context) => Card(
      child: ListTile(
          dense: true,
          leading: Container(
              constraints: BoxConstraints(
                  minHeight: _size,
                  minWidth: _size,
                  maxHeight: _size,
                  maxWidth: _size),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(navigationBarIcon),
                    Text(navigationBarLabel),
                  ])),
          title: Text(title),
          subtitle: subtitle != null ? Text(subtitle!) : null,
          trailing: trailingIcon));
}
