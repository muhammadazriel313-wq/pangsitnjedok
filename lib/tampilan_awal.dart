import 'package:flutter/material.dart';
import 'halaman_login.dart';

class TampilanAwal extends StatelessWidget {
  const TampilanAwal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            left: -50, top: -50,
            child: Container(
              width: 250, height: 250,
              decoration: const BoxDecoration(color: Color(0x19FF9442), shape: BoxShape.circle),
            ),
          ),
          Positioned(
            right: -100, bottom: 50,
            child: Container(
              width: 320, height: 320,
              decoration: const BoxDecoration(color: Color(0x26FF9442), shape: BoxShape.circle),
            ),
          ),
          
          SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(),
                
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0x33FF9442), width: 4),
                    boxShadow: [
                      BoxShadow(color: const Color(0xFFFF9442).withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 10))
                    ],
                  ),
                  child: const Icon(Icons.soup_kitchen, size: 80, color: Color(0xFFFF9442)),
                ),
                const SizedBox(height: 24),
                
                const Text(
                  'Pangsit Njedok',
                  style: TextStyle(color: Color(0xFF562F00), fontSize: 36, fontWeight: FontWeight.w800, letterSpacing: -0.9),
                ),
                const SizedBox(height: 8),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(width: 32, height: 1, color: const Color(0x33562F00)),
                    const SizedBox(width: 8),
                    const Text('WARM & TASTY', style: TextStyle(color: Color(0xB2562F00), fontSize: 14, fontWeight: FontWeight.w600, letterSpacing: 1.5)),
                    const SizedBox(width: 8),
                    Container(width: 32, height: 1, color: const Color(0x33562F00)),
                  ],
                ),
                const SizedBox(height: 64),
                
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9442),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56), 
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                      elevation: 8,
                    ),
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanLogin()));
                    },
                    child: const Text('Start', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                
                const Spacer(),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.local_fire_department_outlined, color: Color(0x66562F00), size: 24),
                    SizedBox(width: 16),
                    Icon(Icons.breakfast_dining_outlined, color: Color(0x66562F00), size: 24),
                    SizedBox(width: 16),
                    Icon(Icons.ramen_dining_outlined, color: Color(0x66562F00), size: 24),
                  ],
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}