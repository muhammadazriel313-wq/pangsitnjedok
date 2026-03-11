import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
      ),
      home: Scaffold(
        body: ListView(children: [
          Frame1000003604(),
        ]),
      ),
    );
  }
}

class Frame1000003604 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 393,
          height: 852,
          child: Stack(
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Container(
                  width: 393,
                  height: 852,
                  clipBehavior: Clip.antiAlias,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFF5CB58),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [

                      // === WHITE CARD (rotasi dari Figma) ===
                      Positioned(
                        left: 393,
                        top: 850,
                        child: Container(
                          transform: Matrix4.identity()
                            ..translate(0.0, 0.0)
                            ..rotateZ(-3.14),
                          width: 393,
                          height: 706,
                          clipBehavior: Clip.antiAlias,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF5F5F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(30),
                                bottomRight: Radius.circular(30),
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                left: 281,
                                top: 377,
                                child: Container(
                                  transform: Matrix4.identity()
                                    ..translate(0.0, 0.0)
                                    ..rotateZ(3.14),
                                  width: 47,
                                  height: 15,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // === STATUS BAR ===
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 393,
                          height: 32,
                          clipBehavior: Clip.antiAlias,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5CB58),
                          ),
                          child: Stack(
                            children: [
                              // Jam
                              Positioned(
                                left: 35,
                                top: 9,
                                child: SizedBox(
                                  width: 50,
                                  height: 14,
                                  child: Text(
                                    '16:04',
                                    style: TextStyle(
                                      color: const Color(0xFF391713),
                                      fontSize: 13,
                                      fontFamily: 'League Spartan',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                              // Ikon sinyal
                              const Positioned(
                                right: 65,
                                top: 9,
                                child: Icon(
                                  Icons.signal_cellular_alt,
                                  color: Color(0xFF391713),
                                  size: 14,
                                ),
                              ),
                              // Ikon wifi
                              const Positioned(
                                right: 50,
                                top: 9,
                                child: Icon(
                                  Icons.wifi,
                                  color: Color(0xFF391713),
                                  size: 14,
                                ),
                              ),
                              // Ikon baterai
                              const Positioned(
                                right: 35,
                                top: 9,
                                child: Icon(
                                  Icons.battery_full,
                                  color: Color(0xFF391713),
                                  size: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // === TOMBOL BACK ===
                      Positioned(
                        left: 20,
                        top: 40,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(
                            Icons.arrow_back_ios,
                            color: Color(0xFFE93C22),
                            size: 20,
                          ),
                        ),
                      ),

                      // === JUDUL ===
                      Positioned(
                        left: 91,
                        top: 68,
                        child: Text(
                          'Daftar Akun Baru',
                          style: TextStyle(
                            color: const Color(0xFFF8F8F8),
                            fontSize: 28,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),

                      Positioned(
                        left: 35,
                        top: 84,
                        child: Container(
                          width: 8,
                          height: 13,
                          decoration: ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Stack(),
                        ),
                      ),

                      // === LABEL NAMA LENGKAP ===
                      Positioned(
                        left: 41,
                        top: 301,
                        child: Text(
                          'Nama Lengkap',
                          style: TextStyle(
                            color: const Color(0xFF391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // === FIELD NAMA LENGKAP ===
                      Positioned(
                        left: 35,
                        top: 331,
                        child: Container(
                          width: 322,
                          height: 45,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF3E9B5),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFE9F6FE),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 51,
                        top: 340,
                        child: Text(
                          'username',
                          style: TextStyle(
                            color: const Color(0xFF391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      // === LABEL EMAIL ===
                      Positioned(
                        left: 41,
                        top: 395,
                        child: Text(
                          'Email',
                          style: TextStyle(
                            color: const Color(0xFF391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // === FIELD EMAIL ===
                      Positioned(
                        left: 37,
                        top: 427,
                        child: Container(
                          width: 321,
                          height: 45,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF3E9B5),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFE9F6FE),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 48,
                        top: 432,
                        child: Text(
                          'username123@gmail.com',
                          style: TextStyle(
                            color: const Color(0xFF391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),

                      // === LABEL PASSWORD ===
                      Positioned(
                        left: 41,
                        top: 488,
                        child: Text(
                          'Password',
                          style: TextStyle(
                            color: const Color(0xFF391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // === FIELD PASSWORD ===
                      Positioned(
                        left: 37,
                        top: 520,
                        child: Container(
                          width: 322,
                          height: 45,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 322,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF3E9B5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 293,
                                top: 13,
                                child: Container(
                                  width: 16.49,
                                  height: 13.74,
                                  child: Stack(),
                                ),
                              ),
                              Positioned(
                                left: 13,
                                top: 12,
                                child: Container(
                                  width: 129,
                                  height: 21,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0),
                                  ),
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 6,
                                        top: 4,
                                        child: Text(
                                          '*********',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 12,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // === LABEL NO. HANDPHONE ===
                      Positioned(
                        left: 36,
                        top: 586,
                        child: Text(
                          'No. handphone',
                          style: TextStyle(
                            color: const Color(0xFF391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),

                      // === FIELD NO. HANDPHONE ===
                      Positioned(
                        left: 33,
                        top: 616,
                        child: Container(
                          width: 321,
                          height: 45,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF3E9B5),
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: const Color(0xFFE9F6FE),
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 48,
                        top: 625,
                        child: Text(
                          '+62 89654957080',
                          style: TextStyle(
                            color: const Color(0xFF391713),
                            fontSize: 20,
                            fontFamily: 'League Spartan',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),

                      // === TEKS SYARAT & KETENTUAN ===
                      Positioned(
                        left: 60,
                        top: 708,
                        child: Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Dengan melanjutkan, Anda menyetujui \n ',
                                style: TextStyle(
                                  color: const Color(0xFF391713),
                                  fontSize: 12,
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextSpan(
                                text: 'Ketentuan Penggunaan',
                                style: TextStyle(
                                  color: const Color(0xFFE93C22),
                                  fontSize: 12,
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              TextSpan(
                                text: ' dan ',
                                style: TextStyle(
                                  color: const Color(0xFF391713),
                                  fontSize: 12,
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
                              TextSpan(
                                text: 'Kebijakan Privasi',
                                style: TextStyle(
                                  color: const Color(0xFFE93C22),
                                  fontSize: 12,
                                  fontFamily: 'League Spartan',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),

                      // === TOMBOL DAFTAR ===
                      Positioned(
                        left: 93,
                        top: 754,
                        child: Container(
                          width: 207,
                          height: 45,
                          child: Stack(
                            children: [
                              Positioned(
                                left: 0,
                                top: 0,
                                child: Container(
                                  width: 207,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFE93C22),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 67,
                                top: 5,
                                child: Text(
                                  'Daftar',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),

              // === TOMBOL CUSTOMER / ADMIN ===
              Positioned(
                left: 48,
                top: 175,
                child: Container(
                  width: 300,
                  height: 50,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 300,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFD9D9D9),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 0,
                        top: 0,
                        child: Container(
                          width: 150,
                          height: 50,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFE93C22),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 24,
                        top: 13,
                        child: Text(
                          'Customer',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 194,
                        top: 13,
                        child: Text(
                          'Admin',
                          style: TextStyle(
                            color: const Color(0xFF979797),
                            fontSize: 20,
                            fontFamily: 'Inter',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            ],
          ),
        ),
      ],
    );
  }
}