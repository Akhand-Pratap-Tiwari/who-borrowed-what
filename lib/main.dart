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

//TODO: Remove Future delayed at the end
//TODO: Set anim durations 
//TODO: Add cancel op,
//TODO: Add collapsible button
//TODO: Remove debug prints
//TODO: Implement date search
//TODO: Make Mobile call 
//TODO: Remove display methods
//TODO: Remove state passing logic
//TODO: Improve Themeing

  runApp(const MyApp());
}