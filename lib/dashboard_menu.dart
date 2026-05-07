import 'package:flutter/material.dart';
import 'dart:async'; // WAJIB TAMBAH INI biar Timer slider otomatisnya jalan
import 'halaman_menu.dart'; 

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isFoodSelected = true;

  // --- VARIABEL UNTUK SLIDER BANNER OTOMATIS ---
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  @override
  void initState() {
    super.initState();
    // Bikin timer yang jalanin fungsi geser halaman setiap 3 detik
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) { // Karena gambarnya ada 2 (index 0 dan 1)
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
      body: SafeArea(
        child: SingleChildScrollView( 
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24), 
              _buildPromoBanner(), // Banner interaktif dipanggil di sini
              const SizedBox(height: 24),
              _buildCategories(), 
              const SizedBox(height: 24),
              const Text(
                'Rekomendasi', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
              const SizedBox(height: 16),
              _buildPopularItems(), 
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
        Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF9442), width: 2), 
                image: const DecorationImage(
                  image: AssetImage("assets/images/user.jpeg"), 
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Selamat Datang', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                Text('Pelanggan', style: TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Icon(Icons.notifications_none, color: Color(0xFF0F172A)),
        )
      ],
    );
  }

  Widget _buildPromoBanner() {
    // 1. SIAPIN GAMBAR BEDA UNTUK MAKANAN & MINUMAN
    List<String> bannerImages = _isFoodSelected 
        ? ['assets/images/ptulangrangu.jpeg', 'assets/images/wontonmentai.jpeg'] // Gambar pas Makanan diklik
        : ['assets/images/esbuahleci.jpeg', 'assets/images/lemontea.jpeg'];      // Gambar pas Minuman diklik

    return Container(
      height: 180, // Ditinggiin dikit biar fotonya lebih memanjakan mata
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
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
            // LAPISAN 2: GRADASI HITAM (Biar teks putih tetap kebaca jelas di atas gambar)
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
              ),
            ),
            // LAPISAN 3: TEKS DAN TOMBOL
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: const Color(0xFFFF9442), borderRadius: BorderRadius.circular(20)),
                    child: const Text('PENAWARAN SPESIAL', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 12),
                  // Logika teks berubah berdasarkan tab
                  Text(
                    _isFoodSelected ? 'Varian Rasa Terbaru' : 'Kesegaran Hakiki', 
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  // Logika sub-teks berubah
                  Text(
                    _isFoodSelected ? 'Pedesnya pas, nikmatnya puas!' : 'Segernya pas, nikmatnya puas!', 
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {}, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      elevation: 0,
                    ),
                    child: const Text('Pesan Sekarang', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategories() {
    return Row(
      children: [
        Expanded(
          child: _categoryButton(Icons.restaurant_menu, 'Makanan', _isFoodSelected, () {
            setState(() { 
              _isFoodSelected = true; 
              // Reset gambar ke slide pertama pas ganti tab
              _currentPage = 0;
              if (_pageController.hasClients) _pageController.jumpToPage(0);
            });
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _categoryButton(Icons.local_bar_outlined, 'Minuman', !_isFoodSelected, () {
            setState(() { 
              _isFoodSelected = false; 
              // Reset gambar ke slide pertama pas ganti tab
              _currentPage = 0;
              if (_pageController.hasClients) _pageController.jumpToPage(0);
            });
          }),
        ),
      ],
    );
  }

  Widget _categoryButton(IconData icon, String title, bool active, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFF4EC) : Colors.white, 
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: active ? const Color(0xFFFFCE99) : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center, 
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: active ? const Color(0xFFFF9442) : const Color(0xFFF1F5F9), 
                shape: BoxShape.circle
              ),
              child: Icon(icon, color: active ? Colors.white : Colors.grey, size: 18),
            ),
            const SizedBox(width: 8), 
            Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: active ? const Color(0xFF0F172A) : const Color(0xFF64748B))),
          ]
        ),
      ),
    );
  }

 Widget _buildPopularItems() {
    if (_isFoodSelected) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _foodCard(title: 'Pangsit tulang rangu', price: 'Rp 12.000', img: 'assets/images/ptulangrangu.jpeg')),
          const SizedBox(width: 16),
          Expanded(child: _foodCard(title: 'Wonton Mentai', price: 'Rp 12.000', img: 'assets/images/wontonmentai.jpeg')),
        ],
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: _foodCard(title: 'Es Leci Tea', price: 'Rp 8.000', img: 'assets/images/nipis.jpeg')),
          const SizedBox(width: 16),
          Expanded(child: _foodCard(title: 'Es Lemon Tea', price: 'Rp 5.000', img: 'assets/images/lemontea.jpeg')),
        ],
      );
    }
  }

  Widget _foodCard({required String title, required String price, required String img}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03), 
            blurRadius: 10, 
            offset: const Offset(0, 4)
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start, 
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), 
                child: Image.asset(img, height: 120, width: double.infinity, fit: BoxFit.cover),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.favorite_border, size: 18, color: Color(0xFF64748B)),
                ),
              )
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title, 
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFF9442))),
              ],
            ),
          ),
        ],
      ),
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
            _buildNavItem(Icons.home_outlined, 'Home', true, () {}),
            _buildNavItem(Icons.restaurant_menu, 'Menu', false, () {
            // Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuFoodScreen()));
            }),
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
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
            child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
          ),
        ),
      ],
    );
  }
}