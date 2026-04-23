import 'package:flutter/material.dart';

void main() {
  runApp(const MyFavorites());
}

class MyFavorites extends StatelessWidget {
  const MyFavorites({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFCFAEE),
      ),
      home: const MyFavoritesScreen(),
    );
  }
}

class MyFavoritesScreen extends StatefulWidget {
  const MyFavoritesScreen({super.key});

  @override
  State<MyFavoritesScreen> createState() => _MyFavoritesScreenState();
}

class _MyFavoritesScreenState extends State<MyFavoritesScreen> {
  String selectedCategory = 'All Items';
  int selectedNavIndex = 4; // Profile active
  Set<int> favoritedItems = {0, 1, 2};
  Map<int, int> cartItems = {};
  int cartCount = 0;

  final List<String> categories = ['All Items', 'Food', 'Drink', 'Beverages'];

  final List<Map<String, dynamic>> menuItems = [
    {
      'name': 'Mietiaw Mentai',
      'price': 'Rp 32k',
      'priceValue': 32000,
      'description': 'Silky flat rice noodles topped with our\nsignature house-made spicy mentai sauce.',
      'tag': "CHEF'S CHOICE",
      'tagColor': Color(0xFFE0A46B),
      'tagTextColor': Color(0xFF633909),
      'info': '15 min',
      'infoIcon': Icons.access_time_outlined,
      'image': 'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=270&fit=crop',
    },
    {
      'name': 'Es Buah Lecy',
      'price': 'Rp 18k',
      'priceValue': 18000,
      'description': 'Sweet lychee fruit mixed with fresh syrup and\ncooling ice cubes for a sunny day.',
      'tag': null,
      'info': 'Cold',
      'infoIcon': Icons.ac_unit_outlined,
      'image': 'https://images.unsplash.com/photo-1544145945-f90425340c7e?w=400&h=270&fit=crop',
    },
    {
      'name': 'Pangsit Special',
      'price': 'Rp 25k',
      'priceValue': 25000,
      'description': 'Our signature spicy dumplings filled with\nminced chicken and secret aromatic herbs.',
      'tag': 'SPICY LEVEL 5',
      'tagColor': Color(0xFFFFDAD6),
      'tagTextColor': Color(0xFF93000A),
      'info': 'Trending',
      'infoIcon': Icons.local_fire_department_outlined,
      'image': 'https://images.unsplash.com/photo-1496116218417-1a781b1c416c?w=400&h=270&fit=crop',
    },
  ];

  void _toggleFavorite(int index) {
    setState(() {
      if (favoritedItems.contains(index)) {
        favoritedItems.remove(index);
      } else {
        favoritedItems.add(index);
      }
    });
  }

