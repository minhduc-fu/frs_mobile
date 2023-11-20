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
    apiKey: 'AIzaSyBBGpwhUOXldjsaPYQU6Fo3piErtsYFJW4',
    appId: '1:204374474957:web:0d5d6d3ed7ad37dc5e2984',
    messagingSenderId: '204374474957',
    projectId: 'authtutorial-2b252',
    authDomain: 'authtutorial-2b252.firebaseapp.com',
    storageBucket: 'authtutorial-2b252.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdC0jMEcr_o-6VmMIhvKqRL25k5UcySbQ',
    appId: '1:204374474957:android:59ddc396cc1b02235e2984',
    messagingSenderId: '204374474957',
    projectId: 'authtutorial-2b252',
    storageBucket: 'authtutorial-2b252.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDMqYDzlzUgO19wRXSKJGPLClZR5vmEX68',
    appId: '1:204374474957:ios:58ed83cbf9edcff05e2984',
    messagingSenderId: '204374474957',
    projectId: 'authtutorial-2b252',
    storageBucket: 'authtutorial-2b252.appspot.com',
    iosClientId:
        '204374474957-tttlcmprah4059sgukemcmgnk32fe880.apps.googleusercontent.com',
    iosBundleId: 'com.example.demoFrsApp',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDMqYDzlzUgO19wRXSKJGPLClZR5vmEX68',
    appId: '1:204374474957:ios:2f40e9005d6128145e2984',
    messagingSenderId: '204374474957',
    projectId: 'authtutorial-2b252',
    storageBucket: 'authtutorial-2b252.appspot.com',
    iosClientId:
        '204374474957-8trjsnaffg33pkjid4d0lb8v4di8anj8.apps.googleusercontent.com',
    iosBundleId: 'com.example.demoFrsApp.RunnerTests',
  );
}
