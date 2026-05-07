import 'package:flutter/material.dart';
import 'dart:async'; 

// --- SEMUA IMPORT DIKUMPULKAN DI ATAS (Biar nggak error) ---
import 'admin/dashboard_admin.dart'; 
import 'admin/order_admin.dart';     
import 'admin/menu_management.dart'; 
import 'admin/profit_admin.dart';    
import 'admin/profil_admin.dart'; 
import 'admin/manage_customer.dart'; 
import 'dashboard_menu.dart'; 

// --- FUNGSI MAIN CUMA BOLEH SATU ---
void main() {
  runApp(const PangsitNjedokApp()); 
}

// --- CLASS UTAMA (Semua rute admin & dashboard digabung di sini) ---
class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pangsit Njedok',
      
      // Tema gabungan (Menggunakan oranye desainmu & font Inter/Jakarta)
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F7F5),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9442)),
        fontFamily: 'Plus Jakarta Sans', // Pakai font desainmu
        useMaterial3: true,
      ),

      // HALAMAN AWAL: Langsung ke DashboardPage buatanmu
      home: const DashboardPage(), 

      // SEMUA RUTE ADMIN (Tetap ada, nggak aku hapus)
      routes: {
        '/dashboard': (context) => const DashboardAdmin(),
        '/order':     (context) => const OrderManagement(),
        '/menu':      (context) => const MenuManagement(), 
        '/profit':    (context) => const profitAdmin(),
        '/profil':    (context) => const ProfilReportAdmin(),
        '/customers': (context) => const ManageCustomers(),
      },
    );
  }
}

