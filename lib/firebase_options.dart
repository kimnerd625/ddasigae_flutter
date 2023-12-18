// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        return macos;
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
    apiKey: 'AIzaSyCJN1sruwdy9Qz59_p12t0UDlgEFgZza-0',
    appId: '1:616572887836:web:d69c67274d03a3f504d0d9',
    messagingSenderId: '616572887836',
    projectId: 'ddasigae-d5462',
    authDomain: 'ddasigae-d5462.firebaseapp.com',
    databaseURL: 'https://ddasigae-d5462-default-rtdb.firebaseio.com',
    storageBucket: 'ddasigae-d5462.appspot.com',
    measurementId: 'G-L2J49HE59D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCxsECV9ZZoPsjo3y1dpvxh5RKa1FG25ag',
    appId: '1:616572887836:android:8bcc101d9fde139604d0d9',
    messagingSenderId: '616572887836',
    projectId: 'ddasigae-d5462',
    databaseURL: 'https://ddasigae-d5462-default-rtdb.firebaseio.com',
    storageBucket: 'ddasigae-d5462.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBcHktL2dROJJZQV41ywdDlv-7YDsvjOZs',
    appId: '1:616572887836:ios:ffe12eca2cdc34d704d0d9',
    messagingSenderId: '616572887836',
    projectId: 'ddasigae-d5462',
    databaseURL: 'https://ddasigae-d5462-default-rtdb.firebaseio.com',
    storageBucket: 'ddasigae-d5462.appspot.com',
    iosClientId: '616572887836-8j912ve98ub749eb63j8icft9vp4oqvq.apps.googleusercontent.com',
    iosBundleId: 'com.example.ddasigaeFlutter',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBcHktL2dROJJZQV41ywdDlv-7YDsvjOZs',
    appId: '1:616572887836:ios:ffe12eca2cdc34d704d0d9',
    messagingSenderId: '616572887836',
    projectId: 'ddasigae-d5462',
    databaseURL: 'https://ddasigae-d5462-default-rtdb.firebaseio.com',
    storageBucket: 'ddasigae-d5462.appspot.com',
    iosClientId: '616572887836-8j912ve98ub749eb63j8icft9vp4oqvq.apps.googleusercontent.com',
    iosBundleId: 'com.example.ddasigaeFlutter',
  );
}