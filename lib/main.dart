<<<<<<<<< Temporary merge branch 1
import 'package:flutter/material.dart';
import 'profil_customer.dart';
=========
import 'package:flutter/material.dart'; // Import library Flutter untuk membangun UI
import 'home.dart'; // IMPORT PENTING: Menghubungkan main.dart dengan file home.dart agar bisa memanggil HomePage
>>>>>>>>> Temporary merge branch 2

// Fungsi utama — Titik awal (Entry Point) aplikasi dijalankan oleh sistem
void main() {
<<<<<<<<< Temporary merge branch 1
  runApp(const PangsitNjedogApp());
=========
  runApp(const PangsitNjedokApp()); // Perintah untuk menjalankan widget root aplikasi
>>>>>>>>> Temporary merge branch 2
}

// Widget Root — Tempat settingan global aplikasi (Judul, Tema, Warna Dasar)
class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan label "DEBUG" merah di pojok kanan atas layar
      title: "Pangsit Njedok",           // Judul aplikasi yang muncul di daftar 'Recent Apps' HP
      theme: ThemeData(
        // Perbaikan: Tambahkan 'ColorScheme' sebelum '.fromSeed'
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: Menentukan halaman pertama yang muncul saat aplikasi terbuka.
      // Kita memanggil 'HomePage' yang kodingannya ada di file home.dart.
      home: const HomePage(), 
    );
  }
}