  void _addToCart(int index) {
    setState(() {
      cartItems[index] = (cartItems[index] ?? 0) + 1;
      cartCount = cartItems.values.fold(0, (a, b) => a + b);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${menuItems[index]['name']} ditambahkan ke keranjang'),
        duration: const Duration(seconds: 1),
        backgroundColor: const Color(0xFF954A00),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _placeOrder() {
    if (cartCount == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Keranjang masih kosong!'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Text(
          'Pesanan Dikonfirmasi! 🎉',
          style: TextStyle(
            fontFamily: 'Plus Jakarta Sans',
            fontWeight: FontWeight.w700,
            color: Color(0xFF1B1C15),
          ),
        ),
        content: Text(
          'Pesanan $cartCount item berhasil diproses. Silakan tunggu.',
          style: const TextStyle(
            fontFamily: 'Be Vietnam Pro',
            color: Color(0xFF554337),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              setState(() {
                cartItems.clear();
                cartCount = 0;
              });
            },
            child: const Text(
              'OK',
              style: TextStyle(
                color: Color(0xFFFF9442),
                fontWeight: FontWeight.w700,
                fontFamily: 'Plus Jakarta Sans',
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, dynamic>> get filteredItems {
    if (selectedCategory == 'All Items') return menuItems;
    if (selectedCategory == 'Food') return [menuItems[0], menuItems[2]];
    if (selectedCategory == 'Drink') return [menuItems[1]];
    if (selectedCategory == 'Beverages') return [menuItems[1]];
    return menuItems;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      body: Column(
        children: [
          // Top Navigation Bar
          Container(
            color: const Color(0xFFFCFAEE),
            padding: const EdgeInsets.only(top: 44, left: 16, right: 16, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF1B1C15),
                      size: 24,
                    ),
                  ),
                ),
                const Text(
                  'Favorites',
                  style: TextStyle(
                    color: Color(0xFF954A00),
                    fontSize: 18,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: const Padding(
                        padding: EdgeInsets.all(8),
                        child: Icon(Icons.search, color: Color(0xFF1B1C15), size: 24),
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        width: 32,
                        height: 32,
                        clipBehavior: Clip.antiAlias,
                        decoration: const ShapeDecoration(
                          color: Color(0xFFFFCF9A),
                          shape: CircleBorder(),
                        ),
                        child: ClipOval(
                          child: Image.network(
                            'https://i.pravatar.cc/32',
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => const Icon(Icons.person, size: 20, color: Color(0xFF954A00)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Main Content
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),
                    // Title
                    RichText(
                      text: const TextSpan(
                        children: [
                          TextSpan(
                            text: 'Your Curated\n',
                            style: TextStyle(
                              color: Color(0xFF1B1C15),
                              fontSize: 36,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                              letterSpacing: -0.90,
                            ),
                          ),
                          TextSpan(
                            text: 'Best Bites',
                            style: TextStyle(
                              color: Color(0xFF954A00),
                              fontSize: 36,
                              fontFamily: 'Plus Jakarta Sans',
                              fontWeight: FontWeight.w800,
                              height: 1.25,
                              letterSpacing: -0.90,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Handpicked flavors from your kitchen to\nyour heart. Ready to order again?',
                      style: TextStyle(
                        color: Color(0xFF554337),
                        fontSize: 18,
                        fontFamily: 'Be Vietnam Pro',
                        fontWeight: FontWeight.w400,
                        height: 1.56,
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Category Filter
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: categories.map((category) {
                          final isSelected = selectedCategory == category;
                          return GestureDetector(
                            onTap: () => setState(() => selectedCategory = category),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.only(right: 10),
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                              decoration: ShapeDecoration(
                                color: isSelected ? const Color(0xFFFF9442) : const Color(0xFFF6F4E8),
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                category,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : const Color(0xFF554337),
                                  fontSize: 14,
                                  fontFamily: 'Plus Jakarta Sans',
                                  fontWeight: FontWeight.w600,
                                  height: 1.43,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Menu Items
                    ...filteredItems.asMap().entries.map((entry) {
                      final idx = menuItems.indexOf(entry.value);
                      return _buildMenuCard(entry.value, idx);
                    }),

                    const SizedBox(height: 16),

                    // Checkout Banner
                    _buildCheckoutBanner(),
                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ),

          // Bottom Navigation Bar
          _buildBottomNavBar(),
        ],
      ),
    );
  }

  Widget _buildMenuCard(Map<String, dynamic> item, int index) {
    final isFavorited = favoritedItems.contains(index);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image
          Stack(
            children: [
              SizedBox(
                width: double.infinity,
                height: 268,
                child: Image.network(
                  item['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    height: 268,
                    color: const Color(0xFFE0D5C5),
                    child: const Icon(Icons.restaurant, size: 64, color: Color(0xFF954A00)),
                  ),
                ),
              ),
              // Favorite button
              Positioned(
                right: 12,
                top: 16,
                child: GestureDetector(
                  onTap: () => _toggleFavorite(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    width: 40,
                    height: 40,
                    decoration: ShapeDecoration(
                      color: const Color(0xE5FCFAEE),
                      shape: const CircleBorder(),
                      shadows: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Icon(
                      isFavorited ? Icons.favorite : Icons.favorite_border,
                      color: isFavorited ? const Color(0xFFEF4444) : const Color(0xFF554337),
                      size: 20,
                    ),
                  ),
                ),
              ),
              // Tag badge
              if (item['tag'] != null)
                Positioned(
                  left: 12,
                  bottom: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: ShapeDecoration(
                      color: item['tagColor'],
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      item['tag'],
                      style: TextStyle(
                        color: item['tagTextColor'],
                        fontSize: 10,
                        fontFamily: 'Be Vietnam Pro',
                        fontWeight: FontWeight.w700,
                        height: 1.50,
                        letterSpacing: 0.52,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name'],
                      style: const TextStyle(
                        color: Color(0xFF1B1C15),
                        fontSize: 20,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w700,
                        height: 1.40,
                      ),
                    ),
                    Text(
                      item['price'],
                      style: const TextStyle(
                        color: Color(0xFFFF9442),
                        fontSize: 16,
                        fontFamily: 'Plus Jakarta Sans',
                        fontWeight: FontWeight.w800,
                        height: 1.50,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  item['description'],
                  style: const TextStyle(
                    color: Color(0xFF554337),
                    fontSize: 14,
                    fontFamily: 'Be Vietnam Pro',
                    fontWeight: FontWeight.w400,
                    height: 1.43,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Icon(
                          item['infoIcon'],
                          size: 16,
                          color: const Color(0xFF554337),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item['info'],
                          style: const TextStyle(
                            color: Color(0xFF554337),
                            fontSize: 12,
                            fontFamily: 'Be Vietnam Pro',
                            fontWeight: FontWeight.w500,
                            height: 1.33,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => _addToCart(index),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        width: 48,
                        height: 48,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFF9442),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          shadows: [
                            BoxShadow(
                              color: const Color(0xFFFF9442).withOpacity(0.4),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.add, color: Colors.white, size: 24),
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
      padding: const EdgeInsets.all(32),
      decoration: ShapeDecoration(
        color: const Color(0x4CFFCF9A),
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0x26DBC1B2)),
          borderRadius: BorderRadius.circular(32),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const ShapeDecoration(
                  color: Colors.white,
                  shape: CircleBorder(),
                  shadows: [
                    BoxShadow(
                      color: Color(0x0C000000),
                      blurRadius: 2,
                      offset: Offset(0, 1),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.shopping_basket_outlined,
                  color: Color(0xFF954A00),
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Ready to checkout?',
                    style: TextStyle(
                      color: Color(0xFF7A562B),
                      fontSize: 20,
                      fontFamily: 'Plus Jakarta Sans',
                      fontWeight: FontWeight.w700,
                      height: 1.40,
                    ),
                  ),
                  Text(
                    '$cartCount item${cartCount == 1 ? '' : 's'} in your quick\nbasket.',
                    style: const TextStyle(
                      color: Color(0xB27A562B),
                      fontSize: 16,
                      fontFamily: 'Be Vietnam Pro',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: _placeOrder,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: ShapeDecoration(
                color: const Color(0xFFFF9442),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0xFF954A00).withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                    spreadRadius: -3,
                  ),
                ],
              ),
              child: const Text(
                'Place Order Now',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Plus Jakarta Sans',
                  fontWeight: FontWeight.w700,
                  height: 1.56,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    final navItems = [
      {'icon': Icons.home_outlined, 'activeIcon': Icons.home, 'label': 'Home'},
      {'icon': Icons.restaurant_menu_outlined, 'activeIcon': Icons.restaurant_menu, 'label': 'Menu'},
      {'icon': Icons.shopping_cart_outlined, 'activeIcon': Icons.shopping_cart, 'label': 'Cart', 'isCenter': true},
      {'icon': Icons.receipt_long_outlined, 'activeIcon': Icons.receipt_long, 'label': 'Orders'},
      {'icon': Icons.person_outline, 'activeIcon': Icons.person, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.95),
        border: const Border(
          top: BorderSide(width: 1, color: Color(0xFFFF9442)),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: navItems.asMap().entries.map((entry) {
          final i = entry.key;
          final item = entry.value;
          final isCenter = item['isCenter'] == true;
          final isActive = selectedNavIndex == i;

          if (isCenter) {
            return GestureDetector(
              onTap: () => setState(() => selectedNavIndex = i),
              child: SizedBox(
                width: 56,
                height: 56,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Positioned(
                      top: -24,
                      left: 0,
                      child: Container(
                        width: 56,
                        height: 56,
                        decoration: ShapeDecoration(
                          color: const Color(0xFFFF9442),
                          shape: RoundedRectangleBorder(
                            side: const BorderSide(width: 4, color: Color(0xFFF8F7F5)),
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          shadows: const [
                            BoxShadow(
                              color: Color(0x66FF9442),
                              blurRadius: 15,
                              offset: Offset(0, 6),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.shopping_cart, color: Colors.white, size: 26),
                      ),
                    ),
                    if (cartCount > 0)
                      Positioned(
                        top: -24,
                        right: -4,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFEF4444),
                            shape: RoundedRectangleBorder(
                              side: const BorderSide(width: 2, color: Colors.white),
                              borderRadius: BorderRadius.circular(9999),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '$cartCount',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontFamily: 'Plus Jakarta Sans',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            );
          }

          return GestureDetector(
            onTap: () => setState(() => selectedNavIndex = i),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isActive ? item['activeIcon'] as IconData : item['icon'] as IconData,
                  color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8),
                  size: 22,
                ),
                const SizedBox(height: 4),
                Text(
                  item['label'] as String,
                  style: TextStyle(
                    color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8),
                    fontSize: 10,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}