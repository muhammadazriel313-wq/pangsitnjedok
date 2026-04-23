import 'package:flutter/material.dart';

void main() {
  runApp(const PangsitNjedogApp());
}

class PangsitNjedogApp extends StatelessWidget {
  const PangsitNjedogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Plus Jakarta Sans',
        scaffoldBackgroundColor: const Color(0xFFFCFAEE),
      ),
      // Halaman awal adalah ProfilePage
      home: const ProfilePage(),
    );
  }
}

// --- HALAMAN PROFIL ---
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
            Text('Pangsit Njedog', style: TextStyle(color: Color(0xFF562F00), fontWeight: FontWeight.bold, fontSize: 20)),
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
            
            // Tombol Edit Account dengan Navigasi
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
            
            _buildMenuItem(Icons.assignment_outlined, 'My Orders', 'Track your pangsit'),
            _buildMenuItem(Icons.favorite_outline, 'My Favorites', 'Your loved items'),
            _buildMenuItem(Icons.star_outline, 'Rating & Reviews', 'Rate Us'),

            const SizedBox(height: 20),
            _buildLogoutButton(),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavbar(context, true),
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  // Widget pendukung Profil...
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
            Positioned(bottom: 0, right: 0, child: _editCircleIcon()),
          ],
        ),
        const SizedBox(height: 16),
        const Text('Alex Brandon', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
        const Text('+62 812-3456-7890', style: TextStyle(color: Color(0xFF554337))),
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
}

// --- HALAMAN EDIT ACCOUNT ---
class EditAccountPage extends StatelessWidget {
  const EditAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF954A00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile', style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Header Foto
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120, height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFFF9644), width: 4),
                          image: const DecorationImage(image: AssetImage('assets/images/nipis.jpeg'), fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(bottom: 0, right: 0, child: _editCircleIcon()),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Alex Thompson', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Premium Member', style: TextStyle(color: Color(0xFF554337), fontStyle: FontStyle.italic)),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // Form Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
              ),
              child: Column(
                children: [
                  _buildTextField("Full Name", "Alex Thompson"),
                  const SizedBox(height: 20),
                  _buildTextField("Email Address", "alex.thompson@email.com"),
                  const SizedBox(height: 20),
                  _buildTextField("Phone Number", "+62 812-3456-7890"),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            // Verified Badge
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFF6E8D8), borderRadius: BorderRadius.circular(20)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF633909)),
                  SizedBox(width: 8),
                  Text('ACCOUNT VERIFIED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF633909))),
                ],
              ),
            ),

            const SizedBox(height: 30),
            // Save Button
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9644),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 5, shadowColor: const Color(0xFFFF9644),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C3400))),
            ),
            
            const SizedBox(height: 20),
            const Text.rich(TextSpan(children: [
              TextSpan(text: 'Having trouble? ', style: TextStyle(color: Colors.grey)),
              TextSpan(text: 'Contact Support', style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold)),
            ])),
            const SizedBox(height: 100),
          ],
        ),
      ),
      // ... bagian body dan lainnya ...
      bottomNavigationBar: _buildBottomNavbar(context, true),
      // Tambahkan ini agar keranjang muncul kembali
      floatingActionButton: _buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

  Widget _buildTextField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF554337), fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE4E3D7),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }

// --- WIDGET GLOBAL REUSABLE ---
Widget _editCircleIcon() {
  return Container(
    padding: const EdgeInsets.all(8),
    decoration: const BoxDecoration(color: Color(0xFF954A00), shape: BoxShape.circle),
    child: const Icon(Icons.edit, color: Colors.white, size: 16),
  );
}

Widget _buildBottomNavbar(BuildContext context, bool isProfileActive) {
  return BottomAppBar(
    height: 70, color: Colors.white,
    shape: const CircularNotchedRectangle(),
    notchMargin: 8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _navbarItem(Icons.home_outlined, 'Home', false),
        _navbarItem(Icons.restaurant_menu, 'Menu', false),
        const SizedBox(width: 40),
        _navbarItem(Icons.receipt_long_outlined, 'Orders', false),
        _navbarItem(Icons.person, 'Profile', isProfileActive),
      ],
    ),
  );
}

Widget _navbarItem(IconData icon, String label, bool isActive) {
  return Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, color: isActive ? const Color(0xFFFF9442) : Colors.grey),
    Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFFFF9442) : Colors.grey)),
  ]);
}

Widget _buildFAB() {
  return FloatingActionButton(
    onPressed: () {},
    backgroundColor: const Color(0xFFFF9442),
    shape: const CircleBorder(),
    child: const Badge(label: Text('3'), child: Icon(Icons.shopping_cart_outlined, color: Colors.white)),
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