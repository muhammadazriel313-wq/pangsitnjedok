import 'package:flutter/material.dart'; // Import library Flutter untuk membangun UI
import 'dashboard_menu.dart'; // IMPORT PENTING: Menghubungkan main.dart dengan file dashboard_menu.dart agar bisa memanggil DashboardPage

// Fungsi utama — Titik awal (Entry Point) aplikasi dijalankan oleh sistem
void main() {
  runApp(const PangsitNjedokApp()); // Perintah untuk menjalankan widget root aplikasi
}

// Widget Root — Tempat settingan global aplikasi (Judul, Tema, Warna Dasar)
class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key}); // Constructor untuk identifikasi widget di folder sistem

  @override
  Widget build(BuildContext context) { // Fungsi untuk merakit struktur dasar aplikasi
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan label "DEBUG" merah di pojok kanan atas layar
      title: "Pangsit Njedok",          // Judul aplikasi yang muncul di daftar 'Recent Apps' HP
      theme: ThemeData(
        // Mengatur warna latar belakang default untuk seluruh halaman agar seragam (Putih Abu-abu)
        scaffoldBackgroundColor: const Color(0xFFF8F8F8), 
      ),
      // home: Menentukan halaman pertama yang muncul saat aplikasi terbuka.
      // Kita memanggil 'DashboardPage' yang kodingannya ada di file dashboard_menu.dart.
      home: const DashboardPage(), 
    );
  }
}