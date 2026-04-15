import 'package:flutter/material.dart';

void main() {
  runApp(const PangsitNjedokApp());  // Fungsi utama, menjalankan aplikasi dengan root widget PangsitNjedokApp
}

class PangsitNjedokApp extends StatelessWidget {  // Widget utama aplikasi (tidak bisa berubah)
  const PangsitNjedokApp ({super.key});

  @override
  Widget build(BuildContext context) { // Method untuk membangun UI
    return MaterialApp(  // MaterialApp = kerangka dasar aplikasi (routing, theme, dll)
      theme: ThemeData.dark().copyWith( // Menggunakan tema gelap lalu dimodifikasi
        scaffoldBackgroundColor: const Color.fromARGB(255, 18, 32, 47),
        // Mengubah warna background utama aplikasi
      ),
      home: Scaffold( // Scaffold = struktur dasar halaman
        body: ListView(  // ListView = widget scroll (bisa digeser ke bawah)
          children: const [
            ALogIn(),
          ],
        ),
      ),
    );
  }
}

class ALogIn extends StatelessWidget {  // Widget halaman login
  const ALogIn({super.key});

  @override
  Widget build(BuildContext context) { // Method untuk membangun UI
    return Column(
      children: [
        Container(
          width: 393,
          height: 852, // Ukuran layar 
          clipBehavior: Clip.antiAlias,

          decoration: ShapeDecoration( 
            color: const Color(0xFFF5CB58), // Background kuning
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Stack(
            children: [
            

              // ================= STATUS BAR =================
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

              // ================= JUDUL =================
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


              // ================= ICON SINYAL ================
              const Positioned(
                right: 65, 
                top: 9,    
                child: Icon(
                  Icons.signal_cellular_alt, // Ikon sinyal
                  color: Color(0xFF391713), 
                  size: 14,
                ),
              ),

            // ================= ICON WIFI =================
              const Positioned(
                right: 50, 
                top: 9,   
                child: Icon(
                  Icons.wifi, // Ikon Wi-Fi
                  color: Color(0xFF391713), 
                  size: 14, 
                 ),
                ),


              // --- TAMBAHAN: IKON BATERAI ---
          const Positioned(
            right: 35, 
            top: 9,   
            child: Icon(
              Icons.battery_full,
              color: Color(0xFF391713), 
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

              // --- PERUBAHAN 1: LATAR BELAKANG PUTIH ---
              Positioned(
                top: 190, // 
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

      
              //  ================= LABEL EMAIL =================
              const Positioned(
                left: 36,
                top: 365, // 
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
                top: 400, 
                child: Container(
                  width: 322,
                  height: 45,
                  decoration: ShapeDecoration( // untuk mengatur tampilan visual dari container, khususnya warna dan bentuknya
                    color: const Color(0xFFF3E9B5),
                    shape: RoundedRectangleBorder( //menentukan bentuk → persegi panjang
                      borderRadius: BorderRadius.circular(13),
                    ),
                  ),
                ),
              ),

              // Label "Password"
              const Positioned(
                left: 36,
                top: 460, // 
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
                top: 500, 
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

                  // --- KOLOM PASSWORD DENGAN IKON MATA ---
                Positioned(
                left: 335,
                top: 512,
                child: Container(
                  child: Align(
                    alignment: Alignment.centerRight, 
                    child: Padding(
                      padding: const EdgeInsets.only(right: 12.0), // Memberi jarak agar tidak menempel
                      child: Icon(
                        Icons.visibility_off, // Ikon mata tertutup
                        color: Color.fromARGB(255, 57, 19, 19),
                        size: 20,
                      ),
                    ),
                  ),
                ),
              ),

              // Lupa Kata Sandi
              const Positioned(
                left: 242,
                top: 555, 
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

              // Button Tombol Masuk
              Positioned(
                left: 93,
                top: 690,
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

               // ================= DESKRIPSI =================
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