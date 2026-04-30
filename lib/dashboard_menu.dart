import 'package:flutter/material.dart';
import 'halaman_menu.dart'; 

// 1. UBAH JADI STATEFUL WIDGET BIAR BISA BERUBAH-UBAH
class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  // 2. TAMBAHIN VARIABEL PENANDA TAB AKTIF
  bool _isFoodSelected = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24), 
              _buildPromoBanner(),
              const SizedBox(height: 24),
              _buildCategories(), // Kategori dipanggil di sini
              const SizedBox(height: 24),
              const Text(
                'Popular Now',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),
              _buildPopularItems(), // Item populer dipanggil di sini
            ],
          ),
        ),
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: _buildBottomNavigationBar(context), 
    );
  }

  // --- WIDGET KOMPONEN ---
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Row(
          children: [
            CircleAvatar(
              radius: 24, 
              backgroundImage: AssetImage("assets/images/wontonmentai.jpeg") 
            ),
            SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                Text('Customer', style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const Icon(Icons.notifications_none, color: Color(0xFF0F172A)),
        )
      ],
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24), 
        gradient: const LinearGradient(
          colors: [Color(0xFF2A2D34), Color(0xFF5E6065)], 
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: const Color(0xFFFF9442), borderRadius: BorderRadius.circular(12)),
            child: const Text('LIMITED OFFER', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 8),
          const Text('Spicy Hot Arrival', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
          const Text('Extra kick for extra joy', style: TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () {}, 
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
            child: const Text('Order Now', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
          )
        ],
      ),
    );
  }

  Widget _buildCategories() {
    return Row(
      children: [
        // Tombol Food
        Expanded(
          child: _categoryButton(Icons.restaurant_menu, 'Food', _isFoodSelected, () {
            setState(() {
              _isFoodSelected = true; // Ubah ke makanan
            });
          }),
        ),
        const SizedBox(width: 16),
        // Tombol Drink
        Expanded(
          child: _categoryButton(Icons.local_drink, 'Beverages', !_isFoodSelected, () {
            setState(() {
              _isFoodSelected = false; // Ubah ke minuman
            });
          }),
        ),
      ],
    );
  }

  // Tambahin parameter onTap biar tombolnya bisa diklik
  Widget _categoryButton(IconData icon, String title, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30), // Biar efek kliknya ikutan membulat
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFF9442).withOpacity(0.1) : Colors.white, 
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: active ? const Color(0xFFFF9442).withOpacity(0.3) : const Color(0xFFCBD5E1)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: active ? const Color(0xFFFF9442) : Colors.transparent, shape: BoxShape.circle),
              child: Icon(icon, color: active ? Colors.white : Colors.grey, size: 16),
            ),
            const SizedBox(width: 8), 
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, color: active ? const Color(0xFF1E293B) : const Color(0xFF64748B))),
          ]
        ),
      ),
    );
  }

  Widget _buildPopularItems() {
    // 3. LOGIKA UNTUK NAMPILIN MENU YANG BEDA
    if (_isFoodSelected) {
      // Tampilan kalau tombol FOOD yang diklik
      return Row(
        children: [
          Expanded(child: _foodCard('Dimsum Ori', 'Rp 12.000', '4.9', 'assets/images/ptulangrangu.jpeg')),
          const SizedBox(width: 16),
          Expanded(child: _foodCard('Dimsum Mentai', 'Rp 15.000', '5.0', 'assets/images/wontonmentai.jpeg')),
        ],
      );
    } else {
      // Tampilan kalau tombol BEVERAGES yang diklik
      return Row(
        children: [
          Expanded(child: _foodCard('Es Jeruk Njedog', 'Rp 8.000', '4.9', 'assets/images/nipis.jpeg')),
          const SizedBox(width: 16),
          Expanded(child: _foodCard('Es Teh Manis', 'Rp 5.000', '4.8', 'assets/images/lemontea.jpeg')),
        ],
      );
    }
  }

  Widget _foodCard(String title, String price, String rating, String img) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16), 
          child: Image.asset(img, height: 100, width: double.infinity, fit: BoxFit.cover)
        ),
        const SizedBox(height: 12),
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
        const SizedBox(height: 4),
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFF9442))),
      ]),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
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
            _buildNavItem(Icons.home_filled, 'Home', true, () {}),
            
            _buildNavItem(Icons.restaurant_menu, 'Menu', false, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuFoodScreen()));
            }),
            
            const SizedBox(width: 48), 
            _buildNavItem(Icons.receipt_long_outlined, 'Orders', false, () {}),
            _buildNavItem(Icons.person_outline, 'Profile', false, () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
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
        ),
      ),
    );
  }

  Widget _buildFab() {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        FloatingActionButton(
          onPressed: () {},
          backgroundColor: const Color(0xFFFF9442),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Color(0xFFF8F7F5), width: 4),
          ),
          child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ),
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            padding: const EdgeInsets.all(5),
            decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
            child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}