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
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFF5CB58),
      ),
      home: const ALaunchFirstScreen(),
    );
  }
}

class ALaunchFirstScreen extends StatelessWidget {
  const ALaunchFirstScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            decoration: const BoxDecoration(
              color: Color(0xFFF5CB58),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Gambar Pangsit (ganti dengan asset lokal atau icon)
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE93C22).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Text(
                      '🥟',
                      style: TextStyle(fontSize: 100),
                    ),
                  ),
                ),
                
                const SizedBox(height: 40),
                
                // Teks "Hadir untuk memanjakan lidah..."
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(50),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Hadir untuk memanjakan lidah\nwarga anjuk ladang!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE93C22),
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      height: 1.3,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Deskripsi produk
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Text(
                    'Nikmati sensasi pangsit dengan isian melimpah, bumbu rahasia yang pedas nampol di setiap gigitan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFE93C22),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
                
                const SizedBox(height: 30),
                
                // Icon pangsit
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text('🥟', style: TextStyle(fontSize: 40)),
                    Text('🔥', style: TextStyle(fontSize: 40)),
                    Text('🥟', style: TextStyle(fontSize: 40)),
                    Text('🌶️', style: TextStyle(fontSize: 40)),
                    Text('🥟', style: TextStyle(fontSize: 40)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}