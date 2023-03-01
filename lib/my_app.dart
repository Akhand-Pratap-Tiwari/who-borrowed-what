import 'package:flutter/material.dart';

import 'home.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Who Borrowed What',
      debugShowCheckedModeBanner: true,
      theme: ThemeData(
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
      ),
      themeMode: ThemeMode.system,
      home: const Home(),
    );
  }
}