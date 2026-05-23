
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart'; 

import 'dashboard_menu.dart'; 
import '../service/api_service.dart';
import 'cart.dart'; 
import 'order.dart';
import 'profil_customer.dart';

class MenuFoodScreen extends StatefulWidget {
  const MenuFoodScreen({super.key});

  @override
  State<MenuFoodScreen> createState() => _MenuFoodScreenState();
}

class _MenuFoodScreenState extends State<MenuFoodScreen> {
  bool _isFoodSelected = true;
  List<dynamic> _allMenus = []; 
  bool _isLoading = true; 

  List<int> _favoriteMenuIds = [];

  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;

  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _fetchMenuData(); 
    _fetchFavorites(); 

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

  Future<void> _fetchMenuData() async {
    try {
      final data = await ApiService.getMenus(); 
      setState(() {
        _allMenus = data; 
        _isLoading = false; 
      });
    } catch (e) {
      debugPrint("Error ambil menu: $e");
      setState(() { _isLoading = false; });
    }
  }

  Future<void> _fetchFavorites() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String customerId = prefs.getString('id') ?? "1"; 

      final data = await ApiService.getFavorites(int.parse(customerId));
      setState(() {
        _favoriteMenuIds = data.map<int>((item) => int.parse(item['id'].toString())).toList();
      });
    } catch (e) {
      debugPrint("Error ambil daftar favorite: $e");
    }
  }

  Future<void> _toggleFavorite(int menuId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String customerId = prefs.getString('id') ?? "1"; 
    
    bool isAlreadyFavorite = _favoriteMenuIds.contains(menuId);

    setState(() {
      if (isAlreadyFavorite) {
        _favoriteMenuIds.remove(menuId);
      } else {
        _favoriteMenuIds.add(menuId);
      }
    });

    try {
      bool success = await ApiService.toggleFavorite(customerId, menuId.toString(), isAlreadyFavorite ? "remove" : "add");

      if (!success) {
        setState(() {
          if (isAlreadyFavorite) {
            _favoriteMenuIds.add(menuId); 
          } else {
            _favoriteMenuIds.remove(menuId); 
          }
        });
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengubah favorit!')));
      }
    } catch (e) {
      debugPrint("Error toggle favorite: $e");
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
          _buildMenuGrid(), 
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(),
    );
  }

  Widget _buildBanner() {
    List<String> bannerImages = _isFoodSelected 
        ? [
            'assets/images/pangsittulangrangu.jpg', 
            'assets/images/pangsitgoreng.jpg',
            'assets/images/wontonmentai.jpg'
          ] 
        : [
            'assets/images/esyakultleci.jpg', 
            'assets/images/esframbos.jpg',
            'assets/images/eslemontea.jpg'
          ]; 

    return Container(
      height: 180, 
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: bannerImages.length,
              onPageChanged: (index) { setState(() { _currentPage = index; }); },
              itemBuilder: (context, index) { 
                return Image.asset(bannerImages[index], fit: BoxFit.cover, width: double.infinity,
                  errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey),
                ); 
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter, end: Alignment.topCenter,
                  colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
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
            title: 'Makanan', isActive: _isFoodSelected,
            onTap: () {
              setState(() { _isFoodSelected = true; _currentPage = 0; if (_pageController.hasClients) _pageController.jumpToPage(0); });
            },
          ),
          const SizedBox(width: 12),
          _buildTabButton(
            title: 'Minuman', isActive: !_isFoodSelected,
            onTap: () {
              setState(() { _isFoodSelected = false; _currentPage = 0; if (_pageController.hasClients) _pageController.jumpToPage(0); });
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
            boxShadow: isActive ? [BoxShadow(color: const Color(0xFFFF9442).withValues(alpha: 0.3), blurRadius: 8, offset: const Offset(0, 4))] : [],
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(color: isActive ? Colors.white : const Color(0xFF64748B), fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
      ),
    );
  }

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
        crossAxisCount: 2, mainAxisSpacing: 16, crossAxisSpacing: 16, childAspectRatio: 0.75,
      ),
      itemCount: filteredList.length,
      itemBuilder: (context, index) { return _buildMenuCard(filteredList[index]); },
    );
  }

  Widget _buildMenuCard(dynamic item) {
    int id = int.tryParse(item['id'].toString()) ?? 0;
    String title = item['title'] ?? 'Nama Menu'; 
    String price = item['price']?.toString() ?? '0'; 
    String imageUrl = item['image_url'] ?? ''; 
    int stock = int.tryParse(item['stock']?.toString() ?? '0') ?? 0;
    
    bool isFav = _favoriteMenuIds.contains(id);
    Widget imageWidget;
    
    if (imageUrl.isNotEmpty) {
      // ✅ DIPERBAIKI: Sintaks Image.network sudah aman
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
        if (stock <= 0) { _showOutOfStockDialog(context); } else { debugPrint("Buka detail menu $title"); }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8, offset: const Offset(0, 4))],
        ),
        foregroundDecoration: stock <= 0 ? BoxDecoration(color: Colors.white.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(20)) : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                    child: Container(width: double.infinity, color: Colors.grey.shade100, child: imageWidget),
                  ),
                  
                  Positioned(
                    top: 8, right: 8,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(id),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.4), shape: BoxShape.circle),
                        child: Icon(
                          isFav ? Icons.favorite : Icons.favorite_border, 
                          color: isFav ? Colors.redAccent : Colors.white, 
                          size: 16
                        ),
                      ),
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
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons.star, color: Color(0xFFFF9442), size: 14), SizedBox(width: 4),
                      Text('4.8', style: TextStyle(color: Color(0xFFFF9442), fontSize: 12, fontWeight: FontWeight.bold)), 
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 14, fontWeight: FontWeight.bold, height: 1.2)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Rp $price", style: const TextStyle(color: Color(0xFFFF9442), fontSize: 14, fontWeight: FontWeight.w800)), 
                      GestureDetector(
                        onTap: () {
                          if (stock > 0) {
                            setState(() { _cartItemCount++; });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$title ditambahkan!', textAlign: TextAlign.center, style: const TextStyle(fontWeight: FontWeight.bold)),
                                duration: const Duration(seconds: 1), backgroundColor: const Color(0xFFFF9442),
                                behavior: SnackBarBehavior.floating, margin: const EdgeInsets.only(bottom: 80, left: 40, right: 40), 
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)), elevation: 0,
                              ),
                            );
                          } else { _showOutOfStockDialog(context); }
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
              Icon(Icons.error_outline, color: Colors.red, size: 48), SizedBox(height: 16),
              Text('Stok tidak tersedia', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)), textAlign: TextAlign.center),
            ],
          ),
          actions: [
            Center(
              child: ElevatedButton(
                onPressed: () { Navigator.of(context).pop(); },
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF9442), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)), minimumSize: const Size(120, 40)),
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
      color: Colors.white, shape: const CircularNotchedRectangle(), notchMargin: 8.0, elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', context.widget is DashboardPage, () {
              if (context.widget is! DashboardPage) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
              }
            }),
            _buildNavItem(Icons.restaurant_menu, 'Menu', true, () {}),
            const SizedBox(width: 48), 
            _buildNavItem(Icons.receipt_long_outlined, 'Order', false, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersPage())); 
            }),
            _buildNavItem(Icons.person_outline, 'Profil', false, () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage())); 
            }),
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
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFFFF9442).withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 2)]),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
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
              child: Text('$_cartItemCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
      ],
    );
  }
}