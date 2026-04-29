import 'package:flutter/material.dart';
import 'popup_konfirmasi.dart';

void main() {
  // Disamakan dengan nama class di bawah (PangsitNjedogApp)
  runApp(const PangsitNjedogApp());
}

class PangsitNjedogApp extends StatelessWidget {
  const PangsitNjedogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pangsit Njedog',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        // Perbaikan: Tambahkan 'ColorScheme' sebelum '.fromSeed'
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // Di sini kita langsung arahkan ke halaman RatingsReviewsPage dari rating.dart
      home: const PopupKonfirmasi(), 
    );
  }
}