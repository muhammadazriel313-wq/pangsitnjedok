import 'package:flutter/material.dart';
<<<<<<< HEAD
import 'rating_views.dart';

void main() {
  // Disamakan dengan nama class di bawah (PangsitNjedogApp)
=======

// --- IMPORT FILE DARI FOLDER ADMIN ---
// Karena file kamu ada di dalam folder 'admin', kita tambahkan path 'admin/'
import 'admin/dashboard_admin.dart'; 
import 'admin/order_admin.dart';     
import 'admin/menu_management.dart'; 
import 'admin/Profit_admin.dart';    
import 'admin/profil_admin.dart'; 
import 'admin/manage_customer.dart'; 
  

void main() {
>>>>>>> 483ee860156f183273118e6c727806fbd24769bf
  runApp(const PangsitNjedogApp());
}

class PangsitNjedogApp extends StatelessWidget {
  const PangsitNjedogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
<<<<<<< HEAD
      title: 'Pangsit Njedog',
      debugShowCheckedModeBanner: false, // Menghilangkan banner debug
      theme: ThemeData(
        // Perbaikan: Tambahkan 'ColorScheme' sebelum '.fromSeed'
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),

      home: const RatingViewsPage(), 
=======
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
>>>>>>> 483ee860156f183273118e6c727806fbd24769bf
    );
  }
}