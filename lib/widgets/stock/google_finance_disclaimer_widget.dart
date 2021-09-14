import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class GoogleFinanceDisclaimerWidget extends StatelessWidget {
  const GoogleFinanceDisclaimerWidget({Key? key}) : super(key: key);

  final String _stockMeterSourceData =
      'The information displayed is provided by Google Finance.';

  final String _googleFinanceDisclaimer =
      'Quotes are not sourced from all markets '
      'and may be delayed by up to 20 minutes. Information is provided \'as is\' '
      'and solely for informational purposes, not for trading purposes or advice.';

  final String _googleFinanceDisclaimerDetails =
      'Press here to access the full Google Disclaimer.';

  final String _googleFinanceDisclaimerUrl =
      'https://www.google.com/googlefinance/disclaimer/#!#disclaimers';

  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
          onTap: () => _launchURL(_googleFinanceDisclaimerUrl),
          child: Column(children: [
            _textDisclaimer(_stockMeterSourceData),
            _textDisclaimer(_googleFinanceDisclaimer),
            _textDisclaimer(_googleFinanceDisclaimerDetails)
          ])));

  Text _textDisclaimer(String text) =>
      Text(text, textAlign: TextAlign.center, textScaleFactor: 0.8);

  void _launchURL(String url) async => await launcher.canLaunch(url)
      ? await launcher.launch(url)
      : throw 'Could not launch $url';
}
