import 'package:flutter/material.dart';

// --- IMPORT AUTH (Gerbang Masuk) ---
import 'tampilan_awal.dart';
import 'halaman_login.dart';
import 'halaman_register.dart';

// --- IMPORT SISI CUSTOMER (Jalur Folder lib/customer/) ---
import 'customer/dashboard_menu.dart';
import 'customer/halaman_menu.dart';
import 'customer/cart.dart';
import 'customer/order.dart';
import 'customer/profil_customer.dart';
import 'customer/my_favorites.dart';

// --- IMPORT SISI ADMIN (Jalur Folder lib/admin/) ---
import 'admin/cart_order_stastistic_admin.dart';
import 'admin/order_admin.dart';
import 'admin/menu_management.dart';
import 'admin/profit_admin.dart';
import 'admin/profil_admin.dart';
import 'admin/manage_customer.dart';

// --- FUNGSI MAIN CUMA BOLEH SATU ---
void main() {
  // Disamakan dengan nama class di bawah (PangsitNjedokApp)
  runApp(const PangsitNjedokApp());
}

class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pangsit Njedok',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFFFFDF1),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9442)),
        fontFamily: 'Inter',
      ),

      // Aplikasi dimulai dari Tampilan Awal
      home: const TampilanAwal(),

      // DAFTAR JALAN (ROUTES)
      routes: {
        '/login': (context) => const HalamanLogin(),
        '/register': (context) => const HalamanRegister(),

        // Rute Customer
        '/home_customer': (context) => const DashboardPage(),
        '/dashboard_menu': (context) => const MenuFoodScreen(),
        '/cart': (context) => const CartPage(),
        '/order_customer': (context) => const MyOrdersPage(),
        '/profil_customer': (context) => const ProfilePage(),
        '/my_favorites': (context) => const FavoritePage(),

        // Rute Admin
        '/dashboard_admin': (context) => const DashboardAdmin(),
        '/dashboard': (context) => const DashboardAdmin(),
        '/menu': (context) => const MenuManagement(),
        '/order': (context) => const OrderManagement(),
        '/profit': (context) => const profitAdmin(),
        '/profil': (context) => const ProfilReportAdmin(),
        '/customers': (context) => const ManageCustomers(),
      },
    );
  }
}