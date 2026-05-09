import 'package:aplikasipangsitnjedok/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'features/apps/customer/profil_customer.dart';

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
      routes: AppRoutes.routes, // Menggunakan rute yang sudah didefinisikan
      // Di sini kita langsung arahkan ke halaman ProfilCustomer dari profil_customer.dart
       home: ProfilePage(),
    );
  }
}