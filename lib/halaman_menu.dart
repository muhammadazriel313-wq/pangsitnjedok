import 'package:flutter/material.dart';

void main() {
  runApp(const PangsitApp());
}

class PangsitApp extends StatelessWidget {
  const PangsitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Menu Food',
      theme: ThemeData(
        fontFamily: 'Inter', // Pastikan font Inter sudah ada di pubspec.yaml
        scaffoldBackgroundColor: const Color(0xFFF8F7F5),
      ),
      home: const MenuFoodScreen(),
    );
  }
}

// --- DATA MODEL ---
class MenuItem {
  final String title;
  final String price;
  final String rating; // Kuubah jadi String biar gampang nulis format "4.8"
  final String imageUrl;
  final bool isBestSeller;

  MenuItem({
    required this.title,
    required this.price,
    required this.rating,
    required this.imageUrl,
    this.isBestSeller = false,
  });
}

class MenuFoodScreen extends StatefulWidget {
  const MenuFoodScreen({super.key});

  @override
  State<MenuFoodScreen> createState() => _MenuFoodScreenState();
}

class _MenuFoodScreenState extends State<MenuFoodScreen> {
  // --- DATA DUMMY ---
  final List<MenuItem> menuItems = [
    MenuItem(title: 'Mietiaw Chili Oil', price: 'Rp 15.000', rating: '4.8', imageUrl: 'https://placehold.co/400x300/png'),
    MenuItem(title: 'Mietiaw Mentai', price: 'Rp 19.000', rating: '4.9', imageUrl: 'https://placehold.co/400x300/png', isBestSeller: true),
    MenuItem(title: 'Wonton Chili Oil', price: 'Rp 13.000', rating: '4.7', imageUrl: 'https://placehold.co/400x300/png'),
    MenuItem(title: 'Wonton Mentai', price: 'Rp 18.000', rating: '4.8', imageUrl: 'https://placehold.co/400x300/png', isBestSeller: true),
    MenuItem(title: 'Oseng Pangsit Pedas', price: 'Rp 15.000', rating: '4.9', imageUrl: 'https://placehold.co/400x300/png'),
    MenuItem(title: 'Extra Siomay Daging', price: 'Rp 3.000', rating: '4.7', imageUrl: 'https://placehold.co/400x300/png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F5),
        elevation: 0,
        centerTitle: false, // Biar tulisan "Menu" ada di kiri, nggak di tengah
        title: const Text(
          'Menu',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100), // Spasi aman buat Bottom Nav
        children: [
          _buildBanner(),
          _buildCategoryTabs(),
          _buildMenuGrid(),
        ],
      ),
      // Custom Bottom Navigation Bar
      bottomNavigationBar: _buildBottomNavigationBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(),
    );
  }

  // --- WIDGETS --- //

  Widget _buildBanner() {
    return Container(
      height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        image: const DecorationImage(
          image: NetworkImage('https://placehold.co/800x400/png'), // Placeholder gambar banner
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black87, Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'CATEGORY',
              style: TextStyle(color: Color(0xFFFF9442), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5),
            ),
            SizedBox(height: 4),
            Text(
              'Authentic Pangsit',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          // Tombol Food (Aktif)
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: const Color(0xFFFF9442),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [BoxShadow(color: const Color(0xFFFF9442).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))],
              ),
              alignment: Alignment.center,
              child: const Text('Food', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
          const SizedBox(width: 12),
          // Tombol Drink (Non-Aktif)
          Expanded(
            child: Container(
              height: 40,
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: const Color(0xFFCBD5E1)),
                borderRadius: BorderRadius.circular(30),
              ),
              alignment: Alignment.center,
              child: const Text('Drink', style: TextStyle(color: Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75, // Rasio disesuaikan biar pas seperti desain
      ),
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        return _buildMenuCard(menuItems[index]);
      },
    );
  }

  Widget _buildMenuCard(MenuItem item) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bagian Gambar & Label Atas
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(item.imageUrl, width: double.infinity, fit: BoxFit.cover),
                ),
                // Icon Heart (Kanan Atas)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border, color: Colors.white, size: 16),
                  ),
                ),
                // Label Best Seller (Kiri Atas)
                if (item.isBestSeller)
                  Positioned(
                    top: 8,
                    left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: const Color(0xFFFF9442), borderRadius: BorderRadius.circular(8)),
                      child: const Text('BEST SELLER', style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ),
          // Bagian Teks & Harga
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Rating
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFF9442), size: 14),
                    const SizedBox(width: 4),
                    Text(item.rating, style: const TextStyle(color: Color(0xFFFF9442), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                // Judul
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 10),
                // Harga & Tombol Tambah
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item.price, style: const TextStyle(color: Color(0xFFFF9442), fontSize: 14, fontWeight: FontWeight.w800)),
                    const Icon(Icons.add_circle, color: Color(0xFFFF9442), size: 28),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // --- BAGIAN NAVIGATION BAR (Sama dengan sebelumnya) --- //
  
  Widget _buildBottomNavigationBar() {
    return BottomAppBar(
      color: Colors.white,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', false),
            _buildNavItem(Icons.restaurant_menu, 'Menu', true),
            const SizedBox(width: 48), // Ruang buat FAB Keranjang
            _buildNavItem(Icons.receipt_long_outlined, 'Orders', false),
            _buildNavItem(Icons.person_outline, 'Profile', false),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8)),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8),
            fontSize: 10,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildFab() {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFFF9442),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Color(0xFFF8F7F5), width: 4), // Bikin efek garis luar putih
          ),
          child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ),
        // Lingkaran Notif (Angka 3)
        Container(
          margin: const EdgeInsets.only(top: 4, right: 4),
          padding: const EdgeInsets.all(5),
          decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
          child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }
}