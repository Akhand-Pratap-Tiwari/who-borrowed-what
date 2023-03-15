import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'firebase_options.dart';
import 'my_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // .then((value) => FirebaseFirestore.instance.settings = const Settings(persistenceEnabled: false));
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
    ),
  );
//Add icon
//Change Name
//TODO: Add Authentication
//TODO: Add collapsible button
//TODO: Remove state passing logic
//TODO: Remove debug prints
//TODO: Write some comments
//More ifo on long press on tile
  runApp(const MyApp());
}