import 'package:flutter/material.dart';
import 'rating_views.dart';

// --- IMPORT FILE DARI FOLDER ADMIN ---
import 'admin/dashboard_admin.dart'; 
import 'admin/order_admin.dart';     
import 'admin/menu_management.dart'; 
import 'admin/Profit_admin.dart';    
import 'admin/profil_admin.dart'; 
import 'admin/manage_customer.dart'; 

void main() {
  runApp(const PangsitNjedogApp());
}

class PangsitNjedogApp extends StatelessWidget {
  const PangsitNjedogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pangsit Njedog',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFFDF1),
        // Jika ingin menggunakan font Inter, pastikan sudah terdaftar di pubspec.yaml
        // textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
      ),
      
      // Kamu bisa pilih mau halaman awal yang mana:
      // Option A: Menggunakan Home (Langsung ke satu halaman)
      // home: const RatingViewsPage(), 

      // Option B: Menggunakan Initial Route (Navigasi Admin)
      initialRoute: '/dashboard', 

      // Daftar Rute Navigasi
      routes: {
        '/dashboard': (context) => const DashboardAdmin(),
        '/order':     (context) => const OrderManagement(),
        '/menu':      (context) => const MenuManagement(), 
        '/profit':    (context) => const profitAdmin(),
        '/profil':    (context) => const ProfilReportAdmin(),
        '/customers': (context) => const ManageCustomers(),
        '/rating':    (context) => const RatingViewsPage(),
      },
    );
  }
}