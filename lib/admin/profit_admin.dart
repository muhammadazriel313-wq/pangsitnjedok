import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import 'dart:convert';
import 'package:http/http.dart' as http;
import '/service/api_service.dart';
import '/service/pdf_service.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // untuk kIsWeb
// ignore: avoid_web_libraries_in_flutter, deprecated_member_use
import 'dart:html' as html; // hanya aktif di web

// Ini adalah StatefulWidget. Kita pakai ini karena halaman ini dinamis,
// artinya ada data yang bisa berubah-ubah di layar (misal: tanggal yang dipilih).
class ProfitAdmin extends StatefulWidget {
  const ProfitAdmin({super.key});

  @override
  State<ProfitAdmin> createState() => _ProfitAdminState();
}

// Di kelas State ini, kita menyimpan data (variabel) dan logika tampilan halaman.
class _ProfitAdminState extends State<ProfitAdmin> {
  // Variabel untuk menyimpan tanggal yang sedang dipilih, bawaannya adalah hari ini.
  DateTime _selectedDate = DateTime.now();
  
  // Variabel penanda apakah PDF sedang dalam proses pembuatan atau tidak (buat nampilin loading).
  bool _isGeneratingPdf = false;

  // --- FUNGSI UNTUK PINDAH HALAMAN (NAVIGASI) ---
  // Fungsi ini dipakai buat ganti halaman menu navigasi di bawah.
  // Kita pakai pushReplacementNamed biar halaman sebelumnya ditutup dan diganti halaman baru.
  void _navigateTo(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  // --- FUNGSI UNTUK MEMILIH TANGGAL (DATE PICKER) ---
  // Fungsi ini bakal memunculkan kalender pop-up bawaan Flutter saat diklik.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Tanggal awal yang disorot (tanggal sekarang)
      firstDate: DateTime(2024), // Batas tahun paling lampau yang bisa dipilih
      lastDate: DateTime.now(),   // Batas paling mentok adalah hari ini (tidak bisa pilih masa depan)
      // Builder ini dipakai untuk mewarnai tema kalendernya jadi oranye khas Pangsit Njedok
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFFC2410C)),
        ),
        child: child!,
      ),
    );
    // Jika user benar-benar memilih tanggal (bukan klik batal), kita simpan tanggalnya
    // dan panggil setState() supaya Flutter langsung menggambar ulang layar dengan tanggal baru.
    if (picked != null) setState(() => _selectedDate = picked);
  }

  // --- FUNGSI UNTUK MEMBUAT DAN MENGUNDUH LAPORAN PDF ---
  // Fungsi ini menerima data keuangan dari API lalu mengubahnya jadi dokumen PDF.
  Future<void> _downloadPDF(Map<String, dynamic> data) async {
    // Kita set variabel ini jadi true supaya muncul animasi loading (muter-muter) di tombol
    setState(() => _isGeneratingPdf = true);

    try {
      // Kita panggil PdfService yang sudah dibuat untuk menyusun data ke dalam bentuk PDF bytes
      final pdfBytes = await PdfService.generateFinancialReport(
        selectedDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
        revenue: data['total_revenue'] ?? 'Rp 0',
        netProfit: data['net_profit'] ?? 'Rp 0',
        chartData: (data['chart_data'] as List?)?.cast<double>() ?? [0.1,0.1,0.1,0.1,0.1,0.1,0.1],
        bestSelling: data['best_selling'] ?? [],
      );

      // kIsWeb adalah konstanta bawaan Flutter untuk mendeteksi apakah aplikasi dijalankan di web browser
      if (kIsWeb) {
        // --- KHUSUS PLATFORM WEB ---
        // Kita buat objek Blob (biner data) dari PDF bytes agar bisa diunduh oleh browser
        // ignore: avoid_web_libraries_in_flutter, deprecated_member_use
        final blob = html.Blob([pdfBytes], 'application/pdf');
        // Membuat URL sementara untuk Blob tadi
        final url = html.Url.createObjectUrlFromBlob(blob);
        // Membuat elemen link tersembunyi (<a>), set nama file unduhan, lalu klik otomatis biar ke-download
        html.AnchorElement(href: url)
          ..setAttribute('download', 'laporan_${DateFormat('yyyyMMdd').format(_selectedDate)}.pdf')
          ..click();
        // Hapus URL sementara dari memori browser biar tidak bikin lambat/bocor memori
        html.Url.revokeObjectUrl(url);
      } else {
        // --- KHUSUS PLATFORM MOBILE (ANDROID & IOS) ---
        // Cari folder penyimpanan sementara di HP
        final tempDir = await getTemporaryDirectory();
        // Tentukan nama file PDF yang mau disimpan (dilengkapi jam menit detik biar unik)
        final file = File('${tempDir.path}/laporan_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf');
        // Tulis data byte PDF ke dalam file fisik tersebut
        await file.writeAsBytes(pdfBytes);
        // Membuka menu share bawaan HP supaya user bisa kirim PDF lewat WhatsApp, Email, dll.
        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Laporan Financial Income Pangsit Njedok\nPeriode: ${DateFormat('dd MMMM yyyy').format(_selectedDate)}',
        );
      }

      // Jika halaman ini masih aktif (tidak ditutup oleh user saat proses berjalan)
      if (mounted) {
        // Tampilkan pesan sukses warna oranye di bagian bawah layar (SnackBar)
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('PDF berhasil dibuat!'),
            backgroundColor: Color(0xFFC2410C),
          ),
        );
      }
    } catch (e) {
      // Jika terjadi error di tengah jalan, tampilkan pesan gagal warna merah
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      // Kode di dalam block 'finally' akan SELALU dijalankan, baik sukses maupun error.
      // Di sini kita matikan loading tombolnya biar tombol bisa diklik lagi.
      if (mounted) setState(() => _isGeneratingPdf = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Kita ubah tanggal yang dipilih ke format YYYY-MM-DD biar sesuai kebutuhan API database
    String dateForApi = DateFormat('yyyy-MM-dd').format(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1), // Background utama krem kalem
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7ED),
        elevation: 0, // Biar gak ada bayangan menonjol di bawah AppBar
        centerTitle: true,
        title: const Text(
          'Financial Income', 
          style: TextStyle(color: Color(0xFFC2410C), fontWeight: FontWeight.bold)
        ),
      ),
      // FutureBuilder ini andalan banget buat nungguin request data dari internet/API selesai.
      // Dia punya 3 kondisi: loading, sukses dapet data, atau error.
      body: FutureBuilder<Map<String, dynamic>>(
        // Kita panggil fungsi API untuk mengambil data keuangan berdasarkan tanggal yang dipilih
        future: ApiService.getprofitData(dateForApi),
        builder: (context, snapshot) {
          // KONDISI 1: Jika data masih dalam perjalanan (sedang dimuat)
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442))); // Tampilkan loading muter-muter
          }
          
          // KONDISI 2: Jika data sudah selesai didapat (sukses)
          final data = snapshot.data ?? {};
          // Ambil data untuk grafik trend mingguan (kalau kosong, pakai data default)
          final List chartPoints = data['chart_data'] ?? [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];
          // Ambil data menu terlaris
          final List bestSelling = data['best_selling'] ?? [];

          // Kita pakai SingleChildScrollView biar layarnya bisa di-scroll ke bawah kalau kepanjangan
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateCard(), // Menampilkan tombol tanggal berbentuk pil di tengah
                const SizedBox(height: 32),
                
                // Row untuk menampilkan kotak Revenue (Pendapatan) dan Profit (Keuntungan) bersebelahan
                Row(
                  children: [
                    // Expanded dipakai biar kedua kotak ukurannya sama rata memenuhi lebar layar
                    Expanded(child: _buildMetricCard('Revenue', data['total_revenue'] ?? 'Rp 0')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('Net Profit (40%)', data['net_profit'] ?? 'Rp 0')),
                  ],
                ),
                
                const SizedBox(height: 32),
                const Text('7 Day Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF562F00))),
                const SizedBox(height: 16),
                _buildChart(chartPoints.cast<double>()), // Memanggil widget custom grafis trend 7 hari
                
                const SizedBox(height: 32),
                
                // Bagian header Menu Terlaris dan Tombol Cetak PDF
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Best Selling',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF562F00)),
                    ),
                    // Tombol unduh PDF dengan ikon PDF manis
                    ElevatedButton.icon(
                      // Kalau PDF lagi dibikin, tombolnya dinonaktifkan (null) biar gak diklik berkali-kali
                      onPressed: _isGeneratingPdf ? null : () => _downloadPDF(data),
                      icon: _isGeneratingPdf
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.picture_as_pdf, size: 20),
                      label: Text(_isGeneratingPdf ? 'Memproses...' : 'Unduh PDF'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFC2410C),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                // Kondisi jika belum ada data penjualan sama sekali
                if (bestSelling.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("Belum ada data penjualan")),
                  )
                else
                  // Jika ada data, tampilkan daftarnya satu per satu dengan menggunakan map.
                  // spread operator (...) dipakai untuk menggabungkan daftar widget ke dalam Column ini.
                  ...bestSelling.asMap().entries.map((e) {
                    var item = e.value;
                    return _buildBestItem(
                      e.key + 1, // Urutan rank (dimulai dari 1)
                      item['name'].toString(), 
                      int.parse(item['sold'].toString()), 
                      item['amount'].toString()
                    );
                  }),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(), // Menu navigasi di bagian paling bawah
    );
  }

  // --- KOMPONEN TAMPILAN (UI WIDGETS) ---

  // Kotak pemilih tanggal berbentuk pil/kapsul di tengah atas
  Widget _buildDateCard() {
    return Center(
      child: GestureDetector(
        onTap: () => _selectDate(context), // Jika diklik, buka kalender
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFC2410C),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC2410C).withValues(alpha: 0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min, // Biar ukuran kotak pas dengan teks di dalamnya (tidak melar penuh)
            children: [
              const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                DateFormat('dd MMMM yyyy').format(_selectedDate), // Tampilkan format tanggal cantik (misal: 20 Mei 2026)
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.keyboard_arrow_down_rounded, color: Colors.white, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  // Kotak mungil untuk menampilkan info Pendapatan atau Keuntungan Bersih
  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(color: const Color(0xFFFFCE99)), // Garis tepi oranye soft
        boxShadow: const [BoxShadow(color: Color(0x0A562F00), blurRadius: 20)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)), // Judul metrik
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF562F00))), // Nilai uang rupiah
      ]),
    );
  }

  // Kotak penampung grafik kurva trend 7 hari
  Widget _buildChart(List<double> points) {
    return Container(
      height: 230, width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0xFFFFCE99))),
      child: Column(
        children: [
          Expanded(
            // SUDAH DIPERBAIKI: Parameter 'width' yang salah pada CustomPaint telah dibuang
            child: CustomPaint(
              size: Size.infinite,
              painter: _ChartPainter(points),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              String shortDay = day.toString().substring(0, 3);
              return Container(
                width: 38,
                alignment: Alignment.center,
                child: Text(
                  shortDay,
                  style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0x99562F00)),
                ),
              );
            }).toList(),
          )
        ],
      ),
      // CustomPaint dipakai buat menggambar grafik manual pakai koordinat Canvas (seperti menggambar di Corel/Photoshop)
      child: CustomPaint(painter: _ChartPainter(points)),
    );
  }

  // Kotak daftar menu terlaris beserta rangkingnya (juara 1, 2, 3)
  Widget _buildBestItem(int rank, String name, int sold, String amount) {
    bool top = rank <= 3; // Rangking 1 sampai 3 diberi warna khusus biar keliatan prestasinya!
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: top ? const Color(0xFFFFF7ED) : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: top ? const Color(0xFFFF9442) : const Color(0xFFFFCE99))),
      child: Row(children: [
        // Lingkaran nomor peringkat (juara)
        CircleAvatar(
          backgroundColor: top ? const Color(0xFFFF9442) : const Color(0xFFFFCE99), 
          child: Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
        ),
        const SizedBox(width: 16),
        // Nama produk dan total porsi terjual
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF562F00))), 
          Text('$sold porsi terjual', style: const TextStyle(color: Colors.grey, fontSize: 12))
        ])),
        // Total uang dari penjualan item tersebut
        Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC2410C))),
      ]),
    );
  }

  // --- MEMBUAT NAVIGATION BAR BAWAH (BOTTOM NAVIGATION BAR) ---
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(color: Color(0xFFFFFDF1), border: Border(top: BorderSide(color: Color(0xFFFFCE99)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Navigasi ikon-ikon menu admin
          _buildNavItem("Dashboard", Icons.dashboard_outlined, false, '/dashboard'),
          _buildNavItem("Orders", Icons.receipt_long_outlined, false, '/order'),
          _buildNavItem("Menu", Icons.restaurant_menu_outlined, false, '/menu'),
          _buildNavItem("Income", Icons.bar_chart, true, '/profit'), // Halaman Income aktif
          _buildNavItem("Profile", Icons.person_outline, false, '/profil'),
        ],
      ),
    );
  }

  // Membuat item ikon tunggal untuk bottom navigation bar
  Widget _buildNavItem(String label, IconData icon, bool active, String route) {
    return GestureDetector(
      onTap: () => active ? null : _navigateTo(route), // Kalau aktif, gak usah pindah halaman lagi
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFFCE99) : Colors.transparent, // Beri background oranye soft kalau aktif
            borderRadius: BorderRadius.circular(20)
          ), 
          child: Icon(icon, color: const Color(0xFF562F00))
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 10, color: active ? const Color(0xFF562F00) : Colors.grey, fontWeight: FontWeight.bold)),
      ]),
    );
  }
}

