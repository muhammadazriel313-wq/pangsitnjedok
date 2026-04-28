<<<<<<< HEAD
import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'order.dart';
=======
import 'profil_customer.dart';
=======
import 'package:flutter/material.dart'; // Import library Flutter untuk membangun UI
import 'home.dart'; // IMPORT PENTING: Menghubungkan main.dart dengan file home.dart agar bisa memanggil HomePage
>>>>>>> 805d5c3102e9c8aabfd869c1c558574546247ec9
>>>>>>> 122305217fd6a851ee3b7af1eb68bf1ddcdc1659

// Fungsi utama — Titik awal (Entry Point) aplikasi dijalankan oleh sistem
void main() {
<<<<<<< HEAD
  runApp(const FigmaToCodeApp());
}

class PangsitNjedogApp extends StatelessWidget {
  const PangsitNjedogApp({super.key});
=======
<<<<<<< HEAD
  runApp(const PangsitNjedogApp());
=======
  runApp(const PangsitNjedokApp()); // Perintah untuk menjalankan widget root aplikasi
>>>>>>> 805d5c3102e9c8aabfd869c1c558574546247ec9
}

// Widget Root — Tempat settingan global aplikasi (Judul, Tema, Warna Dasar)
class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key}); // Constructor untuk identifikasi widget di folder sistem
>>>>>>> 122305217fd6a851ee3b7af1eb68bf1ddcdc1659

  @override
  Widget build(BuildContext context) { // Fungsi untuk merakit struktur dasar aplikasi
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Menghilangkan label "DEBUG" merah di pojok kanan atas layar
      title: "Pangsit Njedok",           // Judul aplikasi yang muncul di daftar 'Recent Apps' HP
      theme: ThemeData(
<<<<<<< HEAD
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
=======
        // Mengatur warna latar belakang default untuk seluruh halaman agar seragam (Putih Abu-abu)
        scaffoldBackgroundColor: const Color(0xFFF8F8F8), 
>>>>>>> 122305217fd6a851ee3b7af1eb68bf1ddcdc1659
      ),
      // home: Menentukan halaman pertama yang muncul saat aplikasi terbuka.
      // Kita memanggil 'HomePage' yang kodingannya ada di file home.dart.
      home: const HomePage(), 
    );
  }
}