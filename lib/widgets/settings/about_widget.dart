import 'package:flutter/material.dart';

class AboutWidget extends StatefulWidget {
  const AboutWidget({Key? key}) : super(key: key);

  @override
  _AboutWidgetState createState() => _AboutWidgetState();
}

class _AboutWidgetState extends State<AboutWidget> {
  bool _onTap = false;

  @override
  Widget build(BuildContext context) => ListTile(
      onTap: _handleOnTap,
      title: const Text('About StockMeter'),
      subtitle:
          _onTap ? _displayDisclaimer() : const Text('Tap to read About'));

  void _handleOnTap() => setState(() {
        _onTap = !_onTap;
      });

  Widget _displayDisclaimer() => Column(children: [
        const Text(''),
        const Text(
            'This is a Flutter project for learning purposes. The developed application '
            'offers a monitoring tool about Stock Exchanges, Mutual Funds, Indexes and other '
            'financial data available in Google products. From this data, trading simulations '
            'and customizable notifications based on price values are featured.'),
        const Text(''),
        const Text(
            'The data is provided by Google Finance and may be delayed by up to 20 minutes. '
            'Read its disclaimer for more details. In addition to this delay, the notification feature '
            'may add an extra time depending on the periodical check configured. For these reasons, '
            'this application is for informational purposes, not for trading purposes or advice.'),
        const Text(''),
        const Text(
            'StockMeter uses Google Sheets to store and calculate the financial data. '
            'Because of this, it is required a Google Account and granted access to Google Drive. '
            'In any case, the application stores personal data or access other files beyond the '
            'strictly Google Sheets files required to work.'),
      ]);
}
