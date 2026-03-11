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
          Frame1000003605(),
        ]),
      ),
    );
  }
}

class Frame1000003605 extends StatelessWidget {
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

                      // === WHITE CARD ===
                      Positioned(
                        left: 0,
                        top: 146,
                        child: Container(
                          width: 393,
                          height: 706,
                          decoration: ShapeDecoration(
                            color: const Color(0xFFF5F5F5),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(30),
                                topRight: Radius.circular(30),
                              ),
                            ),
                          ),
                          child: Stack(
                            children: [

                              // LOGIN ADMIN
                              Positioned(
                                left: 0,
                                right: 0,
                                top: 30,
                                child: Text(
                                  'LOGIN ADMIN',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 32,
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),

                              // Tombol Customer / Admin
                              Positioned(
                                left: 47,
                                top: 90,
                                child: Container(
                                  width: 300,
                                  height: 50,
                                  child: Stack(
                                    children: [
                                      Container(
                                        width: 300,
                                        height: 50,
                                        decoration: ShapeDecoration(
                                          color: const Color(0xFFD9D9D9),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(50),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 150,
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
                                        left: 29,
                                        top: 13,
                                        child: Text(
                                          'Customer',
                                          style: TextStyle(
                                            color: const Color(0xFF979797),
                                            fontSize: 20,
                                            fontFamily: 'Inter',
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 197,
                                        top: 13,
                                        child: Text(
                                          'Admin',
                                          style: TextStyle(
                                            color: Colors.white,
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

                              // Label Username
                              Positioned(
                                left: 35,
                                top: 170,
                                child: Text(
                                  'Username',
                                  style: TextStyle(
                                    color: Color(0xFF391713),
                                    fontSize: 20,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Field Username
                              Positioned(
                                left: 35,
                                top: 200,
                                child: Container(
                                  width: 322,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF3E9B5),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(0xFFE9F6FE)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),

                              // Label Password
                              Positioned(
                                left: 35,
                                top: 265,
                                child: Text(
                                  'Password',
                                  style: TextStyle(
                                    color: Color(0xFF391713),
                                    fontSize: 20,
                                    fontFamily: 'League Spartan',
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                              // Field Password
                              Positioned(
                                left: 35,
                                top: 295,
                                child: Container(
                                  width: 322,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFF3E9B5),
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(width: 1, color: Color(0xFFE9F6FE)),
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                ),
                              ),

                              // Tombol Masuk
                              Positioned(
                                left: 93,
                                top: 400,
                                child: Container(
                                  width: 207,
                                  height: 45,
                                  decoration: ShapeDecoration(
                                    color: const Color(0xFFE93C22),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Masuk',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontFamily: 'League Spartan',
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
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
                          decoration: BoxDecoration(color: const Color(0xFFF5CB58)),
                          child: Stack(
                            children: [
                              // Jam
                              Positioned(
                                left: 35,
                                top: 9,
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

                      // Tombol back
                      const Positioned(
                        left: 20,
                        top: 40,
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color(0xFFE93C22),
                          size: 20,
                        ),
                      ),

                      // Judul
                      Positioned(
                        left: 90,
                        top: 60,
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