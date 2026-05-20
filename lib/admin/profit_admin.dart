import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; 
import '/service/api_service.dart';
import '/service/pdf_service.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart'; // untuk kIsWeb
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html; // hanya aktif di web

class ProfitAdmin extends StatefulWidget {
  const ProfitAdmin({super.key});

  @override
  State<ProfitAdmin> createState() => _ProfitAdminState();
}

class _ProfitAdminState extends State<ProfitAdmin> {
  DateTime _selectedDate = DateTime.now();
  bool _isGeneratingPdf = false;

  // --- NAVIGASI NORMAL ---
  void _navigateTo(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  // --- FUNGSI PILIH TANGGAL ---
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime.now(),
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(primary: Color(0xFFC2410C)),
        ),
        child: child!,
      ),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }
// --- FUNGSI GENERATE & DOWNLOAD PDF ---
 Future<void> _downloadPDF(Map<String, dynamic> data) async {
  setState(() => _isGeneratingPdf = true);

  try {
    final pdfBytes = await PdfService.generateFinancialReport(
      selectedDate: DateFormat('yyyy-MM-dd').format(_selectedDate),
      revenue: data['total_revenue'] ?? 'Rp 0',
      netProfit: data['net_profit'] ?? 'Rp 0',
      chartData: (data['chart_data'] as List?)?.cast<double>() ?? [0.1,0.1,0.1,0.1,0.1,0.1,0.1],
      bestSelling: data['best_selling'] ?? [],
    );

    // kIsWeb untuk cek platform
    if (kIsWeb) {
      // Untuk web: download langsung via browser
      // ignore: avoid_web_libraries_in_flutter
      final blob = html.Blob([pdfBytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'laporan_${DateFormat('yyyyMMdd').format(_selectedDate)}.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      // Untuk mobile: simpan & share
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/laporan_${DateFormat('yyyyMMdd_HHmmss').format(DateTime.now())}.pdf');
      await file.writeAsBytes(pdfBytes);
      await Share.shareXFiles(
        [XFile(file.path)],
        text: 'Laporan Financial Income Pangsit Njedok\nPeriode: ${DateFormat('dd MMMM yyyy').format(_selectedDate)}',
      );
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('PDF berhasil dibuat!'),
          backgroundColor: Color(0xFFC2410C),
        ),
      );
    }
  } catch (e) {
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: $e'), backgroundColor: Colors.red),
      );
    }
  } finally {
    if (mounted) setState(() => _isGeneratingPdf = false);
  }
}

  @override
  Widget build(BuildContext context) {
    // Format tanggal untuk dikirim ke API (YYYY-MM-DD)
    String dateForApi = DateFormat('yyyy-MM-dd').format(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7ED),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Financial Income', 
          style: TextStyle(color: Color(0xFFC2410C), fontWeight: FontWeight.bold)
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.getprofitData(dateForApi),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442)));
          }
          
          // Handling data dari API
          final data = snapshot.data ?? {};
          final List chartPoints = data['chart_data'] ?? [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1];
          final List bestSelling = data['best_selling'] ?? [];

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDateCard(), // Tombol tanggal di tengah
                const SizedBox(height: 32),
                
                // Row untuk Revenue dan Profit
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Revenue', data['total_revenue'] ?? 'Rp 0')),
                    const SizedBox(width: 16),
                    Expanded(child: _buildMetricCard('Net Profit (40%)', data['net_profit'] ?? 'Rp 0')),
                  ],
                ),
                
                const SizedBox(height: 32),
                const Text('7 Day Trend', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF562F00))),
                const SizedBox(height: 16),
                _buildChart(chartPoints.cast<double>()), // Grafik trend omset
                
                const SizedBox(height: 32),
                  // Header Best Selling dengan Tombol Download
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Best Selling',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF562F00)),
                    ),
                    ElevatedButton.icon(
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
                
                if (bestSelling.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Center(child: Text("Belum ada data penjualan")),
                  )
                else
                  ...bestSelling.asMap().entries.map((e) {
                    var item = e.value;
                    return _buildBestItem(
                      e.key + 1, 
                      item['name'].toString(), 
                      int.parse(item['sold'].toString()), 
                      item['amount'].toString()
                    );
                  }).toList(),
                
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- UI COMPONENTS ---

  Widget _buildDateCard() {
    return Center(
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFC2410C),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFC2410C).withOpacity(0.3),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.calendar_month_rounded, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Text(
                DateFormat('dd MMMM yyyy').format(_selectedDate),
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

  Widget _buildMetricCard(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(color: const Color(0xFFFFCE99)),
        boxShadow: const [BoxShadow(color: Color(0x0A562F00), blurRadius: 20)],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF562F00))),
      ]),
    );
  }

  Widget _buildChart(List<double> points) {
    return Container(
      height: 200, width: double.infinity, padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(24), 
        border: Border.all(color: const Color(0xFFFFCE99))
      ),
      child: CustomPaint(painter: _ChartPainter(points)),
    );
  }

  Widget _buildBestItem(int rank, String name, int sold, String amount) {
    bool top = rank <= 3;
    return Container(
      margin: const EdgeInsets.only(bottom: 12), padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: top ? const Color(0xFFFFF7ED) : Colors.white, 
        borderRadius: BorderRadius.circular(20), 
        border: Border.all(color: top ? const Color(0xFFFF9442) : const Color(0xFFFFCE99))
      ),
      child: Row(children: [
        CircleAvatar(
          backgroundColor: top ? const Color(0xFFFF9442) : const Color(0xFFFFCE99), 
          child: Text('$rank', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold))
        ),
        const SizedBox(width: 16),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: Color(0xFF562F00))), 
          Text('$sold terjual', style: const TextStyle(color: Colors.grey, fontSize: 12))
        ])),
        Text(amount, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFC2410C))),
      ]),
    );
  }

  // --- BOTTOM NAV ---
  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDF1), 
        border: Border(top: BorderSide(color: Color(0xFFFFCE99)))
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem("Dashboard", Icons.dashboard_outlined, false, '/dashboard'),
          _buildNavItem("Orders", Icons.receipt_long_outlined, false, '/order'),
          _buildNavItem("Menu", Icons.restaurant_menu_outlined, false, '/menu'),
          _buildNavItem("Income", Icons.bar_chart, true, '/profit'),
          _buildNavItem("Profile", Icons.person_outline, false, '/profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, bool active, String route) {
    return GestureDetector(
      onTap: () => active ? null : _navigateTo(route),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), 
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFFCE99) : Colors.transparent, 
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

