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
        body: ListView(
          children: const [
            ALogIn(),
          ],
        ),
      ),
    );
  }
}

class ALogIn extends StatelessWidget {
  const ALogIn({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
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
              // --- ELEMEN DI BAWAH INI AKAN DITIMPA OLEH ELEMEN YANG DITULIS BELAKANGAN ---

              // Status Bar
              const Positioned(
                left: 25,
                top: 10,
                child: SizedBox(
                  width: 50,
                  height: 14,
                  child: Text(
                    '16:04',
                    style: TextStyle(
                      color: Color(0xFF391713),
                      fontSize: 13,
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              // Judul "Selamat Datang"
              const Positioned(
                left: 105,
                top: 70,
                child: Text(
                  'Selamat Datang',
                  style: TextStyle(
                    color: Color(0xFFF8F8F8),
                    fontSize: 28,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),

              // --- TAMBAHAN: IKON SINYAL ---
              const Positioned(
                right: 65, // Posisi dari kanan
                top: 9,    // Sejajar dengan teks waktu
                child: Icon(
                  Icons.signal_cellular_alt, // Ikon sinyal
                  color: Color(0xFF391713), // Warna yang sama
                  size: 14,
                ),
              ),

           //ikon wifi//
              const Positioned(
                right: 50, // Jarak 75px dari tepi kanan layar
                top: 9,   // Posisi vertikal yang sama dengan teks waktu
                child: Icon(
                  Icons.wifi, // Ikon Wi-Fi
                  color: Color(0xFF391713), // Warna senada
                  size: 14, // Ukuran ikon
                 ),
                ),


              // --- TAMBAHAN: IKON BATERAI ---
          const Positioned(
            right: 35, // Posisi dari kanan
            top: 9,   // Sejajar dengan teks waktu
            child: Icon(
              Icons.battery_full,
              color: Color(0xFF391713), // Warna yang sama dengan teks waktu
              size: 14,
            ),
          ),


               // --- TAMBAHAN: TOMBOL BACK ---
          const Positioned(
            left: 20,
            top: 40,
            child: Icon(
            Icons.arrow_back_ios,
            color: Color(0xFFE93C22),
            size: 20,
            ),
          ),

              // --- PERUBAHAN 1: LATAR BELAKANG PUTIH DINAIKAN ---
              Positioned(
                top: 190, // <--- DINAIKAN MENJADI 190
                left: 0,
                right: 0,
                bottom: 0,
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                ),
              ),

              // --- AREA FORM (DITURUNKAN KARENA LATAR PUTIH NAIK) ---
              // Label "Email atau Nomor HP"
              const Positioned(
                left: 36,
                top: 365, // <--- DITURUNKAN
                child: Text(
                  'Email atau Nomor HP',
                  style: TextStyle(
                    color: Color(0xFF391713),
                    fontSize: 20,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Input Field Email
              Positioned(
                left: 36,
                top: 400, // <--- DITURUNKAN
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
              // Label "Password"
              const Positioned(
                left: 36,
                top: 460, // <--- DITURUNKAN
                child: Text(
                  'Password ',
                  style: TextStyle(
                    color: Color(0xFF391713),
                    fontSize: 20,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Input Field Password
              Positioned(
                left: 36,
                top: 500, // <--- DITURUNKAN
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
              // Link "Lupa Kata Sandi?"
              const Positioned(
                left: 242,
                top: 555, // <--- DITURUNKAN
                child: Text(
                  'Lupa Kata Sandi?',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    color: Color(0xFFE93C22),
                    fontSize: 14,
                    fontFamily: 'League Spartan',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              // Tombol "Masuk"
              Positioned(
                left: 93,
                top: 690, // <--- DITURUNKAN
                child: Container(
                  width: 207,
                  height: 45,
                  decoration: ShapeDecoration(
                    color: const Color(0xFFE93C22),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Center(
                    child: Text(
                      'Masuk',
                      textAlign: TextAlign.center,
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

              // --- PERUBAHAN 2: TEKS INI DIPINDAHKAN KE BAWAH AGAR MUNCUL DI ATAS LATAR ---
              // Teks "Halo, Cah Nganjuk!"
              const Positioned(
                left: 36,
                top: 210,
                child: SizedBox(
                  width: 250,
                  height: 30,
                  child: Text(
                    'Halo, Cah Nganjuk!',
                    style: TextStyle(
                      color: Color(0xFF391713),
                      fontSize: 24,
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              // Teks Deskripsi
              const Positioned(
                left: 36,
                top: 250,
                child: SizedBox(
                  width: 322,
                  child: Text(
                    'Yuk, masuk dulu buat lanjut pesen pangsit favoritmu! Khusus buat kamu Cah Nganjuk yang laper tapi mager, login sekarang dan biarkan Pangsit Njedok meluncur hangat sampai ke depan pintu rumahmu',
                    style: TextStyle(
                      color: Color(0xFF252525),
                      fontSize: 14,
                      fontFamily: 'League Spartan',
                      fontWeight: FontWeight.w300,
                      height: 1.2,
                    ),
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