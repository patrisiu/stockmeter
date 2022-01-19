// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    // ignore: missing_enum_constant_in_switch
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
    }

    throw UnsupportedError(
      'DefaultFirebaseOptions are not supported for this platform.',
    );
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyDhZ3EOCCWfdLXNwJOxyTc3TrOzjoVJDyM',
    appId: '1:1010107161043:web:276f24b251f8fd9e6eb726',
    messagingSenderId: '1010107161043',
    projectId: 'stockmeter-1bee0',
    authDomain: 'stockmeter-1bee0.firebaseapp.com',
    storageBucket: 'stockmeter-1bee0.appspot.com',
    measurementId: 'G-JSKGTEKVFF',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDTC3ECXA292jpib0XU51RXrK-rSz_uhx0',
    appId: '1:1010107161043:android:7d21a09d0595dce86eb726',
    messagingSenderId: '1010107161043',
    projectId: 'stockmeter-1bee0',
    storageBucket: 'stockmeter-1bee0.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBQ83Xb4pCillUrUN7ukhIrT9VR2OXMTko',
    appId: '1:1010107161043:ios:6efcf993a9901b026eb726',
    messagingSenderId: '1010107161043',
    projectId: 'stockmeter-1bee0',
    storageBucket: 'stockmeter-1bee0.appspot.com',
    androidClientId: '1010107161043-l3jhj5lh93tqcf7nr6lkj5e6ra006ltr.apps.googleusercontent.com',
    iosClientId: '1010107161043-luqrlhtpfo53f74lh2n59ebg1ae2r8u8.apps.googleusercontent.com',
    iosBundleId: 'com.patrisiu.stockmeter',
  );
}
