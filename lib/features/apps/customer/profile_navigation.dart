import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfileNavigation(),
    );
  }
}

class ProfileNavigation extends StatelessWidget {
  const ProfileNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    // Warna yang disesuaikan dengan referensi gambar kedua
    const Color yellowBackground = Color(0xFFFCB841);
    const Color redContainer = Color(0xFFE34221);

    return Scaffold(
      backgroundColor: yellowBackground,
      body: SafeArea(
        child: Stack(
          children: [
            // 1. Bagian kiri (Waktu dan Tombol Back)
            Positioned(
              top: 16,
              left: 24,
              child: Text(
                '16:04',
                style: TextStyle(
                  color: const Color(0xFF391713),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'League Spartan',
                ),
              ),
            ),
            Positioned(
              top: 80,
              left: 24,
              child: Icon(
                Icons.arrow_back_ios,
                color: redContainer,
                size: 18,
              ),
            ),

            // 2. Container Merah Utama
            Positioned(
              top: 0,
              bottom: 0,
              left: 60, // Memberikan jarak untuk strip kuning di kiri
              right: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: redContainer,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(60),
                    bottomLeft: Radius.circular(60),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 32, right: 24, top: 60),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Profile Header
                      Row(
                        children: [
                          Container(
                            width: 65,
                            height: 65,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                              image: const DecorationImage(
                                image: NetworkImage(
                                    'https://via.placeholder.com/150'), // Ganti dengan asset Anda
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Customer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'League Spartan',
                                ),
                              ),
                              Text(
                                'customer@email.com',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'League Spartan',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      // List Menu
                      Expanded(
                        child: ListView(
                          physics: const BouncingScrollPhysics(),
                          children: [
                            _buildMenuItem(
                              icon: Icons.person_outline,
                              title: 'Profil',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              icon: Icons.phone_in_talk_outlined,
                              title: 'Kontak',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              icon: Icons.notifications_none_outlined,
                              title: 'Notifikasi',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              icon: Icons.settings_outlined,
                              title: 'Pengaturan',
                              onTap: () {},
                            ),
                            _buildDivider(),
                            _buildMenuItem(
                              icon: Icons.logout_outlined,
                              title: 'Log Out',
                              onTap: () {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget custom untuk item menu
  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    const Color redColor = Color(0xFFE34221);

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(
                icon,
                color: redColor, // Warna icon disesuaikan dengan latar merah
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w500,
                fontFamily: 'League Spartan',
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget custom untuk garis pemisah transparan
  Widget _buildDivider() {
    return const Divider(
      color: Colors.white38,
      thickness: 1,
      height: 30,
    );
  }
}