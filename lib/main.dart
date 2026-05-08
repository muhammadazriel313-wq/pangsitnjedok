import 'package:flutter/material.dart';
import 'features/auth/screens/tampilan_awal.dart';

// --- IMPORT HALAMAN ADMIN ---
import 'features/apps/admin/dashboard_admin.dart';
import 'features/apps/admin/menu_management.dart';
import 'features/apps/admin/manage_customer.dart';
import 'features/apps/admin/order_admin.dart';
import 'features/apps/admin/profit_admin.dart';
import 'features/apps/admin/profil_admin.dart';

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pangsit Njedog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFDF1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9442)),
      ),
      // Halaman pertama kali aplikasi dibuka
      home: const TampilanAwal(),

      // --- MATERI PRAKTIKUM: PENDAFTARAN RUTE (ROUTES) ---
      // Di sinilah kita mendaftarkan "peta" navigasinya
// --- PENDAFTARAN RUTE YANG SUDAH DIREVISI ---
      routes: {
        '/dashboard': (context) => const DashboardAdmin(),
        '/menu': (context) => const MenuManagement(), 
        '/customers': (context) => const ManageCustomers(),   // Tambah 's'
        '/order': (context) => const OrderManagement(),       // Sesuai nama class temanmu
        '/profit': (context) => const profitAdmin(), 
        '/profil': (context) => const ProfilReportAdmin(),    // Sesuai nama class temanmu
      },
    );
  }
}