import 'package:flutter/material.dart';
import 'customer/profil_customer.dart';

// ✅ TAMBAHIN IMPORT HALAMAN CUSTOMER DI SINI
import 'dashboard_menu.dart'; 
import 'halaman_menu.dart';

// --- FUNGSI MAIN CUMA BOLEH SATU ---
void main() {
  // Disamakan dengan nama class di bawah (PangsitNjedogApp)
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
      
      // ✅ PINTU MASUK DIGESER KE HALAMAN CUSTOMER
      initialRoute: '/customer_dashboard', 

      // SEMUA RUTE ADMIN & CUSTOMER
      routes: {
        // --- RUTE ADMIN (Tetap aman, nggak aku hapus) ---
        '/dashboard': (context) => const DashboardAdmin(),
        '/order':     (context) => const OrderManagement(),
        '/menu':      (context) => const MenuManagement(), 
        '/profit':    (context) => const profitAdmin(),
        '/profil':    (context) => const ProfilReportAdmin(),
        '/customers': (context) => const ManageCustomers(),

        // --- ✅ RUTE CUSTOMER BARU ---
        '/customer_dashboard': (context) => const DashboardPage(),
        '/customer_menu':      (context) => const MenuFoodScreen(),
      },
    );
  }
}