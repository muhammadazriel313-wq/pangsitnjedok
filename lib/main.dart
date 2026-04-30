import 'package:flutter/material.dart';
import 'dashboard_menu.dart'; // Manggil file dashboard buatanmu

void main() {
  runApp(const PangsitNjedokApp()); 
}

class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pangsit Njedok",
      theme: ThemeData(
        // Background utama sesuai desain UI kamu
        scaffoldBackgroundColor: const Color(0xFFF8F7F5),
        // Tema oranye khas Pangsit Njedok
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9442)),
        // Pastikan font 'Plus Jakarta Sans' udah ada di pubspec.yaml kamu ya!
        fontFamily: 'Plus Jakarta Sans', 
        useMaterial3: true,
      ),
      // Langsung tembak ke DashboardPage buatanmu yang udah bisa diklik-klik
      home: const DashboardPage(), 
    );
  }
}