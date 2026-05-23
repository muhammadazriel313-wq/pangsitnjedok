import 'package:flutter/material.dart';

import '../../customer/dashboard_menu.dart';
import '../../customer/halaman_menu.dart';
import '../../customer/order.dart';
import '../../customer/profil_customer.dart';
// --- FUNGSI UTAMA MEMBANGUN NAVBAR PUSAT ---
Widget buildBottomNavbar(BuildContext context, String currentRoute) {
  return BottomAppBar(
    shape: const CircularNotchedRectangle(),
    notchMargin: 8.0,
    color: const Color(0xFFFFFDF1), 
    child: SizedBox(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          // TOMBOL BERANDA
          _buildNavbarItem(
            context,
            icon: Icons.home_filled,
            label: 'Home',
            route: '/home_customer',
            isActive: currentRoute == '/home_customer',
          ),
          // TOMBOL MENU KATALOG
          _buildNavbarItem(
            context,
            icon: Icons.restaurant_menu,
            label: 'Menu',
            route: '/dashboard_menu',
            isActive: currentRoute == '/dashboard_menu',
          ),
          
          // Ruang kosong penyeimbang tombol tengah melayang
          const SizedBox(width: 40), 
          
          // TOMBOL RIWAYAT PESANAN
          _buildNavbarItem(
            context,
            icon: Icons.receipt_long,
            label: 'Orders',
            route: '/order_customer',
            isActive: currentRoute == '/order_customer',
          ),
          // TOMBOL AKUN / PROFIL
          _buildNavbarItem(
            context,
            icon: Icons.person_outline,
            label: 'Profile',
            route: '/profil_customer',
            isActive: currentRoute == '/profil_customer',
          ),
        ],
      ),
    ),
  );
}

// --- WIDGET INTERNAL PEMBANTU IKON NAVIGASI ---
Widget _buildNavbarItem(
  BuildContext context, {
  required IconData icon,
  required String label,
  required String route,
  required bool isActive,
}) {
  return InkWell(
    onTap: () {
      if (!isActive) {
        Widget targetPage;
        switch (route) {
          case '/home_customer':
            targetPage = const DashboardPage();
            break;
          case '/dashboard_menu':
            targetPage = const MenuFoodScreen();
            break;
          case '/order_customer':
            targetPage = const MyOrdersPage();
            break;
          case '/profil_customer':
            targetPage = const ProfilePage();
            break;
          default:
            targetPage = const DashboardPage();
        }

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => targetPage,
            transitionDuration: const Duration(milliseconds: 300),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: child,
              );
            },
          ),
        );
      }
    },
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: isActive ? const Color(0xFFFF9644) : const Color(0x99562F00),
          size: 26,
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            color: isActive ? const Color(0xFFFF9644) : const Color(0x99562F00),
          ),
        ),
      ],
    ),
  );
}
