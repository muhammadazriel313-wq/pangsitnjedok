import 'package:flutter/material.dart';

// ✅ IMPORT JALUR CUSTOMER (Sesuai folder baru)
import 'customer/profil_customer.dart';
import 'customer/dashboard_menu.dart'; 
import 'customer/halaman_menu.dart';

// ✅ IMPORT JALUR ADMIN (Ini yang bikin merah 9+ tadi karena belum dipanggil!)
import 'admin/dashboard_admin.dart';
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
      title: 'Pangsit Njedog App',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFFDF1),
        // Menggunakan font Inter agar sesuai dengan desain
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
      ),
      
      // ✅ PINTU MASUK CUSTOMER
      initialRoute: '/customer_dashboard', 

      // SEMUA RUTE ADMIN & CUSTOMER
      routes: {
        // --- RUTE ADMIN ---
        '/dashboard': (context) => const DashboardAdmin(),
        '/order':     (context) => const OrderManagement(),
        '/menu':      (context) => const MenuManagement(), 
        '/profit':    (context) => const profitAdmin(),
        '/profil':    (context) => const ProfilReportAdmin(),
        '/customers': (context) => const ManageCustomers(),

        // --- RUTE CUSTOMER BARU ---
        '/customer_dashboard': (context) => const DashboardPage(),
        '/customer_menu':      (context) => const MenuFoodScreen(),
      },
    );
  }
}