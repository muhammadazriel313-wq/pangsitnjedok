import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart';
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
// Import halaman navigasi
import 'edit_profil_customer.dart';

import 'cart.dart';
import 'order.dart';
import 'my_favorites.dart';
import 'rating_views.dart';

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
      String userId =
          prefs.getString('id') ?? prefs.getString('customer_id') ?? "1";

      var response = await ApiService.getProfile(userId);

      if (mounted) {
        setState(() {
          if (response['status'] == 'success') {
            name = response['data']['name'] ?? "User";
            phone = response['data']['no_telepon'] ?? "-";
            profileImageUrl = response['data']['foto_profil'];
          } else {
            name = "User Not Found";
          }
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          name = "Connection Error";
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
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Color(0xFF954A00),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9442)),
            )
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

                    _buildMenuItem(
                      Icons.person_outline,
                      'Edit Account',
                      'Update your details',
                      onTap: _navigateToEditAccount,
                    ),
                    _buildMenuItem(
                      Icons.assignment_outlined,
                      'My Orders',
                      'Track your pangsit',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MyOrdersPage(),
                        ),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.favorite_outline,
                      'My Favorites',
                      'Your loved items',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const FavoritePage(),
                        ),
                      ),
                    ),
                    _buildMenuItem(
                      Icons.star_outline,
                      'Rating & Reviews',
                      'Rate Us',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RatingViewsPage(),
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                    _buildLogoutButton(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
      bottomNavigationBar: buildBottomNavbar(context, '/profil_customer'),
    );
  }

  Widget _buildProfileHeader(String userName, String userPhone) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFFF9644), width: 3),
                image: DecorationImage(
                  image:
                      (profileImageUrl != null &&
                          profileImageUrl!.isNotEmpty &&
                          profileImageUrl!.startsWith('http'))
                      ? NetworkImage(profileImageUrl!)
                      : const AssetImage('assets/images/nipis.jpeg')
                            as ImageProvider,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          userName,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800),
        ),
        Text(userPhone, style: const TextStyle(color: Color(0xFF554337))),
      ],
    );
  }

  Widget _buildMenuItem(
    IconData icon,
    String title,
    String subtitle, {
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0x33FF9644),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: const Color(0xFFFF9644)),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(color: Colors.grey, fontSize: 12),
                  ),
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
      onTap: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.clear();
        if (mounted) {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/login',
            (route) => false,
          );
        }
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9644),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Center(
          child: Text(
            'Log Out',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const CartPage()),
      ),
      backgroundColor: const Color(0xFFFF9442),
      child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
    );
  }
}
