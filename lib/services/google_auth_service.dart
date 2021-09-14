import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:stockmeter/configurations/constants.dart';

class GoogleAuthService {
  static FirebaseAuth _auth = FirebaseAuth.instance;
  static GoogleSignIn _googleSignIn =
      GoogleSignIn(scopes: StockConstants.scopes);
  static GoogleSignInAccount? _googleSignInAccount;

  Future<User?> signInSilently() async {
    await Firebase.initializeApp();
    final User? firebaseUser = FirebaseAuth.instance.currentUser;
    await firebaseUser?.reload();
    _googleSignInAccount = await _googleSignIn.signInSilently();
    return _auth.currentUser;
  }

  Future<User?> signIn() async {
    _auth = FirebaseAuth.instance;
    _googleSignInAccount = (await _googleSignIn.signIn())!;

    final GoogleSignInAuthentication googleSignInAuthentication =
        await _googleSignInAccount!.authentication;

    final AuthCredential credential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication.idToken,
      accessToken: googleSignInAuthentication.accessToken,
    );
    return (await _auth.signInWithCredential(credential)).user;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await _googleSignIn.disconnect();
    await _googleSignIn.signOut();
  }

  Future<Map<String, String>> get authHeaders async =>
      await _googleSignInAccount!.authHeaders;

  Future<Map<String, String>?> refreshAuthHeaders() async {
    User? user = await signInSilently();
    if (user != null) {
      return await authHeaders;
    } else {
      throw Exception('User Error');
    }
  }
}