// --- LOGIKA MENGGAMBAR GRAFIK CURVE & GRADIENT ---
// Kelas ini mewarisi CustomPainter untuk menggambar kurva trend omset ala grafik pasar modal (Crypto).
class _ChartPainter extends CustomPainter {
  final List<double> points;
  _ChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // 1. Hitung jarak antar titik horizontal berdasarkan lebar layar
    final double spacing = size.width / (points.length - 1);
    final List<Offset> coordinates = [];
    
    // Ubah nilai persentase points menjadi titik koordinat piksel layar (X, Y)
    for (int i = 0; i < points.length; i++) {
      coordinates.add(Offset(i * spacing, size.height * (1 - points[i])));
    }

    // 2. Menggambar garis kurva melengkung mulus memakai rumus matematika Bezier (Cubic To)
    final path = Path();
    path.moveTo(coordinates[0].dx, coordinates[0].dy);

    for (int i = 0; i < coordinates.length - 1; i++) {
      final p1 = coordinates[i];
      final p2 = coordinates[i + 1];
      
      // Menghitung titik kendali (control point) agar lengkungan kurva terlihat smooth/luwes
      final controlPoint1 = Offset(p1.dx + spacing / 2, p1.dy);
      final controlPoint2 = Offset(p2.dx - spacing / 2, p2.dy);
      
      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx, controlPoint2.dy, p2.dx, p2.dy);
    }

    // 3. Membuat efek shading/gradien transparan di bawah garis kurva
    final fillPath = Path()..addPath(path, Offset.zero);
    fillPath.lineTo(size.width, size.height); // Garis ditarik ke pojok kanan bawah canvas
    fillPath.lineTo(0, size.height);          // Tarik lagi ke pojok kiri bawah canvas
    fillPath.close();                         // Gabungkan jadi satu bentuk tertutup

    // 4. Warnai area bawah kurva dengan gradien dari oranye transparan ke pudar hilang
    final paintFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x80FF9442), // Oranye transparan di bagian atas grafik
          Color(0x00FFFDF1), // Pudar/transparan total di bagian paling bawah
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    
    canvas.drawPath(fillPath, paintFill);

    // 5. Menggambar garis luar (stroke) kurva utamanya agar terlihat tegas
    final paintStroke = Paint()
      ..color = const Color(0xFFFF9442) // Warna oranye garis utama
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 // Ketebalan garis kurva
      ..strokeCap = StrokeCap.round; // Ujung garis dibuat membulat manis

    canvas.drawPath(path, paintStroke);

  // Menentukan apakah grafik perlu digambar ulang ketika ada perubahan data (selalu ya!)
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}