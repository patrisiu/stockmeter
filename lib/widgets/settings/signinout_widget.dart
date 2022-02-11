import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/widgets/stock_elevated_button.dart';

class SignInOutWidget extends StatelessWidget {
  final ForegroundController _foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => model.isUserSigned
          ? _buildSignOutWidget(model.email!)
          : _buildSignInWidget());

  Widget _buildSignInWidget() => ListTile(
      title: const Text("Sign In"),
      subtitle: const Text('Google Account required'),
      trailing: StockElevatedButton(
          child: const Text('SIGN IN'),
          onPressed: _foregroundController.signIn));

  Widget _buildSignOutWidget(String email) => ListTile(
      title: const Text("Sign Out"),
      subtitle: Text('Signed as $email'),
      trailing: StockElevatedButton(
          child: const Text('SIGN OUT'),
          onPressed: _foregroundController.signOut));
}
