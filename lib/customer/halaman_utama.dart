import 'package:flutter/material.dart';
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/cart_service.dart';

class HalamanUtama extends StatelessWidget {
  const HalamanUtama({super.key});

  @override
  Widget build(BuildContext context) {
    final baseTheme = Theme.of(context);
    return Theme(
      data: baseTheme.copyWith(
        textTheme: baseTheme.textTheme.apply(fontFamily: 'Plus Jakarta Sans'),
      ),
      child: const Homepage(),
    );
  }
}

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _cartCount = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _customerName = "Customer"; // Untuk menampung nama customer secara dinamis

  @override
  void initState() {
    super.initState();
    _loadCartCount();
    _loadCustomerName(); // Mengambil nama saat pertama kali dibuka
  }

  // 📂 Mengambil nama customer yang tersimpan di SharedPreferences
  Future<void> _loadCustomerName() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('customer_name');
    if (name != null && name.isNotEmpty) {
      if (mounted) {
        setState(() {
          _customerName = name;
        });
      }
    }
  }

  Future<void> _loadCartCount() async {
    final total = await CartService.getCartCount();
    if (!mounted) return;
    setState(() => _cartCount = total);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F7F5),
      // SafeArea biar konten gak nabrak poni kamera / jam di layar atas
      body: SafeArea(
        child: SingleChildScrollView( // Biar layarnya bisa di-scroll ke bawah
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              const SizedBox(height: 24),
              _buildSearchBar(),
              const SizedBox(height: 24),
              _buildPromoBanner(),
              const SizedBox(height: 24),
              _buildCategories(),
              const SizedBox(height: 24),
              const Text(
                'Popular Now',
                style: TextStyle(
                  fontSize: 18, 
                  fontWeight: FontWeight.bold, 
                  color: Color(0xFF0F172A)
                ),
              ),
              const SizedBox(height: 16),
              _buildPopularItems(),
            ],
          ),
        ),
      ),
      // Bikin tombol keranjang melayang di tengah bawah
      floatingActionButton: Stack(
        clipBehavior: Clip.none,
        children: [
          FloatingActionButton(
            backgroundColor: const Color(0xFFFF9442),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            onPressed: () async {
              await Navigator.pushNamed(context, '/cart');
              _loadCartCount();
            },
            child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          ),
          // Bikin angka "3" (badge) di pojok keranjang
          if (_cartCount > 0)
            Positioned(
              right: -2,
              top: -2,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '$_cartCount',
                  style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: buildBottomNavbar(context, '/home_customer'),
    );
  }

  // --- BAGIAN-BAGIAN UI YANG SUDAH DIPISAH BIAR RAPI --- //

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            const CircleAvatar(
              radius: 24,
              backgroundImage: NetworkImage("https://placehold.co/48x48/png"), // Nanti ganti gambar profile asli
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Welcome back,', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
                Text(_customerName, style: const TextStyle(color: Color(0xFF0F172A), fontSize: 18, fontWeight: FontWeight.bold)),
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

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              textInputAction: TextInputAction.search,
              onChanged: (value) => setState(() => _searchQuery = value),
              decoration: const InputDecoration(
                hintText: 'Search for dumplings or drinks...',
                hintStyle: TextStyle(color: Color(0xFF6B7280)),
                border: InputBorder.none,
                isCollapsed: true,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Map<String, String>> _getPopularItems() {
    final items = <Map<String, String>>[
      {
        'title': 'Smoked Beef Dimsum',
        'price': 'Rp 12.000',
        'rating': '4.9 (120+)',
        'imageUrl': 'https://placehold.co/150x112/png',
      },
      {
        'title': 'Lemon Tea',
        'price': 'Rp 10.000',
        'rating': '5.0 (500+)',
        'imageUrl': 'https://placehold.co/150x112/png',
      },
    ];

    final keyword = _searchQuery.trim().toLowerCase();
    if (keyword.isEmpty) return items;

    return items.where((item) {
      final title = item['title']?.toLowerCase() ?? '';
      return title.contains(keyword);
    }).toList();
  }

  Widget _buildPopularItems() {
    final filteredItems = _getPopularItems();

    if (filteredItems.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Text(
            'Menu tidak ditemukan.',
            style: TextStyle(color: Color(0xFF6B7280)),
          ),
        ),
      );
    }

    return Row(
      children: [
        Expanded(
          child: _foodCard(
            filteredItems[0]['title']!,
            filteredItems[0]['price']!,
            filteredItems[0]['rating']!,
            filteredItems[0]['imageUrl']!,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: filteredItems.length > 1
              ? _foodCard(
                  filteredItems[1]['title']!,
                  filteredItems[1]['price']!,
                  filteredItems[1]['rating']!,
                  filteredItems[1]['imageUrl']!,
                )
              : const SizedBox(),
        ),
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
          colors: [Color(0xFF2A2D34), Color(0xFF5E6065)], // Contoh warna gradient hitam/abu
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
        Expanded(child: _categoryButton(Icons.restaurant_menu, 'Food')),
        const SizedBox(width: 16),
        Expanded(child: _categoryButton(Icons.local_drink, 'Beverages')),
      ],
    );
  }

  Widget _categoryButton(IconData icon, String title) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9442).withOpacity(0.1),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color(0xFFFF9442).withOpacity(0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(color: Color(0xFFFF9442), shape: BoxShape.circle),
            child: Icon(icon, color: Colors.white, size: 16),
          ),
          const SizedBox(width: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1E293B))),
        ],
      ),
    );
  }

  // Bikin kerangka kartu makanan biar gak nulis kode berulang-ulang
  Widget _foodCard(String title, String price, String rating, String imageUrl) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(imageUrl, height: 100, width: double.infinity, fit: BoxFit.cover),
              ),
              const Positioned(
                top: 8,
                right: 8,
                child: CircleAvatar(
                  backgroundColor: Colors.white70,
                  radius: 14,
                  child: Icon(Icons.favorite_border, size: 16, color: Colors.black),
                ),
              )
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0F172A))),
          const SizedBox(height: 4),
          Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFFFF9442))),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.amber, size: 14),
              const SizedBox(width: 4),
              Text(rating, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          )
        ],
      ),
    );
  }

}
