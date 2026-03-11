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
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// HEADER SECTION
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                  child: Image.asset(
                    "assets/images/pangsitsaus.jpeg", // Menggunakan assets
                    height: 380,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Container(
                  height: 380,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.3),
                        Colors.transparent,
                        Colors.black.withOpacity(0.5),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  right: 20,
                  top: 50,
                  child: Row(
                    children: [
                      _circleIcon(Icons.shopping_cart_outlined),
                      const SizedBox(width: 12),
                      _circleIcon(Icons.person_outline),
                    ],
                  ),
                ),
                Positioned(
                  left: 20,
                  bottom: 40,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Selamat Pagi",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Waktunya Jajan Di Pangsit Njedok Yuk!",
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.orangeAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),

            const SizedBox(height: 25),

            /// PROMO CARD
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  Container(
                    height: 130,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: const Color(0xffE95322),
                    ),
                    child: Row(
                      children: [
                        const Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Text(
                              "Cicipi menu kami\yang lezat!",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(20),
                            bottomRight: Radius.circular(20),
                          ),
                          child: Image.asset(
                            "assets/images/pangsit_tulangrangu.jpeg", // Menggunakan assets
                            width: 160,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _dotIndicator(false),
                      _dotIndicator(false),
                      _dotIndicator(true),
                      _dotIndicator(false),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// REKOMENDASI TITLE
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    "Rekomendasi",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF4A2C2A)),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFFE95322))
                ],
              ),
            ),

            const SizedBox(height: 15),

            /// MENU GRID
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(child: _menuItem("assets/images/lecyy.jpeg", "10K")),
                  const SizedBox(width: 15),
                  Expanded(child: _menuItem("assets/images/pangsit.jpeg", "15K")),
                ],
              ),
            ),
            const SizedBox(height: 100),
          ],
        ),
      ),

      /// BOTTOM NAVIGATION
      bottomNavigationBar: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior: Clip.none,
        children: [
          Container(
            height: 70,
            decoration: const BoxDecoration(
              color: Color(0xffE93C22),
              borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: const [
                SizedBox(width: 40),
                Icon(Icons.receipt_long_outlined, color: Colors.white, size: 28),
                Icon(Icons.favorite_border, color: Colors.white, size: 28),
                Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 28),
              ],
            ),
          ),
          Positioned(
            bottom: 25,
            left: 30,
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
              child: const CircleAvatar(
                radius: 28,
                backgroundColor: Colors.orange,
                child: Icon(Icons.home, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _dotIndicator(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      height: 4,
      width: isActive ? 20 : 12,
      decoration: BoxDecoration(
        color: isActive ? Colors.orange : Colors.orange.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }

  static Widget _menuItem(String imagePath, String price) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(25),
          child: Image.asset(
            imagePath, // Menggunakan path lokal
            height: 160, 
            width: double.infinity, 
            fit: BoxFit.cover,
            // Error builder jika file tidak ditemukan
            errorBuilder: (context, error, stackTrace) => Container(
              height: 160,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            ),
          ),
        ),
        const Positioned(
          right: 12,
          top: 12,
          child: CircleAvatar(
            radius: 14,
            backgroundColor: Colors.white,
            child: Icon(Icons.favorite, size: 16, color: Colors.red),
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
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        )
      ],
    );
  }

  static Widget _circleIcon(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: const Color(0xffE95322)),
    );
  }
}