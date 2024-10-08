// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
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
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBwICvUD6Z0d01S1MBM8931gAu3nW6bocQ',
    appId: '1:575219354839:web:29735f51ba6aabea273492',
    messagingSenderId: '575219354839',
    projectId: 'fir-flutter-625f5',
    authDomain: 'fir-flutter-625f5.firebaseapp.com',
    storageBucket: 'fir-flutter-625f5.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCjdPmc51lUc-wDGyvbLQGXtkeLKQG-p0o',
    appId: '1:575219354839:android:de89254462acb63c273492',
    messagingSenderId: '575219354839',
    projectId: 'fir-flutter-625f5',
    storageBucket: 'fir-flutter-625f5.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrT3Qfaza-MFgYUM20-1llCR6l08t-3BM',
    appId: '1:575219354839:ios:7dc94dea1ce9376e273492',
    messagingSenderId: '575219354839',
    projectId: 'fir-flutter-625f5',
    storageBucket: 'fir-flutter-625f5.appspot.com',
    iosClientId: '575219354839-1hhq22fiulp0bsbevaq0qji5n6jmpivb.apps.googleusercontent.com',
    iosBundleId: 'com.example.firebase',
  );

}