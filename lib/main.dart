import 'dart:io';

import 'package:flutter/material.dart';
import 'package:resetti_gui/pages/home_page.dart';

void main() {
  if (!Platform.isLinux) {
    print("Unable to run on current platform!");
    return;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Resetti GUI',
      theme: ThemeData(
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
