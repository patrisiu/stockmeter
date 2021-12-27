import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:stockmeter/controllers/foreground_controller.dart';
import 'package:stockmeter/models/app_model.dart';
import 'package:stockmeter/widgets/StockElevatedButton.dart';

class SignInOutWidget extends StatelessWidget {
  final ForegroundController foregroundController =
      GetIt.instance<ForegroundController>();

  @override
  Widget build(BuildContext context) => ScopedModelDescendant<AppModel>(
      builder: (context, child, model) => model.isUserSigned
          ? _buildSignOutWidget(model.email!)
          : _buildSignInWidget());

  Widget _buildSignInWidget() => ListTile(
      title: const Text("Sign In"),
      subtitle: const Text('Required a Google Account'),
      trailing: StockElevatedButton(
          child: const Text('SIGN IN'),
          onPressed: foregroundController.signIn));

  Widget _buildSignOutWidget(String email) => ListTile(
      title: const Text("Sign Out"),
      subtitle: Text('Signed as $email'),
      trailing: StockElevatedButton(
          child: const Text('SIGN OUT'),
          onPressed: foregroundController.signOut));
}