// --- PAINTER GRAFIK ---
// --- PAINTER GRAFIK ALA CRYPTO (SMOOTH & GRADIENT) ---
class _ChartPainter extends CustomPainter {
  final List<double> points;
  _ChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    // 1. Pengaturan Spasi dan Titik Koordinat
    final double spacing = size.width / (points.length - 1);
    final List<Offset> coordinates = [];
    for (int i = 0; i < points.length; i++) {
      coordinates.add(Offset(i * spacing, size.height * (1 - points[i])));
    }

    // 2. Membuat Path untuk Garis Kurva Mulus (Smooth Bezier)
    final path = Path();
    path.moveTo(coordinates[0].dx, coordinates[0].dy);

    for (int i = 0; i < coordinates.length - 1; i++) {
      final p1 = coordinates[i];
      final p2 = coordinates[i + 1];
      
      // Logika Bezier untuk membuat lengkungan yang mulus
      final controlPoint1 = Offset(p1.dx + spacing / 2, p1.dy);
      final controlPoint2 = Offset(p2.dx - spacing / 2, p2.dy);
      
      path.cubicTo(
        controlPoint1.dx, controlPoint1.dy,
        controlPoint2.dx, controlPoint2.dy,
        p2.dx, p2.dy,
      );
    }

    // 3. Membuat Path untuk Efek Gradien Fill (Area di bawah garis)
    final fillPath = Path()..addPath(path, Offset.zero);
    fillPath.lineTo(size.width, size.height); // Tarik garis ke kanan bawah
    fillPath.lineTo(0, size.height); // Tarik garis ke kiri bawah
    fillPath.close(); // Tutup path

    // 4. Menggambar Efek Gradien (Warna Fill)
    final paintFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0x80FF9442), // Oranye transparan di atas
          Color(0x00FFFDF1), // Hilang total di bawah
        ],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));
    
    canvas.drawPath(fillPath, paintFill);

    // 5. Menggambar Garis Kurva Utama (Stroke)
    final paintStroke = Paint()
      ..color = const Color(0xFFFF9442) // Warna oranye tegas
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 // Garis agak tebal ala Crypto
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paintStroke);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
