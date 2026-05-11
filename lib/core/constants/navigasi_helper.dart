import 'package:flutter/material.dart';

Widget buildBottomNavbar(BuildContext context, bool isProfileActive) {
  return BottomAppBar(
    height: 70, color: Colors.white,
    shape: const CircularNotchedRectangle(),
    notchMargin: 8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        navbarItem(Icons.home_outlined, 'Home', false),
        navbarItem(Icons.restaurant_menu, 'Menu', false),
        const SizedBox(width: 40),
        navbarItem(Icons.receipt_long_outlined, 'Orders', false),
        navbarItem(Icons.person, 'Profile', isProfileActive),
      ],
    ),
  );
}

Widget navbarItem(IconData icon, String label, bool isActive) {
  return Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, color: isActive ? const Color(0xFFFF9442) : Colors.grey),
    Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFFFF9442) : Colors.grey)),
  ]);
}

Widget buildFAB() {
  return FloatingActionButton(
    onPressed: () {},
    backgroundColor: const Color(0xFFFF9442),
    shape: const CircleBorder(),
    child: const Badge(label: Text('3'), child: Icon(Icons.shopping_cart_outlined, color: Colors.white)),
  );
}