import 'package:flutter/material.dart';

// --- IMPORT HALAMAN AUTENTIKASI ---
import 'tampilan_awal.dart';
import 'halaman_login.dart';
import 'halaman_register.dart';

// --- IMPORT HALAMAN ADMIN ---
import 'admin/dashboard_admin.dart';
import 'admin/menu_management.dart';
import 'admin/order_admin.dart';
import 'admin/profit_admin.dart';
import 'admin/profil_admin.dart';
import 'admin/manage_customer.dart';

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
        // fontFamily: 'Inter', // Aktifkan jika font Inter sudah terpasang
      ),
      
      // Pintu masuk utama aplikasi saat pertama kali dibuka
      home: const TampilanAwal(),

      // --- MATERI PRAKTIKUM: PETA RUTE NAVIGASI (NAMED ROUTES) ---
      // Wajib didaftarkan agar bottomNavigationBar di sisi Admin berfungsi 100%
      routes: {
        // Rute Autentikasi
        '/login': (context) => const HalamanLogin(),
        '/register': (context) => const HalamanRegister(),

        // Rute Admin
        '/dashboard': (context) => const DashboardAdmin(),
        '/menu':      (context) => const MenuManagement(),
        
        // Catatan: Nama class di bawah disesuaikan dengan perbaikan kita sebelumnya.
        '/order':     (context) => const OrderManagement(),    // Sesuaikan jika class-nya OrderAdmin
        '/profit':    (context) => const profitAdmin(),
        '/profil':    (context) => const ProfilReportAdmin(),  // Sesuaikan jika class-nya ProfilAdmin
        '/customers': (context) => const ManageCustomers(),    // Sesuaikan jika class-nya ManageCustomer
      },
    );
  }
}