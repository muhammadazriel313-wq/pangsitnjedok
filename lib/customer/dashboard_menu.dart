import 'package:flutter/material.dart';
import 'dart:async'; 
import 'halaman_menu.dart'; 
import '../service/api_service.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isFoodSelected = true;
  
  // --- VARIABEL API ---
  List<dynamic> _allMenus = [];
  bool _isLoading = true;

  // --- VARIABEL SLIDER ---
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  // ✅ VARIABEL UNTUK JUMLAH KERANJANG DI DASHBOARD
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchDashboardData(); // AMBIL DATA DARI DATABASE

    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 1) { 
        _currentPage++;
      } else {
        _currentPage = 0; 
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

  // FUNGSI TARIK DATA DARI XAMPP
  Future<void> _fetchDashboardData() async {
    try {
      final data = await ApiService.getMenus();
      setState(() {
        _allMenus = data;
        _isLoading = false;
      });
    } catch (e) {
      print("Error Dashboard: $e");
      setState(() { _isLoading = false; });
    }
  }

  @override
  void dispose() {
    _carouselTimer?.cancel(); 
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator( 
          onRefresh: _fetchDashboardData,
          child: SingleChildScrollView( 
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 24), 
                _buildPromoBanner(), 
                const SizedBox(height: 24),
                _buildCategories(), 
                const SizedBox(height: 24),
                const Text(
                  'Rekomendasi', 
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                ),
                const SizedBox(height: 16),
                _buildPopularItems(), // SEKARANG JADI DINAMIS
              ],
            ),
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
              width: 48, height: 48,
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
            color: Colors.white, shape: BoxShape.circle,
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: const Icon(Icons.notifications_none, color: Color(0xFF0F172A)),
        )
      ],
    );
  }

  Widget _buildPromoBanner() {
    List<String> bannerImages = _isFoodSelected 
        ? ['assets/images/ptulangrangu.jpeg', 'assets/images/wontonmentai.jpeg'] 
        : ['assets/images/esbuahleci.jpeg', 'assets/images/lemontea.jpeg']; 

    return Container(
      height: 180, width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: bannerImages.length,
              onPageChanged: (index) { setState(() { _currentPage = index; }); },
              itemBuilder: (context, index) {
                return Image.asset(bannerImages[index], fit: BoxFit.cover, width: double.infinity);
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                  begin: Alignment.centerLeft, end: Alignment.centerRight,
                ),
              ),
            ),
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
                  Text(
                    _isFoodSelected ? 'Varian Rasa Terbaru' : 'Kesegaran Hakiki', 
                    style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isFoodSelected ? 'Pedesnya pas, nikmatnya puas!' : 'Segernya pas, nikmatnya puas!', 
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {}, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white, foregroundColor: const Color(0xFF0F172A),
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
            setState(() { _isFoodSelected = true; _currentPage = 0; if (_pageController.hasClients) _pageController.jumpToPage(0); });
          }),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _categoryButton(Icons.local_bar_outlined, 'Minuman', !_isFoodSelected, () {
            setState(() { _isFoodSelected = false; _currentPage = 0; if (_pageController.hasClients) _pageController.jumpToPage(0); });
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
              decoration: BoxDecoration(color: active ? const Color(0xFFFF9442) : const Color(0xFFF1F5F9), shape: BoxShape.circle),
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
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442)));
    }

    final filtered = _allMenus.where((item) {
      String cat = item['category']?.toString().toLowerCase() ?? 'food';
      return _isFoodSelected ? cat == 'food' : cat == 'beverages';
    }).toList();

    if (filtered.isEmpty) {
      return const Center(child: Text("Belum ada rekomendasi."));
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: _foodCard(filtered[0])),
        const SizedBox(width: 16),
        Expanded(child: filtered.length > 1 ? _foodCard(filtered[1]) : const SizedBox()),
      ],
    );
  }

  Widget _foodCard(dynamic item) {
    String title = item['title'] ?? 'Menu';
    String price = item['price']?.toString() ?? '0';
    String img = item['image_url'] ?? '';
    
    // Ambil data stok
    int stock = int.tryParse(item['stock']?.toString() ?? '0') ?? 0;

    return GestureDetector(
      onTap: () {
        if (stock <= 0) {
          _showOutOfStockDialog(context);
        } else {
          print("Buka detail menu rekomendasi: $title");
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
        ),
        foregroundDecoration: stock <= 0 
            ? BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(30)) 
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, 
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)), 
                  child: img.isNotEmpty 
                    ? Image.network("${ApiService.baseUrl}/uploads/$img", height: 120, width: double.infinity, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.fastfood, size: 50))
                    : const Icon(Icons.image_not_supported, size: 50),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), shape: BoxShape.circle),
                    child: const Icon(Icons.favorite_border, size: 18, color: Color(0xFF64748B)),
                  ),
                ),
                if (stock <= 0)
                  Positioned(
                    bottom: 8, left: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                      child: const Text('HABIS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A)), maxLines: 1, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rp $price", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFF9442))),
                      GestureDetector(
                        onTap: () {
                          if (stock > 0) {
                            setState(() {
                              _cartItemCount++; 
                            });
                            // ✅ NOTIFIKASI DIUBAH JADI MELAYANG BIAR KERANJANG NGGAK NAIK
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$title ditambahkan!', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                                duration: const Duration(seconds: 1),
                                backgroundColor: const Color(0xFFFF9442),
                                behavior: SnackBarBehavior.floating, 
                                margin: const EdgeInsets.only(bottom: 80, left: 40, right: 40), 
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                              ),
                            );
                          } else {
                            _showOutOfStockDialog(context);
                          }
                        },
                        child: Icon(Icons.add_circle, color: stock <= 0 ? Colors.grey : const Color(0xFFFF9442), size: 24),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ✅ FUNGSI DIALOG STOK HABIS (Sama persis kayak di menu)
  void _showOutOfStockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min, 
            children: const [
              Icon(Icons.error_outline, color: Colors.red, size: 48), 
              SizedBox(height: 16),
              Text(
                'Stok tidak tersedia',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9442),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(120, 40), 
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white, shape: const CircularNotchedRectangle(),
      notchMargin: 8.0, elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', true, () {}),
            _buildNavItem(Icons.restaurant_menu, 'Menu', false, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuFoodScreen()));
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
      onTap: onTap, borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8), fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.w500)),
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
            boxShadow: [BoxShadow(color: const Color(0xFFFF9442).withOpacity(0.4), blurRadius: 12, spreadRadius: 2)]
          ),
          child: FloatingActionButton(
            onPressed: () {},
            backgroundColor: const Color(0xFFFF9442),
            elevation: 0, 
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(color: Colors.white, width: 4)),
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
        ),
        if (_cartItemCount > 0)
          Positioned(
            right: -2, top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Color(0xFFEF4444), shape: BoxShape.circle),
              child: Text(
                '$_cartItemCount', 
                style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ),
      ],
    );
  }
}