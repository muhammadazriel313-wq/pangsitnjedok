import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'features/auth/screens/tampilan_awal.dart'; // Pastikan file tampilan_awal.dart sudah benar kodenya


void main() {
  runApp(const PopupTerimakasih());
}

class PopupTerimakasih extends StatelessWidget {
  const PopupTerimakasih({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: const Color(0xFFFCFAEE),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 40,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Garis Gradient di bagian atas
            Container(
              height: 6,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF954A00), Color(0xFFFF9644), Color(0xFFFFCF9A)],
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                children: [
                  // Tombol Close (X)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: () {
                            // Mengarahkan ke HomePage dan menghapus semua halaman sebelumnya
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => TampilanAwal()),
                              (route) => false,
                            );
                          },
                          icon: const Icon(Icons.close, color: Color(0xFF554337)),
                        ),
                      ),

                  // Ilustrasi Ikon Centang & Lingkaran
                  const OrderSuccessIllustration(),
                  
                  const SizedBox(height: 32),

                  // Teks Utama
                  Text(
                    'Thank you for your\norder!',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      color: const Color(0xFF562F00),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  
                  const SizedBox(height: 16),

                  // Deskripsi
                  Text(
                    'Your order has been successfully\nplaced and is being prepared.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.beVietnamPro(
                      color: const Color(0xFF554337),
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      height: 1.5,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Tombol Track Order
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9644),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 56),
                      elevation: 4,
                      shadowColor: const Color(0xFFFF9644).withOpacity(0.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Text(
                      'Track Order',
                      style: GoogleFonts.beVietnamPro(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Info Box "My Orders"
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF6F4E8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.receipt_long_outlined, size: 20, color: Color(0xFF887366)),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'You can also find this under My Orders',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.plusJakartaSans(
                              color: const Color(0xFF887366),
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget khusus untuk membuat ilustrasi lingkaran konsentris
class OrderSuccessIllustration extends StatelessWidget {
  const OrderSuccessIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      width: 180,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Lingkaran terluar (paling transparan)
          Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9644).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
          ),
          // Ornamen titik kecil
          Positioned(top: 20, left: 30, child: _dot(10, const Color(0xFFFF9644).withOpacity(0.4))),
          Positioned(bottom: 20, right: 30, child: _dot(14, const Color(0xFFFFCE99).withOpacity(0.6))),
          Positioned(top: 60, right: 10, child: _dot(6, const Color(0xFF562F00).withOpacity(0.3))),
          
          // Lingkaran tengah
          Container(
            width: 130,
            height: 130,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFCFAEE), width: 4),
              gradient: const LinearGradient(
                colors: [Color(0xFFFFCE99), Color(0xFFFF9644)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                )
              ],
            ),
            child: const Icon(
              Icons.check,
              color: Colors.white,
              size: 60,
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}