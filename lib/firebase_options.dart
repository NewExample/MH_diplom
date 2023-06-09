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
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'you can reconfigure this by running the FlutterFire CLI again.',
      );
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

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC2Tg0_-uz7ZbCRdolDYgIcKhh9gEHQSH4',
    appId: '1:617659426007:android:aee9276cf5e724d831bc92',
    messagingSenderId: '617659426007',
    projectId: 'megaholod-77f3e',
    storageBucket: 'megaholod-77f3e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBSUIJS6RZW82orAkgpKoF-RlClrmU4bdA',
    appId: '1:617659426007:ios:053b10f107c0696131bc92',
    messagingSenderId: '617659426007',
    projectId: 'megaholod-77f3e',
    storageBucket: 'megaholod-77f3e.appspot.com',
    androidClientId: '617659426007-3lle2mvacpm67bocpdkjpihrmr1rk51u.apps.googleusercontent.com',
    iosClientId: '617659426007-n4tevist84sscm0d1j53t711c1hd6212.apps.googleusercontent.com',
    iosBundleId: 'com.fullstack7777.megaholodclient',
  );
}
