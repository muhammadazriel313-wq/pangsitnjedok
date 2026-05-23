import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart'; 
import '../service/cart_service.dart'; // ✅ Ditambahkan: Mengimpor CartService
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
import 'cart.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  String selectedCategory = 'All Items';
  String userId = ""; 
  int cartCount = 0; // ✅ Cukup pakai cartCount, menghapus Map lokal
  bool _isLoading = true;
  String? profileImageUrl; 

  final List<String> categories = ['All Items', 'Food', 'Beverages'];
  List<Map<String, dynamic>> menuItems = [];

  @override
  void initState() {
    super.initState();
    _fetchFavorites();
    _loadUserProfile();
    _updateCartCount(); // ✅ Sinkronisasi jumlah keranjang saat halaman dibuka
  }

  Future<void> _updateCartCount() async {
    int count = await CartService.getCartCount();
    if (mounted) {
      setState(() {
        cartCount = count;
      });
    }
  }

  Future<void> _loadUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('id') ?? prefs.getString('customer_id') ?? "1"; 
    var response = await ApiService.getProfile(userId);
    if (response['status'] == 'success' && mounted) {
      setState(() {
        profileImageUrl = response['data']['foto_profil'];
      });
    }
  }

  Future<void> _fetchFavorites() async {
    setState(() => _isLoading = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('id') ?? prefs.getString('customer_id') ?? "1"; 

      List<dynamic> rawData = await ApiService.getFavorites(int.parse(userId));
      
      if (mounted) {
        setState(() {
          menuItems = rawData.map((item) => {
                'id': int.parse(item['id'].toString()),
                'name': item['title'],
                'price': 'Rp ${item['price']}',
                'description': 'Delicious favorite choices from our kitchen.',
                'tag': (item['is_best_seller'] == 1 || item['is_best_seller'] == '1' || item['is_best_seller'] == true) ? 'BEST SELLER' : null,
                'tagColor': const Color(0xFFFFCF9A),
                'tagTextColor': const Color(0xFF954A00),
                'info': item['category'] ?? 'Food',
                'infoIcon': item['category']?.toString().toLowerCase() == 'drink' || item['category']?.toString().toLowerCase() == 'beverage' ? Icons.local_cafe_outlined : Icons.restaurant_outlined,
                'image': item['image'] ?? item['image_url'] ?? '',
              }).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching favorites: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _toggleFavorite(int menuId) async {
    setState(() {
      menuItems.removeWhere((item) => item['id'] == menuId);
    });

    bool success = await ApiService.toggleFavorite(userId, menuId.toString(), "remove");
    
    if (!success) {
      _fetchFavorites(); 
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Failed to remove favorite!'), backgroundColor: Colors.red));
      }
    } 
  }

  // ✅ DIPERBAIKI: Langsung mengirim item (untuk mencegah error salah pencet saat di-filter)
  void _addToCart(Map<String, dynamic> item) async {
    // Harga saat ini berbentuk 'Rp 15000', kita perlu mengekstrak angkanya saja
    String priceString = item['price'].toString().replaceAll(RegExp(r'[^0-9]'), '');
    int priceValue = int.tryParse(priceString) ?? 0;

    // Simpan ke SharedPreferences secara permanen menggunakan CartService
    await CartService.addToCart(item['name'], priceValue, item['info']);
    
    // Perbarui total angka merah di tombol melayang (FAB)
    await _updateCartCount();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${item['name']} added to cart!'),
          backgroundColor: const Color(0xFF954A00),
          duration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  void _placeOrder() {
    if (cartCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart is still empty!'), backgroundColor: Colors.red));
      return;
    }
    // ✅ Mengupdate jumlah cart jika pengguna kembali dari halaman Cart
    Navigator.push(context, MaterialPageRoute(builder: (context) => const CartPage())).then((_) {
      _updateCartCount();
    });
  }

  List<Map<String, dynamic>> get filteredItems {
    if (selectedCategory == 'All Items') return menuItems;
    if (selectedCategory == 'Food') {
      return menuItems.where((item) {
        String info = item['info'].toString().toLowerCase();
        return info == 'food' || info == 'makanan';
      }).toList();
    }
    if (selectedCategory == 'Beverages') {
      return menuItems.where((item) {
        String info = item['info'].toString().toLowerCase();
        return info == 'drink' || info == 'beverage' || info == 'beverages' || info == 'minuman';
      }).toList();
    }
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
      bottomNavigationBar: buildBottomNavbar(context, '/my_favorites'),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 50, left: 16, right: 16, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, 
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context), 
                      child: const Icon(Icons.arrow_back, color: Color(0xFF1B1C15), size: 24),
                    ),
                    const SizedBox(width: 12), 
                    const Text('Favorites', style: TextStyle(color: Color(0xFF954A00), fontSize: 18, fontWeight: FontWeight.w700)),
                  ],
                ),
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.grey.shade300,
                      backgroundImage: profileImageUrl != null && profileImageUrl!.isNotEmpty && profileImageUrl!.startsWith('http')
                          ? NetworkImage(profileImageUrl!) as ImageProvider
                          : const AssetImage('assets/images/nipis.jpeg'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          Expanded(
            child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442)))
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 16),
                          RichText(
                            text: const TextSpan(
                              children: [
                                TextSpan(text: 'Your Curated\n', style: TextStyle(color: Color(0xFF1B1C15), fontSize: 32, fontWeight: FontWeight.w800, height: 1.2)),
                                TextSpan(text: 'Best Bites', style: TextStyle(color: Color(0xFF954A00), fontSize: 32, fontWeight: FontWeight.w800, height: 1.2)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Handpicked flavors from your kitchen to\nyour heart. Ready to order again?',
                            style: TextStyle(color: Color(0xFF554337), fontSize: 16, fontWeight: FontWeight.w400, height: 1.5),
                          ),
                          const SizedBox(height: 24),

                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: categories.map((category) {
                                final isSelected = selectedCategory == category;
                                return GestureDetector(
                                  onTap: () => setState(() => selectedCategory = category),
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 200),
                                    margin: const EdgeInsets.only(right: 12),
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                                    decoration: ShapeDecoration(
                                      color: isSelected ? const Color(0xFFFF9442) : const Color(0xFFF6F4E8),
                                      shape: const StadiumBorder(),
                                    ),
                                    child: Text(
                                      category,
                                      style: TextStyle(
                                        color: isSelected ? Colors.white : const Color(0xFF554337),
                                        fontSize: 14, fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 24),

                          if (filteredItems.isEmpty)
                            const Padding(
                              padding: EdgeInsets.only(top: 40, bottom: 40),
                              child: Center(child: Text("No favorite menu in this category yet.", style: TextStyle(color: Color(0xFF94A3B8), fontSize: 16))),
                            )
                          else
                            // ✅ Passing data menu seutuhnya
                            ...filteredItems.map((item) => _buildMenuCard(item)),
                          
                          if (cartCount > 0) ...[
                            const SizedBox(height: 16),
                            _buildCheckoutBanner(),
                          ],

                          const SizedBox(height: 40), 
                        ],
                      ),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  // ✅ Hapus indeks, gunakan Map item
  Widget _buildMenuCard(Map<String, dynamic> item) {
    Widget imageWidget;
    String imgPath = item['image'] ?? '';

    if (imgPath.startsWith('http')) {
      imageWidget = Image.network(imgPath, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.restaurant, size: 64, color: Color(0xFF954A00)));
    } else if (imgPath.isNotEmpty) {
      imageWidget = Image.network("${ApiService.baseUrl}/uploads/$imgPath", fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.restaurant, size: 64, color: Color(0xFF954A00)));
    } else {
      imageWidget = const Icon(Icons.image_not_supported, size: 64, color: Color(0xFF954A00));
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              SizedBox(width: double.infinity, height: 220, child: imageWidget),
              Positioned(
                right: 16, top: 16,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(item['id']), 
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                    child: const Icon(Icons.favorite, color: Color(0xFFEF4444), size: 20),
                  ),
                ),
              ),
              if (item['tag'] != null)
                Positioned(
                  left: 16, bottom: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(color: item['tagColor'], borderRadius: BorderRadius.circular(20)),
                    child: Text(item['tag'], style: TextStyle(color: item['tagTextColor'], fontSize: 10, fontWeight: FontWeight.w800)),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['name'], style: const TextStyle(color: Color(0xFF1B1C15), fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(item['price'], style: const TextStyle(color: Color(0xFFFF9442), fontSize: 16, fontWeight: FontWeight.w800)),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item['description'], style: const TextStyle(color: Color(0xFF554337), fontSize: 13, height: 1.4)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(item['infoIcon'], size: 16, color: const Color(0xFF94A3B8)),
                        const SizedBox(width: 6),
                        Text(item['info'], style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    GestureDetector(
                      // ✅ Dipanggil langsung dengan membawa data item
                      onTap: () => _addToCart(item),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFF9442),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 20),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7ED),
        border: Border.all(color: const Color(0xFFFFEDD5)),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF954A00), size: 28),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Ready to checkout?', style: TextStyle(color: Color(0xFF7A562B), fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text('$cartCount items in your quick\nbasket.', style: const TextStyle(color: Color(0xFF954A00), fontSize: 14)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: _placeOrder,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9442),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: const Color(0xFFFF9442).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
              ),
              child: const Text('Place Order Now', textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFFFF9442).withValues(alpha: 0.4), blurRadius: 12, spreadRadius: 2)]),
      child: FloatingActionButton(
        onPressed: _placeOrder,
        backgroundColor: const Color(0xFFFF9442), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(color: Colors.white, width: 4)),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            if (cartCount > 0)
              Positioned(
                right: -4, top: -4,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                  child: Text('$cartCount', style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              )
          ],
        ),
      ),
    );
  }
}