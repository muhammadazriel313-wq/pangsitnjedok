import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';


import '../service/api_service.dart';
import 'cart.dart';
import 'order.dart';

import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import 'my_favorites.dart';
import 'detail_menu.dart';
import '../service/cart_service.dart'; // ✅ Import CartService
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool _isFoodSelected = true;

  // --- VARIABEL PROFIL DINAMIS ---
  String _userId = "1";
  String _customerName = "Customer";
  String _customerPhoto = "";

  // --- VARIABEL API & FAVORIT ---
  List<dynamic> _allMenus = [];
  Set<int> _favoriteMenuIds = {};
  bool _isLoading = true;

  // --- VARIABEL SLIDER & KERANJANG ---
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _carouselTimer;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _loadUserProfile();
    _updateCartCount();

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

  Future<void> _updateCartCount() async {
    int count = await CartService.getCartCount();
    if (mounted) {
      setState(() {
        _cartItemCount = count;
      });
    }
  }

  // ✅ BACA PROFIL SEKALIGUS TARIK DATA MENU & FAVORIT
  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _userId = prefs.getString('id') ?? prefs.getString('customer_id') ?? "1";

    setState(() {
      _customerName = prefs.getString('name') ?? "Customer";
      _customerPhoto = prefs.getString('photo') ?? "";
    });

    try {
      var response = await ApiService.getProfile(_userId);
      if (response['status'] == 'success') {
        if (mounted) {
          setState(() {
            _customerName = response['data']['name'] ?? _customerName;
            _customerPhoto = response['data']['foto_profil'] ?? _customerPhoto;
          });
        }
      }
    } catch (e) {
      // debugPrint("Error loading profile: $e");
    }

    _fetchDashboardData();
  }

  Future<void> _fetchDashboardData() async {
    try {
      final menus = await ApiService.getMenus();

      // ✅ DIPERBAIKI: Menggunakan int.parse agar tidak error merah!
      final favs = await ApiService.getFavorites(int.parse(_userId));
      Set<int> favIds = favs
          .map<int>((f) => int.parse(f['id'].toString()))
          .toSet();

      setState(() {
        _allMenus = menus;
        _favoriteMenuIds = favIds;
        _isLoading = false;
      });
    } catch (e) {
      // debugPrint("Error Dashboard: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  // ✅ LOGIKA KLIK ICON LOVE
  void _toggleFavorite(int menuId) async {
    bool isCurrentlyFav = _favoriteMenuIds.contains(menuId);
    String action = isCurrentlyFav ? "remove" : "add";

    // Optimistic UI: Langsung ubah warna seketika
    setState(() {
      if (isCurrentlyFav) {
        _favoriteMenuIds.remove(menuId);
      } else {
        _favoriteMenuIds.add(menuId);
      }
    });

    try {
      // Pastikan fungsi toggleFavorite sudah ada di api_service.dart kamu!
      bool success = await ApiService.toggleFavorite(
        _userId,
        menuId.toString(),
        action,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                isCurrentlyFav
                    ? 'Removed from Favorites'
                    : 'Added to Favorites',
                textAlign: TextAlign.center,
              ),
              backgroundColor: isCurrentlyFav ? Colors.red : Colors.green,
              duration: const Duration(seconds: 1),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          );
        } else {
          // Kalau gagal ke database, batalkan perubahan warna
          setState(() {
            if (isCurrentlyFav) {
              _favoriteMenuIds.add(menuId);
            } else {
              _favoriteMenuIds.remove(menuId);
            }
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to update favorites')),
          );
        }
      }
    } catch (e) {
      // debugPrint("Toggle Favorite Error: $e");
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFDF1), Color(0xFFFFE8D6)],
          ),
        ),
        child: SafeArea(
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
                  'Recommendations',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 16),
                _buildPopularItems(),
              ],
            ),
          ),
        ),
        ),
      ),
      floatingActionButton: _buildFab(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomNavbar(context, '/home_customer'),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            // ✅ LOGIKA FOTO PROFIL FIX (Menghindari Putih Polos)
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF9442), width: 2),
                boxShadow: [
                  BoxShadow(color: const Color(0xFFFF9442).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                ],
              ),
              child: ClipOval(
                child: _customerPhoto.isNotEmpty
                    ? Image.network(
                        _customerPhoto.startsWith('http') ? _customerPhoto : "${ApiService.baseUrl}/uploads/$_customerPhoto",
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset("assets/images/user.jpeg", fit: BoxFit.cover),
                      )
                    : Image.asset("assets/images/user.jpeg", fit: BoxFit.cover),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome,',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 12),
                ),
                Text(
                  _customerName, // ✅ NAMA SESUAI USER LOGIN
                  style: const TextStyle(
                    color: Color(0xFF0F172A),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const FavoritePage()),
            );
          },
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: const Icon(Icons.favorite, color: Colors.redAccent),
          ),
        ),
      ],
    );
  }

  Widget _buildPromoBanner() {
    List<String> bannerImages = _isFoodSelected
        ? ['assets/images/fotoslide2.jpg', 'assets/images/fotoslide3.jpg']
        : ['assets/images/minumslide1.jpg', 'assets/images/minumslide2.jpg'];

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(26), // 0.1 * 255 ≈ 26
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: bannerImages.length,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                return Image.asset(
                  bannerImages[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                );
              },
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withAlpha(204),
                    Colors.transparent,
                  ], // 0.8 * 255 ≈ 204
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9442),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'SPECIAL OFFER',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    _isFoodSelected ? 'Newest Flavors' : 'Ultimate Freshness',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _isFoodSelected
                        ? 'Perfectly spicy, purely satisfying!'
                        : 'Perfectly fresh, purely satisfying!',
                    style: const TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyOrdersPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF0F172A),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 10,
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Order Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
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
          child: _categoryButton(
            Icons.restaurant_menu,
            'Food',
            _isFoodSelected,
            () {
              setState(() {
                _isFoodSelected = true;
                _currentPage = 0;
                if (_pageController.hasClients) _pageController.jumpToPage(0);
              });
            },
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _categoryButton(
            Icons.local_bar_outlined,
            'Beverages',
            !_isFoodSelected,
            () {
              setState(() {
                _isFoodSelected = false;
                _currentPage = 0;
                if (_pageController.hasClients) _pageController.jumpToPage(0);
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _categoryButton(
    IconData icon,
    String title,
    bool active,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: active ? const Color(0xFFFFF4EC) : Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: active ? const Color(0xFFFFCE99) : const Color(0xFFE2E8F0),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: active
                    ? const Color(0xFFFF9442)
                    : const Color(0xFFF1F5F9),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: active ? Colors.white : Colors.grey,
                size: 18,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: active
                    ? const Color(0xFF0F172A)
                    : const Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItems() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF9442)),
      );
    }

    final filtered = _allMenus.where((item) {
      String cat = item['category']?.toString().toLowerCase() ?? 'food';
      return _isFoodSelected
          ? cat == 'food'
          : (cat == 'drink' || cat == 'beverages');
    }).toList();

    if (filtered.isEmpty) {
      return const Center(
        child: Text(
          "No recommendations yet.",
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    final displayItems = filtered.take(4).toList();

    return AnimationLimiter(
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75, // Menyeimbangkan bentuk kotak
        ),
        itemCount: displayItems.length,
        itemBuilder: (context, index) {
          return AnimationConfiguration.staggeredGrid(
            position: index,
            duration: const Duration(milliseconds: 375),
            columnCount: 2,
            child: ScaleAnimation(
              child: FadeInAnimation(
                child: _foodCard(displayItems[index]),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _foodCard(dynamic item) {
    int menuId = int.tryParse(item['id']?.toString() ?? '0') ?? 0;
    String title = item['title'] ?? 'Menu';
    String price = item['price']?.toString() ?? '0';
    String img = item['image_url'] ?? '';
    int stock = int.tryParse(item['stock']?.toString() ?? '0') ?? 0;

    // Cek apakah menu ini dilove oleh user
    bool isLiked = _favoriteMenuIds.contains(menuId);

    return GestureDetector(
      onTap: () {
        if (stock <= 0) {
          _showOutOfStockDialog(context);
        } else {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DetailMenuPage(item: item),
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        foregroundDecoration: stock <= 0
            ? BoxDecoration(
                color: Colors.white.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(24),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ✅ DIPERBAIKI: Menggunakan Expanded supaya gambar mengisi ruang kosong & teks tetap padat di bawah
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    child: Hero(
                      tag: 'menu_image_$menuId',
                      child: img.isNotEmpty
                          ? Image.network(
                              "${ApiService.baseUrl}/uploads/$img",
                              fit: BoxFit.cover,
                              errorBuilder: (c, e, s) =>
                                  const Icon(Icons.fastfood, size: 50),
                            )
                          : const Center(
                              child: Icon(
                                Icons.image_not_supported,
                                size: 50,
                                color: Colors.grey,
                              ),
                            ),
                    ),
                  ),
                  // ✅ LOGIKA KLIK ICON LOVE
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () => _toggleFavorite(menuId),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
                          child: Icon(
                            isLiked ? Icons.favorite : Icons.favorite_border,
                            key: ValueKey<bool>(isLiked),
                            size: 18,
                            color: isLiked ? Colors.red : const Color(0xFF64748B),
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (stock <= 0)
                    Positioned(
                      bottom: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'SOLD OUT',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            // ✅ BAGIAN TEKS DAN HARGA JADI RAPAT
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize
                    .min, // Membungkus konten teks seminimal mungkin
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Color(0xFF0F172A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Rp $price",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          color: Color(0xFFFF9442),
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          if (stock > 0) {
                            String priceString = price.toString().replaceAll(RegExp(r'[^0-9]'), '');
                            int priceValue = int.tryParse(priceString) ?? 0;
                            String category = item['category']?.toString() ?? 'Food';
                            
                            await CartService.addToCart(title, priceValue, category);
                            await _updateCartCount();

                            if (!mounted) return;
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  '$title added to cart!',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                duration: const Duration(seconds: 1),
                                backgroundColor: const Color(0xFFFF9442),
                                behavior: SnackBarBehavior.floating,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                            );
                          } else {
                            _showOutOfStockDialog(context);
                          }
                        },
                        child: Icon(
                          Icons.add_circle,
                          color: stock <= 0
                              ? Colors.grey
                              : const Color(0xFFFF9442),
                          size: 28,
                        ),
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.error_outline, color: Colors.red, size: 48),
              SizedBox(height: 16),
              Text(
                'Out of Stock',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0F172A),
                ),
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
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: const Size(120, 40),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        );
      },
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
                color: const Color(0xFFFF9442).withValues(alpha: 0.4),
                blurRadius: 12,
                spreadRadius: 2,
              ),
            ],
          ),
          child: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const CartPage()),
              );
            },
            backgroundColor: const Color(0xFFFF9442),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
              side: const BorderSide(color: Colors.white, width: 4),
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              color: Colors.white,
            ),
          ),
        ),
        if (_cartItemCount > 0)
          Positioned(
            right: -2,
            top: -2,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFEF4444),
                shape: BoxShape.circle,
              ),
              child: Text(
                '$_cartItemCount',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
