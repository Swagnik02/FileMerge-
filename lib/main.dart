import 'package:filemerge_plus/ui/home_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      themeMode: ThemeMode.dark,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    ),
  );
}
