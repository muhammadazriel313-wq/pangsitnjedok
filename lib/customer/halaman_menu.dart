import 'package:flutter/material.dart';
import 'dart:async'; 
import 'dart:convert';

import '../service/api_service.dart';
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

class MenuFoodScreen extends StatefulWidget {
  const MenuFoodScreen({super.key});

  @override
  State<MenuFoodScreen> createState() => _MenuFoodScreenState();
}

class _MenuFoodScreenState extends State<MenuFoodScreen> {
  static const String _cartStorageKey = 'customer_cart_items_v1';
  bool _isFoodSelected = true;

  // --- VARIABEL UNTUK API ---
  List<dynamic> _allMenus = []; // Wadah untuk nyimpen data dari XAMPP
  bool _isLoading = true;       // Penanda buat nampilin animasi loading

  // --- VARIABEL UNTUK SLIDER BANNER ---
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  // ✅ VARIABEL UNTUK JUMLAH KERANJANG
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchMenuData(); // PANGGIL API SAAT HALAMAN DIBUKA
    _loadCartItemCount();

    // Timer slider tetap jalan
    _carouselTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (_currentPage < 2) { 
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

  // === FUNGSI SAKTI UNTUK TARIK DATA API ===
  Future<void> _fetchMenuData() async {
    try {
      final data = await ApiService.getMenus(); // Manggil fungsi dari api_service.dart
      setState(() {
        _allMenus = data; // Masukkan data ke wadah
        _isLoading = false; // Matikan loading
      });
    } catch (e) {
      print("Error ambil menu: $e");
      setState(() {
        _isLoading = false;
      });
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
          _buildMenuGrid(), // Bagian yang dinamis
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(),
    );
  }

  // --- WIDGETS --- //

  Widget _buildBanner() {
    List<String> bannerImages = _isFoodSelected 
        ? [
            'assets/images/pangsittulangrangu.jpg', 
            'assets/images/osengpangsit.jpg',
            'assets/images/wontonmentai.jpg'
          ] 
        : [
            'assets/images/esbuahleci.jpg', 
            'assets/images/lemontea.jpg',
            'assets/images/nipis.jpeg'
          ]; 

    return Container(
      height: 180, 
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
            PageView.builder(
              controller: _pageController,
              itemCount: bannerImages.length,
              onPageChanged: (index) {
                setState(() { _currentPage = index; });
              },
              itemBuilder: (context, index) {
                return Image.asset(bannerImages[index], fit: BoxFit.cover, width: double.infinity);
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.8), Colors.transparent],
                ),
              ),
            ),
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

