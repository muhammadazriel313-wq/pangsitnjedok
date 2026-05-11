import 'package:flutter/material.dart';
import 'customer/profil_customer.dart';

void main() {
  // Disamakan dengan nama class di bawah (PangsitNjedogApp)
  runApp(const PangsitNjedokApp());
}

class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key});

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
      // Di sini kita langsung arahkan ke halaman ProfilCustomer dari profil_customer.dart
       home: ProfilePage(),
    );
  }
}