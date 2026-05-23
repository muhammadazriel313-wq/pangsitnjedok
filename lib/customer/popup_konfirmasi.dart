import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart';
import 'popup_terimakasih.dart'; // Memastikan halaman terima kasih terhubung

void main() {
  runApp(const PopupKonfirmasi());
}

class PopupKonfirmasi extends StatelessWidget {
  const PopupKonfirmasi({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFFC4C4C4),
      body: Center(child: OrderConfirmationDialog()),
    );
  }
}

class OrderConfirmationDialog extends StatefulWidget {
  const OrderConfirmationDialog({super.key});

  @override
  State<OrderConfirmationDialog> createState() =>
      _OrderConfirmationDialogState();
}

class _OrderConfirmationDialogState extends State<OrderConfirmationDialog> {
  bool _isSubmitting = false;

  Future<Map<String, String>> _getCustomerIdentity() async {
    final prefs = await SharedPreferences.getInstance();
    final customerId = prefs.getString('customer_id') ?? "1"; // Ambil ID customer dari session HP
    final profile = await ApiService.getProfile(customerId);
    if (profile['status'] == 'success' && profile['data'] is Map) {
      final data = Map<String, dynamic>.from(profile['data'] as Map);
      return {
        'name': (data['name'] ?? 'Customer').toString(),
        'phone': (data['no_telepon'] ?? '-').toString(),
      };
    }

    return {'name': 'Customer', 'phone': '-'};
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAEE),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 8),
          Text(
            'Confirm Order',
            style: GoogleFonts.beVietnamPro(
              color: const Color(0xFF562F00),
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Is your order data correct?',
            textAlign: TextAlign.center,
            style: GoogleFonts.beVietnamPro(
              color: const Color(0xFF887366),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 32),

          // -----------------------------------------------------------------
          // TOMBOL KONFIRMASI UTAMA (Data masuk ke database & order.dart)
          // -----------------------------------------------------------------
          ElevatedButton(
            onPressed: _isSubmitting
                ? null
                : () async {
                    setState(() {
                      _isSubmitting = true;
                    });

                    try {
                      // 1. Ambil data keranjang dari SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      final String? cartString = prefs.getString(
                        'customer_cart_items_v1',
                      );

                      List<dynamic> cartItems = [];
                      int totalItems = 0;
                      int totalHarga = 0;

                      if (cartString != null) {
                        cartItems = jsonDecode(cartString) as List<dynamic>;
                        for (var item in cartItems) {
                          int qty = int.tryParse('${item['qty']}') ?? 0;
                          int price = int.tryParse('${item['price']}') ?? 0;
                          totalItems += qty;
                          totalHarga += (price * qty);
                        }
                      }

                      // 2. Ambil identitas nama customer
                      final identity = await _getCustomerIdentity();
                      String customerName = identity['name'] ?? 'Customer';
                      String customerPhone = identity['phone'] ?? '-';

                      // 3. Susun data pesanan dalam bentuk Map (JSON)
                      Map<String, dynamic> orderData = {
                        "customer_name": customerName,
                        "no_telepon": customerPhone,
                        "total_items": totalItems,
                        "total_amount": "Rp $totalHarga",
                        "items": cartItems
                            .map(
                              (item) => {
                                "menu_id": item['title'],
                                "qty": item['qty'],
                                "price": item['price'],
                              },
                            )
                            .toList(),
                      };

                      // 4. Kirim data ke API simpan_pesanan.php
                      bool success = await ApiService.submitOrder(orderData);

                      if (success) {
                        // Jika sukses, bersihkan keranjang belanja di lokal HP
                        await prefs.remove('customer_cart_items_v1');

                        // Pindah secara aman ke halaman Terima Kasih
                        if (context.mounted) {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PopupTerimakasih(),
                            ),
                          );
                        }
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Failed to send order to server.',
                              ),
                            ),
                          );
                        }
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Terjadi kesalahan koneksi database.',
                            ),
                          ),
                        );
                      }
                    } finally {
                      if (mounted) {
                        setState(() {
                          _isSubmitting = false;
                        });
                      }
                    }
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF562F00),
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 56),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isSubmitting
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'Confirm & Place Order',
                    style: GoogleFonts.beVietnamPro(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
          ),
          const SizedBox(height: 12),

          // -----------------------------------------------------------------
          // TOMBOL CANCEL (UI/UX Asli)
          // -----------------------------------------------------------------
          ElevatedButton(
            onPressed: () {
              if (Navigator.canPop(context)) {
                Navigator.pop(context);
              } else {
                Navigator.pushReplacementNamed(context, '/cart');
              }
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
