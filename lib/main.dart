import 'package:flutter/material.dart';
import 'halaman_login.dart';

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pangsit Njedok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFDF1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9442)),
        // fontFamily: 'Public Sans', // Aktifkan jika font sudah ditambah di pubspec.yaml
      ),
      home: const HalamanLogin(),
    );
  }
}