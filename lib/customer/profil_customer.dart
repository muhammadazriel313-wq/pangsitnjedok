import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; 
import 'package:aplikasipangsitnjedok/core/network/api_services.dart'; // Sesuaikan jika path-nya beda

// Import semua halaman navigasi
import 'edit_profil_customer.dart';
import 'package:aplikasipangsitnjedok/customer/order.dart'; 
import 'dashboard_menu.dart';
import 'halaman_menu.dart';
import 'cart.dart';
import 'my_favorites.dart'; 
import 'rating_views.dart'; // ✅ Import halaman Rating & Review

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Loading...";
  String phone = "...";
  bool isLoading = true;
  String? profileImageUrl; 

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('id') ?? "1"; 
      var response = await ApiService.getProfile(userId); 
      
      if (mounted) {
        setState(() {
          if (response['status'] == 'success') {
            name = response['data']['name'];
            phone = response['data']['no_telepon'];
            profileImageUrl = response['data']['foto_profil']; 
          } else {
            name = "User Tidak Ditemukan";
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          name = "Error Koneksi";
          isLoading = false;
        });
      }
    }
  }

  Future<void> _navigateToEditAccount() async {
    bool? isUpdated = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const EditAccountPage()),
    );
    // Refresh data jika kembali dari halaman edit dan ada perubahan
    if (isUpdated == true) _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF954A00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Profile', style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.w600, fontSize: 18)),
            Text('Pangsit Njedog', style: TextStyle(color: Color(0xFF562F00), fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442))) 
          : RefreshIndicator(
              onRefresh: _loadData,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  children: [
                    const SizedBox(height: 32),
                    _buildProfileHeader(name, phone),
                    const SizedBox(height: 40),
                    
                    // DAFTAR MENU PROFIL
                    _buildMenuItem(Icons.person_outline, 'Edit Account', 'Update your details', onTap: _navigateToEditAccount),
                    
                    _buildMenuItem(Icons.assignment_outlined, 'My Orders', 'Track your pangsit', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MyOrdersPage()))),
                    
                    _buildMenuItem(Icons.favorite_outline, 'My Favorites', 'Your loved items', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const FavoritePage()))),
                    
                    _buildMenuItem(Icons.star_outline, 'Rating & Reviews', 'Rate Us', onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const RatingViewsPage()))),
                    
                    const SizedBox(height: 20),
                    
                    // TOMBOL LOGOUT
                    _buildLogoutButton(),
                    
                    const SizedBox(height: 100), // Jarak ke bottom nav
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildProfileHeader(String userName, String userPhone) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none, 
          children: [
            Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle, 
                border: Border.all(color: const Color(0xFFFF9644), width: 3),
                image: DecorationImage(
                  image: profileImageUrl != null && profileImageUrl!.isNotEmpty
                      ? NetworkImage(profileImageUrl!) as ImageProvider
                      : const AssetImage('assets/images/nipis.jpeg'),
                  fit: BoxFit.cover,
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
              ),
            ),
            Positioned(
              bottom: 5, right: 5, 
              child: GestureDetector(
                onTap: _navigateToEditAccount,
                child: const CircleAvatar(
                  radius: 18, backgroundColor: Colors.orange,
                  child: Icon(Icons.edit, size: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16), 
        Text(userName, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        Text(userPhone, style: const TextStyle(color: Color(0xFF554337))),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, String subtitle, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16), padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: const Color(0x33FF9644), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: const Color(0xFFFF9644)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, 
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)), 
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ]
              )
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () async {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            title: const Text('Konfirmasi Log Out', style: TextStyle(fontWeight: FontWeight.bold)),
            content: const Text('Apakah Anda yakin ingin Logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Batal', style: TextStyle(color: Colors.grey)),
              ),
              TextButton(
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear(); 
                  
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                },
                child: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        );
      },
      child: Container(
        width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFFFF9644), borderRadius: BorderRadius.circular(24)),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.logout, color: Colors.white), SizedBox(width: 12), Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16))]),
      ),
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
            _buildNavItem(Icons.home_outlined, 'Home', context.widget is DashboardPage, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage()))),
            _buildNavItem(Icons.restaurant_menu, 'Menu', context.widget is MenuFoodScreen, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MenuFoodScreen()))),
            const SizedBox(width: 48), 
            _buildNavItem(Icons.receipt_long_outlined, 'Order', context.widget is MyOrdersPage, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyOrdersPage()))),
            _buildNavItem(Icons.person, 'Profil', true, () {}), // Profil selalu aktif di halaman ini
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
        child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8)), const SizedBox(height: 4), Text(label, style: TextStyle(color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8), fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.w500))]),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFFFF9442).withOpacity(0.4), blurRadius: 12, spreadRadius: 2)]),
      child: FloatingActionButton(
        onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartPage())),
        backgroundColor: const Color(0xFFFF9442), elevation: 0, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(color: Colors.white, width: 4)),
        child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
      ),
    );
  }
}