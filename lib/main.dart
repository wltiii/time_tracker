import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:time_tracker/presentation/time_tracker_app.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //TODO(wltiii): this was a sample Manoj gave me that could possibly point to how to setup Firestore emulator
  // FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);

  runApp(TimeTrackerApp());
}
