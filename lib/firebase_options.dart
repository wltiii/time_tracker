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
    apiKey: 'AIzaSyAn5BEl5MzTONNb_0cVCECsd6z0SeIV6rk',
    appId: '1:908580758760:web:54976b7f47f41096b0955d',
    messagingSenderId: '908580758760',
    projectId: 'time-tracker-a6c3f',
    authDomain: 'time-tracker-a6c3f.firebaseapp.com',
    storageBucket: 'time-tracker-a6c3f.appspot.com',
    measurementId: 'G-38VB2EZXBN',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDT8zcXeq9JWN31OMWmd3jFf1kMUsGj51A',
    appId: '1:908580758760:android:b8c0f5f5e1ba9d84b0955d',
    messagingSenderId: '908580758760',
    projectId: 'time-tracker-a6c3f',
    storageBucket: 'time-tracker-a6c3f.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB5lMdLfUcsvmMzybH_HsVCijvNhaxayHY',
    appId: '1:908580758760:ios:d8a48b3c6a8bd297b0955d',
    messagingSenderId: '908580758760',
    projectId: 'time-tracker-a6c3f',
    storageBucket: 'time-tracker-a6c3f.appspot.com',
    iosClientId: '908580758760-avta7k4u6eclvqhfaavppk5lo4bqpann.apps.googleusercontent.com',
    iosBundleId: 'com.example.timeTracker',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyB5lMdLfUcsvmMzybH_HsVCijvNhaxayHY',
    appId: '1:908580758760:ios:d8a48b3c6a8bd297b0955d',
    messagingSenderId: '908580758760',
    projectId: 'time-tracker-a6c3f',
    storageBucket: 'time-tracker-a6c3f.appspot.com',
    iosClientId: '908580758760-avta7k4u6eclvqhfaavppk5lo4bqpann.apps.googleusercontent.com',
    iosBundleId: 'com.example.timeTracker',
  );
}