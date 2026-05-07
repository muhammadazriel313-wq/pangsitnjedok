import 'package:flutter/material.dart';
import 'dart:async'; // WAJIB TAMBAH INI biar Timer slider otomatisnya jalan
// IMPORT INI PENTING biar tombol Home bisa kenal dan balik ke file dashboard
import 'dashboard_menu.dart'; 

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
        fontFamily: 'Inter',
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
  final String rating;
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
  // 1. VARIABEL PENANDA TAB AKTIF
  bool _isFoodSelected = true;

  // --- VARIABEL UNTUK SLIDER BANNER OTOMATIS ---
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  // 2. DATA DUMMY MAKANAN 
  final List<MenuItem> foodItems = [
    MenuItem(title: 'Pangsit Tulang Rangu', price: 'Rp 15.000', rating: '4.8', imageUrl: 'assets/images/pangsitrangu.jpeg'),
    MenuItem(title: 'Wonton Mentai', price: 'Rp 19.000', rating: '4.9', imageUrl: 'assets/images/wontonmentai.jpeg', isBestSeller: true),
    MenuItem(title: 'Wonton Chili Oil', price: 'Rp 13.000', rating: '4.7', imageUrl: 'assets/images/wontonoil.jpeg'), 
    MenuItem(title: 'Siomay Daging', price: 'Rp 18.000', rating: '4.8', imageUrl: 'assets/images/siomay.jpeg', isBestSeller: true),
    MenuItem(title: 'Oseng Pangsit Pedas', price: 'Rp 15.000', rating: '4.9', imageUrl: 'assets/images/osengp.jpeg'),
    MenuItem(title: 'Extra Siomay Daging', price: 'Rp 3.000', rating: '4.7', imageUrl: 'assets/images/ptulangrangu.jpeg'),
    MenuItem(title: 'Oseng Pangsit Pedas Manis', price: 'Rp 15.000', rating: '4.8', imageUrl: 'assets/images/osengpangsit.jpeg'), 
    MenuItem(title: 'Pangsit Tulang Rangu Kukus', price: 'Rp 15.000', rating: '4.9', imageUrl: 'assets/images/ptulangrangu.jpeg', isBestSeller: true),
  ];

  // 3. DATA DUMMY MINUMAN 
  final List<MenuItem> drinkItems = [
    MenuItem(title: 'Es Jeruk Njedog', price: 'Rp 8.000', rating: '4.9', imageUrl: 'assets/images/nipis.jpeg', isBestSeller: true),
    MenuItem(title: 'Es Teh Manis', price: 'Rp 5.000', rating: '4.8', imageUrl: 'assets/images/lemontea.jpeg'),
    MenuItem(title: 'Es Teh Pucuk', price: 'Rp 6.000', rating: '4.7', imageUrl: 'assets/images/estehpucuk.jpeg'), 
    MenuItem(title: 'Es Leci', price: 'Rp 10.000', rating: '5.0', imageUrl: 'assets/images/leci.jpeg'), 
    MenuItem(title: 'Es Frambos', price: 'Rp 8.000', rating: '4.8', imageUrl: 'assets/images/frambos.jpeg'), 
    MenuItem(title: 'Es Buah Leci', price: 'Rp 12.000', rating: '4.9', imageUrl: 'assets/images/esbuahleci.jpeg', isBestSeller: true), 
  ];

  @override
  void initState() {
    super.initState();
    // Bikin timer yang jalanin fungsi geser halaman setiap 3 detik
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) { // Angka 2 karena kita akan pakai 3 gambar tiap kategori (index 0, 1, 2)
        _currentPage++;
      } else {
        _currentPage = 0; // Balik ke gambar pertama
      }

      if (_pageController.hasClients) {
        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel(); // Wajib dimatiin biar gak bocor memori
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8F7F5),
        elevation: 0,
        centerTitle: false,
        title: const Text(
          'Menu',
          style: TextStyle(color: Color(0xFF0F172A), fontSize: 24, fontWeight: FontWeight.w800),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 100),
        children: [
          _buildBanner(),
          _buildCategoryTabs(),
          _buildMenuGrid(),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(),
    );
  }

  // --- WIDGETS --- //

  Widget _buildBanner() {
    // 1. SIAPIN GAMBAR BEDA UNTUK MAKANAN & MINUMAN (Masing-masing 3 gambar biar seru)
    List<String> bannerImages = _isFoodSelected 
        ? [
            'assets/images/ptulangrangu.jpeg', 
            'assets/images/osengpangsit.jpeg',
            'assets/images/wontonmentai.jpeg'
          ] // Gambar pas Makanan diklik
        : [
            'assets/images/esbuahleci.jpeg', 
            'assets/images/lemontea.jpeg',
            'assets/images/nipis.jpeg'
          ]; // Gambar pas Minuman diklik

    return Container(
      height: 180, // Ditinggiin dikit biar pas dan estetik
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // LAPISAN 1: SLIDER GAMBAR
            PageView.builder(
              controller: _pageController,
              itemCount: bannerImages.length,
              onPageChanged: (index) {
                setState(() { _currentPage = index; });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  bannerImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
            // LAPISAN 2: GRADASI HITAM BAWAH (Biar teks putih tetap kebaca jelas)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
            // LAPISAN 3: TEKS KATEGORI
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'KATEGORI',
                    style: TextStyle(color: Color(0xFFFF9442), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    // LOGIKA TEKS BERUBAH OTOMATIS
                    _isFoodSelected ? 'Pangsit Spesial' : 'Minuman Segar',
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
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
          _buildTabButton(
            title: 'Makanan',
            isActive: _isFoodSelected,
            onTap: () {
              setState(() {
                _isFoodSelected = true;
                // Reset slider ke gambar pertama pas ganti tab
                _currentPage = 0;
                if (_pageController.hasClients) _pageController.jumpToPage(0);
              });
            },
          ),
          const SizedBox(width: 12),
          _buildTabButton(
            title: 'Minuman',
            isActive: !_isFoodSelected,
            onTap: () {
              setState(() {
                _isFoodSelected = false;
                // Reset slider ke gambar pertama pas ganti tab
                _currentPage = 0;
                if (_pageController.hasClients) _pageController.jumpToPage(0);
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({required String title, required bool isActive, required VoidCallback onTap}) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 40,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFFF9442) : Colors.transparent,
            border: isActive ? null : Border.all(color: const Color(0xFFCBD5E1)),
            borderRadius: BorderRadius.circular(30),
            boxShadow: isActive
                ? [BoxShadow(color: const Color(0xFFFF9442).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 4))]
                : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              color: isActive ? Colors.white : const Color(0xFF64748B),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    final currentList = _isFoodSelected ? foodItems : drinkItems;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.75,
      ),
      itemCount: currentList.length,
      itemBuilder: (context, index) {
        return _buildMenuCard(currentList[index]);
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
          Expanded(
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.asset(item.imageUrl, width: double.infinity, fit: BoxFit.cover),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.4), shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border, color: Colors.white, size: 16),
                  ),
                ),
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
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFF9442), size: 14),
                    const SizedBox(width: 4),
                    Text(item.rating, style: const TextStyle(color: Color(0xFFFF9442), fontSize: 12, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  item.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.bold, height: 1.2),
                ),
                const SizedBox(height: 10),
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

  // --- BAGIAN NAVIGATION BAR --- //
  
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
            _buildNavItem(Icons.home_outlined, 'Home', false, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const DashboardPage()),
              );
            }),
            
            _buildNavItem(Icons.restaurant_menu, 'Menu', true, () {}),
            
            const SizedBox(width: 48), 
            _buildNavItem(Icons.receipt_long_outlined, 'Order', false, () {}),
            _buildNavItem(Icons.person_outline, 'Profil', false, () {}),
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

  // --- ICON KERANJANG --- //
  Widget _buildFab() {
    return Stack(
      clipBehavior: Clip.none, 
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFFF9442).withOpacity(0.4),
                blurRadius: 12,
                spreadRadius: 2,
              )
            ]
          ),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xFFFF9442),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: Colors.white, width: 4), 
            ),
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
        ),
        Positioned(
          right: -2,
          top: -2,
          child: Container(
            padding: const EdgeInsets.all(4),
            decoration: const BoxDecoration(
              color: Color(0xFFEF4444),
              shape: BoxShape.circle,
            ),
            child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}