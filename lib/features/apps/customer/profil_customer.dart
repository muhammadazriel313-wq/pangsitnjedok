import 'package:flutter/material.dart';
import 'edit_profil_customer.dart';
import 'order.dart';
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
import 'package:aplikasipangsitnjedok/core/network/api_services.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String userName = "Loading..."; 
  String userPhone = "";

  @override
  void initState() {
    super.initState();
    refreshData(); // Panggil fungsi saat halaman pertama kali dibuka
  }

  void refreshData() async {
    // Pastikan fungsi getCustomerProfile sudah ada di ApiService
    var data = await ApiService.getCustomerProfile("1"); 
    if (data['status'] == 'success') {
      if (mounted) { // Cek apakah widget masih ada di layar
        setState(() {
          // Sesuaikan dengan key di JSON PHP kamu
          userName = data['data']['name']; 
          userPhone = data['data']['no_telepon'];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Color(0xFF954A00)),
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Profile', style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.w600, fontSize: 18)),
            Text('Pangsit Njedok', style: TextStyle(color: Color(0xFF562F00), fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 32),
            _buildProfileHeader(),
            const SizedBox(height: 40),
            
            _buildMenuItem(
              Icons.person_outline, 
              'Edit Account', 
              'Update your details', 
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditAccountPage()),
                );
              }
            ),
            
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

            _buildMenuItem(Icons.favorite_outline, 'My Favorites', 'Your loved items'),
            _buildMenuItem(Icons.star_outline, 'Rating & Reviews', 'Rate Us'),

            const SizedBox(height: 20),
            _buildLogoutButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavbar(context, true),
      floatingActionButton: buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              width: 130, height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(image: AssetImage('assets/images/nipis.jpeg'), fit: BoxFit.cover),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20)],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Ganti teks manual menjadi variabel userName
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
    return Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(color: const Color(0xFFFF9644), borderRadius: BorderRadius.circular(24)),
      child: const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.logout, color: Color(0xFFFF9644)),
        SizedBox(width: 12),
        Text('Log Out', style: TextStyle(color: Color(0xFF6C3400), fontWeight: FontWeight.bold, fontSize: 16)),
      ]),
    );
  }
}