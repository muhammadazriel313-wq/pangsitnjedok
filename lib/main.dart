import 'package:flutter/material.dart';

void main() {
  runApp(const PangsitNjedokApp());
}

class PangsitNjedokApp extends StatelessWidget {
  const PangsitNjedokApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Pangsit Njedok",
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFF8F8F8),
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const HeaderSection(),
                const SizedBox(height: 25),
                const PromoBannerSection(),
                const SizedBox(height: 25),
                const RekomendasiTitle(),
                const SizedBox(height: 15),
                const MenuGridSection(),
                const SizedBox(height: 120), // Spasi ekstra agar tidak tertutup navbar
              ],
            ),
          ),
          const Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(),
          ),
        ],
      ),
    );
  }
}

// 1. HEADER SECTION
class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
          child: Image.asset(
            "assets/images/pangsitsaus.jpeg", // PAKAI ASSET
            height: 400,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          height: 400,
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.vertical(bottom: Radius.circular(35)),
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.2),
                Colors.transparent,
                Colors.black.withOpacity(0.5),
              ],
            ),
          ),
        ),
        Positioned(
          top: 50,
          right: 20,
          child: Row(
            children: [
              _circleIcon(Icons.shopping_cart_outlined),
              const SizedBox(width: 12),
              _circleIcon(Icons.person_outline),
            ],
          ),
        ),
        const Positioned(
          left: 25,
          bottom: 50,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Selamat Pagi",
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "Waktunya Jajan Di Pangsit Njedok Yuk!",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFFFFD166),
                  fontWeight: FontWeight.bold,
                ),
              )
            ],
          ),
        )
      ],
    );
  }

  Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
      child: Icon(icon, size: 20, color: const Color(0xffE95322)),
    );
  }
}

// 2. PROMO BANNER
class PromoBannerSection extends StatelessWidget {
  const PromoBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: const Color(0xffE95322),
            ),
            child: Row(
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Cicipi menu kami\nyang lezat!",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                  child: Image.asset(
                    "assets/images/pangsit_tulangrangu.jpeg", // PAKAI ASSET
                    width: 160,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                )
              ],
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (index) => _buildDot(index == 2)),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      height: 4,
      width: isActive ? 18 : 12,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xffE95322) : const Color(0xFFFFD7C6),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

// 3. REKOMENDASI TITLE
class RekomendasiTitle extends StatelessWidget {
  const RekomendasiTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "Rekomendasi",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF391713)),
          ),
          Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xffE95322))
        ],
      ),
    );
  }
}

// 4. MENU GRID
class MenuGridSection extends StatelessWidget {
  const MenuGridSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(child: _buildMenuItem("assets/images/lecyy.jpeg", "10K")), // PAKAI ASSET
          const SizedBox(width: 15),
          Expanded(child: _buildMenuItem("assets/images/pangsit.jpeg", "15K")), // PAKAI ASSET
        ],
      ),
    );
  }

  Widget _buildMenuItem(String path, String price) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(path, height: 160, width: double.infinity, fit: BoxFit.cover),
        ),
        const Positioned(
          top: 12,
          right: 12,
          child: CircleAvatar(
            radius: 12,
            backgroundColor: Colors.white,
            child: Icon(Icons.favorite, size: 14, color: Colors.red),
          ),
        ),
        Positioned(
          bottom: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: const BoxDecoration(
              color: Color(0xffE95322),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomRight: Radius.circular(25),
              ),
            ),
            child: Text(
              price,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        )
      ],
    );
  }
}

// 5. CUSTOM BOTTOM NAV BAR
class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      color: Colors.transparent,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Container(
            height: 70,
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xffE93C22),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(width: 60), 
                Icon(Icons.receipt_long_outlined, color: Colors.white, size: 28),
                Icon(Icons.favorite_border, color: Colors.white, size: 28),
                Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
              ],
            ),
          ),
          Positioned(
            left: 25,
            bottom: 25,
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: const BoxDecoration(color: Color(0xFFF8F8F8), shape: BoxShape.circle),
              child: const CircleAvatar(
                radius: 30,
                backgroundColor: Color(0xFFF5CB58),
                child: Icon(Icons.home, color: Color(0xffE93C22), size: 35),
              ),
            ),
          ),
        ],
      ),
    );
  }
}