  // === GRID DINAMIS ===
  Widget _buildMenuGrid() {
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(child: CircularProgressIndicator(color: Color(0xFFFF9442))),
      );
    }

    final filteredList = _allMenus.where((item) {
      String kategori = item['category']?.toString().toLowerCase() ?? 'food';
      return _isFoodSelected ? kategori == 'food' : kategori == 'beverages';
    }).toList();

    if (filteredList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(40.0),
        child: Center(child: Text('Belum ada menu di kategori ini.', style: TextStyle(color: Colors.grey))),
      );
    }

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
      itemCount: filteredList.length,
      itemBuilder: (context, index) {
        return _buildMenuCard(filteredList[index]); 
      },
    );
  }

  // === DESAIN CARD (Menerima data dinamis + Logika Stok) ===
  Widget _buildMenuCard(dynamic item) {
    String title = item['title'] ?? 'Nama Menu'; 
    String price = item['price']?.toString() ?? '0'; 
    int priceValue = int.tryParse(price) ?? 0;
    String subtitle = _isFoodSelected ? 'Food' : 'Beverages';
    String imageUrl = item['image_url'] ?? ''; 
    
    // ✅ 1. AMBIL DATA STOK DARI DATABASE (Penting!)
    int stock = int.tryParse(item['stock']?.toString() ?? '0') ?? 0;

    Widget imageWidget;
    if (imageUrl.isNotEmpty) {
      imageWidget = Image.network(
        "${ApiService.baseUrl}/uploads/$imageUrl", 
        width: double.infinity, 
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 50, color: Colors.grey),
      );
    } else {
      imageWidget = const Icon(Icons.image_not_supported, size: 50, color: Colors.grey);
    }

    return GestureDetector(
      onTap: () {
        if (stock <= 0) {
          _showOutOfStockDialog(context); 
        } else {
          print("Buka detail menu $title"); 
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        foregroundDecoration: stock <= 0 
            ? BoxDecoration(color: Colors.white.withOpacity(0.5), borderRadius: BorderRadius.circular(20)) 
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(
                      width: double.infinity,
                      color: Colors.grey.shade100,
                      child: imageWidget, 
                    ),
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
                  if (stock <= 0)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red, borderRadius: BorderRadius.circular(8)),
                        child: const Text('HABIS', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
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
                      const Text('4.8', style: TextStyle(color: Color(0xFFFF9442), fontSize: 12, fontWeight: FontWeight.bold)), 
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title, 
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rp $price", style: const TextStyle(color: Color(0xFFFF9442), fontSize: 14, fontWeight: FontWeight.w800)), 
                      // ✅ LOGIKA TOMBOL (+) DENGAN SNACKBAR MELAYANG
                      GestureDetector(
                        onTap: () async {
                          if (stock > 0) {
                            await _addItemToCart(
                              title: title,
                              subtitle: subtitle,
                              price: priceValue,
                            );
                            if (!mounted) return;
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
                        child: Icon(Icons.add_circle, color: stock <= 0 ? Colors.grey : const Color(0xFFFF9442), size: 28),
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

  // === FUNGSI DIALOG SINGKAT, PADAT, JELAS ===
  void _showOutOfStockDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min, // Biar kotaknya nggak kebesaran
            children: const [
              Icon(Icons.error_outline, color: Colors.red, size: 48), // Icon peringatan
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
                  Navigator.of(context).pop(); // Buat nutup pop-up
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9442),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  minimumSize: const Size(120, 40), // Ukuran tombol
                ),
                child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        );
      },
    );
  }

  // --- BAGIAN NAVIGATION BAR BAWAH --- //
  Widget _buildBottomNavigationBar(BuildContext context) {
    return buildBottomNavbar(context, '/dashboard_menu');
  }

  List<Map<String, dynamic>> _decodeCartItems(String? raw) {
    if (raw == null || raw.isEmpty) return [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded.whereType<Map>().map((item) => Map<String, dynamic>.from(item)).toList();
      }
    } catch (_) {}
    return [];
  }

  Future<void> _loadCartItemCount() async {
    final prefs = await SharedPreferences.getInstance();
    final items = _decodeCartItems(prefs.getString(_cartStorageKey));
    final total = items.fold<int>(
      0,
      (sum, item) => sum + (int.tryParse('${item['qty'] ?? 0}') ?? 0),
    );
    if (!mounted) return;
    setState(() => _cartItemCount = total);
  }

  Future<void> _addItemToCart({
    required String title,
    required String subtitle,
    required int price,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final items = _decodeCartItems(prefs.getString(_cartStorageKey));

    final existingIndex = items.indexWhere((item) => '${item['title']}' == title);
    if (existingIndex >= 0) {
      final currentQty = int.tryParse('${items[existingIndex]['qty'] ?? 0}') ?? 0;
      items[existingIndex]['qty'] = currentQty + 1;
      items[existingIndex]['price'] = price;
      items[existingIndex]['subtitle'] = subtitle;
    } else {
      items.add({
        'title': title,
        'subtitle': subtitle,
        'price': price,
        'qty': 1,
      });
    }

    await prefs.setString(_cartStorageKey, jsonEncode(items));
    await _loadCartItemCount();
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
            onPressed: () async {
              await Navigator.pushNamed(context, '/cart');
              _loadCartItemCount();
            },
            backgroundColor: const Color(0xFFFF9442),
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(color: Colors.white, width: 4)),
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
        ),
        if (_cartItemCount > 0)
          Positioned(
            right: -2,
            top: -2,
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
