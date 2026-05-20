import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'popup_terimakasih.dart'; 

class PopupKonfirmasi extends StatelessWidget {
  const PopupKonfirmasi({super.key});

  @override
  Widget build(BuildContext context) {
    // Dibungkus Dialog biar ukurannya pas dan backgroundnya transparan
    return const Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: OrderConfirmationDialog(),
    );
  }
}

class OrderConfirmationDialog extends StatelessWidget {
  const OrderConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1B1C15).withOpacity(0.2),
            blurRadius: 50,
            offset: const Offset(0, 20),
          )
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon Keranjang
          Container(
            width: 64, height: 64,
            decoration: const BoxDecoration(color: Color(0xFFFFE4C4), shape: BoxShape.circle),
            child: const Icon(Icons.shopping_basket_outlined, color: Color(0xFF8B4513), size: 32),
          ),
          const SizedBox(height: 24),

          // Title
          Text(
            'Place Order?',
            textAlign: TextAlign.center,
            style: GoogleFonts.plusJakartaSans(
              color: const Color(0xFF1B1C15), fontSize: 24, fontWeight: FontWeight.w700, letterSpacing: -0.60,
            ),
          ),
          const SizedBox(height: 12),

          // Subtitle
          Text(
            'Are you sure you want to place\nthis order? You won\'t be able to\nchange the items once confirmed.',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              color: const Color(0xFF554337), fontSize: 15, height: 1.5, fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),

          // Tombol YES
          ElevatedButton(
            onPressed: () {
              // 1. Tutup pop up konfirmasi
              Navigator.of(context).pop(); 

              // 2. Langsung panggil pop up Terima Kasih
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return const Dialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.symmetric(horizontal: 24),
                    child: PopupTerimakasih(), 
                  );
                },
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9644),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Yes, Place Order', style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w700)),
                const SizedBox(width: 8),
                const Icon(Icons.chevron_right, size: 20),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Tombol Cancel (DIBENERIN BIAR CUMA TUTUP POP-UP)
          ElevatedButton(
            onPressed: () {
              // Cukup pop untuk kembali ke keranjang tanpa menghapus item
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF6F4E8),
              foregroundColor: const Color(0xFF562F00),
              minimumSize: const Size(double.infinity, 56),
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: Text('Cancel', style: GoogleFonts.beVietnamPro(fontSize: 16, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(height: 24),

          // Footer Text
          const Divider(color: Color(0x19DBC1B2), height: 1),
          const SizedBox(height: 24),
          Text(
            'PANGSIT NJEDOG PREMIUM SERVICE',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              color: const Color(0xFF887366), fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}