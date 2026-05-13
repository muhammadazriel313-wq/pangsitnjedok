import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PopupKonfirmasi extends StatelessWidget {
  const PopupKonfirmasi({super.key});

  @override
  Widget build(BuildContext context) {
    // Menggunakan Scaffold untuk mendukung navigasi rute dengan background simulasi
    return const Scaffold(
      backgroundColor: Color(0xFFC4C4C4), 
      body: Center(
        child: OrderConfirmationDialog(),
      ),
    );
  }
}

class OrderConfirmationDialog extends StatelessWidget {
  const OrderConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B1C15).withOpacity(0.2),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Confirm Your Order',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF1B1C15),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Check your order again before making a payment.',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF887366),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 32),

          // Tombol Confirm Order
          ElevatedButton(
            onPressed: () {
              // MENYAMBUNGKAN KE HALAMAN TERIMAKASIH
              Navigator.pushNamed(context, '/terimakasih');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9442),
              minimumSize: const Size(double.infinity, 56),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Confirm Order',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Tombol Cancel
          ElevatedButton(
            onPressed: () {
              // KEMBALI KE HALAMAN CART
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF6F4E8),
              foregroundColor: const Color(0xFF562F00),
              minimumSize: const Size(double.infinity, 56),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Cancel',
              style: GoogleFonts.beVietnamPro(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Footer Text
          const Divider(color: Color(0x19DBC1B2), height: 1),
          const SizedBox(height: 24),
          Text(
            'PANGSIT NJEDOG PREMIUM SERVICE',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              color: const Color(0xFF887366),
              fontSize: 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}