import 'package:flutter/material.dart';

import 'home/home.dart';

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
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Colors.purple)

          // colorScheme: const ColorScheme.light(),
          ),
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          floatingActionButtonTheme:
              const FloatingActionButtonThemeData(backgroundColor: Colors.purple)

          // colorScheme: const ColorScheme.light(),
          ),
      themeMode: ThemeMode.system,
      home: const Home(),
    );
  }
}
