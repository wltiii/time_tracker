import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:time_tracker/presentation/time_tracker_app.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //TODO(wltiii): toggle based on environment variables - see https://pub.dev/packages/dotenv
  // if (const bool.fromEnvironment("USE_FIREBASE_EMU")) {
  // await _configureFirebaseAuth();
  // await _configureFirebaseStorage();
  _configureFirestore();
  // }

  runApp(const ProviderScope(child: TimeTrackerApp()));
}

void _configureFirestore() {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  //TODO(wltiii): toggle based on environment variables - see https://pub.dev/packages/dotenv
  // String configHost = const String.fromEnvironment("FIREBASE_EMU_URL");
  // int configPort = const int.fromEnvironment("");

  final defaultHost = _defaultHost();

  //TODO(wltiii): toggle based on environment variables - see https://pub.dev/packages/dotenv
  // final host = configHost.isNotEmpty ? configHost : defaultHost;
  // final port = configPort != 0 ? configPort : 8080;
  final host = defaultHost;
  const port = 8080;

  //TODO(wltiii): this statement should be toggled per environment
  db.useFirestoreEmulator(host, 8080);

  db.settings = Settings(
    host: '$host:$port',
    persistenceEnabled: false,
    sslEnabled: false,
  );
}

String _defaultHost() {
  if (kIsWeb) {
    return 'localhost';
  }

  switch (defaultTargetPlatform) {
    case TargetPlatform.iOS:
      {
        return 'localhost';
      }
    case TargetPlatform.android:
      {
        return '10.0.2.2';
      }
    case TargetPlatform.linux:
      {
        return 'localhost';
      }
    case TargetPlatform.macOS:
      {
        return 'localhost';
      }
    case TargetPlatform.windows:
      {
        return 'localhost';
      }
    default:
      {
        return 'localhost';
      }
  }
}
