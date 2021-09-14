import 'package:firebase_auth/firebase_auth.dart';
import 'package:scoped_model/scoped_model.dart';

mixin AuthModel on Model {
  Map<String, String>? _authHeaders;

  User? user;

  bool get isUserSigned => user != null;

  String? get photoUrl => user?.photoURL;

  String? get email => user?.email;

  Map<String, String>? get authHeaders => _authHeaders;

  set authHeaders(Map<String, String>? value) {
    _authHeaders = value;
    notifyListeners();
  }
}
