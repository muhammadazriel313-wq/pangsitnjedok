<<<<<<< HEAD
import 'package:flutter/material.dart';
import 'profil_customer.dart';
=======
import 'package:flutter/material.dart'; // Import library Flutter untuk membangun UI
import 'home.dart'; // IMPORT PENTING: Menghubungkan main.dart dengan file home.dart agar bisa memanggil HomePage
>>>>>>> 805d5c3102e9c8aabfd869c1c558574546247ec9

// Fungsi utama — Titik awal (Entry Point) aplikasi dijalankan oleh sistem
void main() {
<<<<<<< HEAD
  runApp(const PangsitNjedogApp());
=======
  runApp(const PangsitNjedokApp()); // Perintah untuk menjalankan widget root aplikasi
>>>>>>> 805d5c3102e9c8aabfd869c1c558574546247ec9
}

// Widget Root — Tempat settingan global aplikasi (Judul, Tema, Warna Dasar)
class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key}); // Constructor untuk identifikasi widget di folder sistem

  @override
  Widget build(BuildContext context) { // Fungsi untuk merakit struktur dasar aplikasi
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan label "DEBUG" merah di pojok kanan atas layar
      title: "Pangsit Njedok",           // Judul aplikasi yang muncul di daftar 'Recent Apps' HP
      theme: ThemeData(
        // Mengatur warna latar belakang default untuk seluruh halaman agar seragam (Putih Abu-abu)
        scaffoldBackgroundColor: const Color(0xFFF8F8F8), 
      ),
      // home: Menentukan halaman pertama yang muncul saat aplikasi terbuka.
      // Kita memanggil 'HomePage' yang kodingannya ada di file home.dart.
      home: const HomePage(), 
    );
  }
}