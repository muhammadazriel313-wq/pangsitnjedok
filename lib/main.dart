import 'package:flutter/material.dart';

// --- IMPORT FILE DARI FOLDER ADMIN ---
// Karena file kamu ada di dalam folder 'admin', kita tambahkan path 'admin/'
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
import 'dashboard_menu.dart'; // Manggil file dashboard buatanmu

void main() {
  runApp(const PangsitNjedokApp()); 
}

class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pangsit Njedog Admin',
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFFFDF1),
        // Menggunakan font Inter agar sesuai dengan desain
        textTheme: ThemeData.light().textTheme.apply(fontFamily: 'Inter'),
      ),
      
      // Halaman awal saat aplikasi dibuka
      initialRoute: '/dashboard', 

      // Daftar Rute Navigasi
      routes: {
        '/dashboard': (context) => const DashboardAdmin(),
        '/order':     (context) => const OrderManagement(),
        '/menu':      (context) => const MenuManagement(), 
        '/profit':   (context) => const profitAdmin(),
        '/profil':    (context) => const ProfilReportAdmin(),
        '/customers':  (context) => const ManageCustomers(),
        
      },
      title: "Pangsit Njedok",
      theme: ThemeData(
        // Background utama sesuai desain UI kamu
        scaffoldBackgroundColor: const Color(0xFFF8F7F5),
        // Tema oranye khas Pangsit Njedok
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9442)),
        // Pastikan font 'Plus Jakarta Sans' udah ada di pubspec.yaml kamu ya!
        fontFamily: 'Plus Jakarta Sans', 
        useMaterial3: true,
      ),
      // Langsung tembak ke DashboardPage buatanmu yang udah bisa diklik-klik
      home: const DashboardPage(), 
    );
  }
}