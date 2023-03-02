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
        brightness: Brightness.light,
        colorScheme: const ColorScheme.light(),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.dark(),
      ),
      themeMode: ThemeMode.system,
      home: const Home(),
    );
  }
}