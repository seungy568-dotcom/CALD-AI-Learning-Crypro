import 'package:flutter/material.dart';
import 'homepage.dart';

void main() {
  runApp(const CALDApp());
}

class CALDApp extends StatelessWidget {
  const CALDApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CALD Crypto Demo',
      theme: ThemeData.dark(),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
