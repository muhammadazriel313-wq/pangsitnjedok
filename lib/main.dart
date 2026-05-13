import 'package:flutter/material.dart';

// --- IMPORT AUTH (Gerbang Masuk) ---
import 'tampilan_awal.dart';
import 'halaman_login.dart';
import 'halaman_register.dart';

// --- IMPORT SISI CUSTOMER (Jalur Folder lib/customer/) ---
import 'customer/halaman_utama.dart';
import 'customer/dashboard_menu.dart';
import 'customer/cart.dart';
import 'customer/order.dart';
import 'customer/profil_customer.dart';

// --- IMPORT SISI ADMIN (Jalur Folder lib/admin/) ---
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
      debugShowCheckedModeBanner: false,
      title: 'Pangsit Njedog',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFDF1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9442)),
        fontFamily: 'Inter',
      ),
      
      // Aplikasi dimulai dari Tampilan Awal
      home: const TampilanAwal(),

      // DAFTAR JALAN (ROUTES)
      routes: {
        '/login':           (context) => const HalamanLogin(),
        '/register':        (context) => const HalamanRegister(),

        // Rute Customer
        '/home_customer':   (context) => const HalamanUtama(),
        '/dashboard_menu':  (context) => const DashboardPage(),
        '/cart':            (context) => const CartPage(),
        '/order':           (context) => const MyOrdersPage(),
        '/profil_customer': (context) => const ProfilePage(),

        // Rute Admin
        '/dashboard_admin': (context) => const DashboardAdmin(),
        '/menu':            (context) => const MenuManagement(),
        '/order_admin':     (context) => const OrderManagement(),
        '/profit':          (context) => const profitAdmin(),
        '/profil_admin':    (context) => const ProfilReportAdmin(),
        '/customers':       (context) => const ManageCustomers(),
      },
    );
  }
}