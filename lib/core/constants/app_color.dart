import 'package:flutter/material.dart';

class AppColor {
  // --- Background Colors ---
  static const Color bgPrimary = Color(0xFFFFFDF1); // Background utama kekuningan
  static const Color bgSecondary = Color(0xFFFCFAEE); // Background Register
  static const Color bgTextField = Color(0xFFE4E3D7); // Background kolom input form
  
  // --- Primary Colors (Orange) ---
  static const Color primary = Color(0xFFFF9442); // Orange utama (logo/tombol)
  static const Color primaryDark = Color(0xFFFF9644); // Orange sedikit gelap
  static const Color primaryLight = Color(0xFFFFCE99); // Orange pudar (untuk Divider/Border)
  
  // --- Text Colors (Browns & Grays) ---
  static const Color textDarkBrown = Color(0xFF562F00); // Warna teks judul utama
  static const Color textMediumBrown = Color(0xFF554337); // Warna teks label (Full Name, dll)
  static const Color textFadedBrown = Color(0xB2562F00); // Warna teks subjudul
  static const Color textHighlight = Color(0xFF954A00); // Warna teks untuk link "Sign Up"
  static const Color textHint = Color(0xFF6B7280); // Warna teks abu-abu (Hint Text)
  
  // --- Transparent/Opacity Colors (Untuk Shadow & Dekorasi) ---
  static const Color primaryTransparent10 = Color(0x19FF9442); // 10% Opacity Orange
  static const Color primaryTransparent15 = Color(0x26FF9442); // 15% Opacity Orange
  static const Color primaryTransparent20 = Color(0x33FF9442); // 20% Opacity Orange
}