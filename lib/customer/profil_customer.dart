import 'package:flutter/material.dart';
import 'edit_profil_customer.dart';
import 'order.dart';
import 'my_favorites.dart';
import 'rating_views.dart';
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
import '../service/api_service.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "Loading...";
  String phone = "...";
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var response = await ApiService.getProfile("1"); 

      if (mounted) {
        setState(() {
          if (response['status'] == 'success') {
            name = response['data']['name'];
            phone = response['data']['no_telepon'];
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF954A00)),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/home_customer');
            }
          },
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
          ? const Center(child: CircularProgressIndicator()) 
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
                    
                    // MENU EDIT ACCOUNT
                    _buildMenuItem(
                      Icons.person_outline, 
                      'Edit Account', 
                      'Update your details', 
                      onTap: () async {
                        bool? isUpdated = await Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const EditAccountPage()),
                        );
                        if (isUpdated == true) _loadData();
                      }
                    ),
                    
                    // MENU MY ORDERS (Sekarang memanggil MyOrdersPage agar import terbaca)
                    _buildMenuItem(
                      Icons.assignment_outlined, 
                      'My Orders', 
                      'Track your pangsit',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyOrdersPage()),
                        );
                      }
                    ),
                    
                    _buildMenuItem(
                      Icons.favorite_outline,
                      'My Favorites',
                      'Your loved items',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const MyFavoritesScreen()),
                        );
                      },
                    ),
                    _buildMenuItem(
                      Icons.star_outline,
                      'Rating & Reviews',
                      'Rate Us',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const RatingViewsPage()),
                        );
                      },
                    ),

                    const SizedBox(height: 20),
                    _buildLogoutButton(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF9442),
        shape: const CircleBorder(),
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
      ),
      bottomNavigationBar: buildBottomNavbar(context, '/profil_customer'),
    );
  }

  Widget _buildProfileHeader(String userName, String userPhone) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(
                    image: AssetImage('assets/images/nipis.jpeg'), 
                    fit: BoxFit.cover
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
              ),
            ),
            Positioned(
              bottom: 0, 
              right: 0, 
              child: CircleAvatar(
                radius: 18,
                backgroundColor: Colors.orange,
                child: Icon(Icons.edit, size: 18, color: Colors.white),
              )
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
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0x33FF9644), borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: const Color(0xFFFF9644)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
      },
      child: Container(
        width: double.infinity, 
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(color: const Color(0xFFFF9644), borderRadius: BorderRadius.circular(24)),
        child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.logout, color: Colors.white),
          SizedBox(width: 12),
          Text('Log Out', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
        ]),
      ),
    );
  }
}
