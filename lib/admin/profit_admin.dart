import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:aplikasipangsitnjedok/service/api_service.dart';
import 'package:aplikasipangsitnjedok/service/pdf_service.dart';

class ProfitAdmin extends StatefulWidget {
  const ProfitAdmin({super.key});

  @override
  State<ProfitAdmin> createState() => _ProfitAdminState();
}

class _ProfitAdminState extends State<ProfitAdmin> {
  DateTime _selectedDate = DateTime.now();

  void _navigateTo(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  Future<void> _selectDate(BuildContext context) async {
    // PENJELASAN UNTUK SIDANG:
    // showDatePicker() adalah fungsi bawaan Flutter untuk menampilkan kalender popup.
    // 'await' digunakan karena kita harus menunggu pengguna memilih tanggal 
    // sebelum memproses data tanggal tersebut.
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
    if (picked != null && picked != _selectedDate) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<Map<String, dynamic>> fetchProfitLokal(String date) async {
    try {
      final response = await http.get(
        Uri.parse('${ApiService.baseUrl}/profit_admin.php?date=$date'),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (e) {
      debugPrint("Error fetching profit data: $e");
    }
    return {};
  }

  Widget buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 20),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDF1),
        border: Border(bottom: BorderSide(width: 1, color: Color(0xFFFFCE99))),
      ),
      child: FutureBuilder<Map<String, dynamic>>(
        future: ApiService.getDashboardData(),
        builder: (context, snapshot) {

          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2,
                          color: const Color(0xFFFF9442),
                        ),
                        color: Colors.white,
                      ),
                      child: const Icon(Icons.account_circle, color: Colors.grey, size: 40),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Welcome Admin',
                            style: TextStyle(
                              color: Color(0xFF562F00),
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    String dateForApi = DateFormat('yyyy-MM-dd').format(_selectedDate);

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: fetchProfitLokal(dateForApi),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF9442)),
                  );
                }

                final data = snapshot.data ?? {};
                final List bestSelling = data['best_selling'] ?? [];
                final List daysList = data['day_names'] ??
                    ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

                List<double> points = [];
                if (data['chart_data'] != null) {
                  points = (data['chart_data'] as List)
                      .map((e) => double.tryParse(e?.toString() ?? '0') ?? 0.0)
                      .toList();
                } else {
                  points = [0.05, 0.05, 0.05, 0.05, 0.05, 0.05, 0.05];
                }

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildDateCard(),
                          IconButton(
                            icon: const Icon(
                              Icons.picture_as_pdf,
                              color: Color(0xFFC2410C),
                              size: 28,
                            ),
                            onPressed: () async {
                              try {
                                // PENJELASAN UNTUK SIDANG:
                                // Kita memanggil fungsi generateFinancialReport dari PdfService.
                                // Data-data seperti tanggal, revenue, profit, dikirimkan ke PDF generator.
                                await PdfService.generateFinancialReport(
                                  selectedDate: dateForApi,
                                  revenue: data['total_revenue']?.toString() ?? 'Rp 0',
                                  netProfit: data['net_profit']?.toString() ?? 'Rp 0',
                                  chartData: points,
                                  bestSelling: bestSelling,
                                );
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('PDF report downloaded successfully!'),
                                    ),
                                  );
                                }
                              } catch (e) {
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Failed to generate PDF: $e'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMetricCard(
                              'Todays Revenue',
                              data['total_revenue']?.toString() ?? 'Rp 0',
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _buildMetricCard(
                              'Net Profit Today',
                              data['net_profit']?.toString() ?? 'Rp 0',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 32),
                      const Text(
                        '7 Days Trend',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF562F00),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildChart(points, daysList),
                      const SizedBox(height: 32),
                      const Text(
                        'Best Selling Today',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF562F00),
                        ),
                      ),
                      const SizedBox(height: 16),
                      if (bestSelling.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Center(
                            child: Text(
                              "No menu sold today.",
                              style: TextStyle(
                                  color: Colors.grey,
                                  fontStyle: FontStyle.italic),
                            ),
                          ),
                        )
                      else
                        ...bestSelling.asMap().entries.map((e) {
                          var item = e.value;
                          return _buildBestItem(
                            e.key + 1,
                            item['name']?.toString() ?? '-',
                            int.tryParse(item['sold']?.toString() ?? '0') ?? 0,
                            item['amount']?.toString() ?? 'Rp 0',
                          );
                        }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDateCard() {
    return GestureDetector(
      onTap: () => _selectDate(context),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
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
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.calendar_month_rounded,
                color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              DateFormat('dd MMMM yyyy').format(_selectedDate),
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.keyboard_arrow_down_rounded,
                color: Colors.white, size: 18),
          ],
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(color: Colors.grey, fontSize: 11)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF562F00),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildChart(List<double> points, List<dynamic> days) {
    return Container(
      height: 230,
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFCE99)),
      ),
      child: Column(
        children: [
          Expanded(
            child: CustomPaint(
              size: Size.infinite,
              painter: _ChartPainter(points),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: days.map((day) {
              String shortDay = day.toString().substring(
                  0, day.toString().length < 3 ? day.toString().length : 3);
              return Container(
                width: 38,
                alignment: Alignment.center,
                child: Text(
                  shortDay,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: Color(0x99562F00),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBestItem(int rank, String name, int sold, String amount) {
    bool top = rank <= 3;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: top ? const Color(0xFFFFF7ED) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: top ? const Color(0xFFFF9442) : const Color(0xFFFFCE99),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor:
                top ? const Color(0xFFFF9442) : const Color(0xFFFFCE99),
            child: Text(
              '$rank',
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF562F00)),
                ),
                Text(
                  '$sold portions sold',
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            amount,
            style: const TextStyle(
                fontWeight: FontWeight.bold, color: Color(0xFFC2410C)),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDF1),
        border: Border(top: BorderSide(color: Color(0xFFFFCE99))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildNavItem("Dashboard", Icons.dashboard_outlined, false, '/dashboard')),
          Expanded(child: _buildNavItem("Orders", Icons.receipt_long_outlined, false, '/order')),
          Expanded(child: _buildNavItem("Menu", Icons.restaurant_menu_outlined, false, '/menu')),
          Expanded(child: _buildNavItem("Income", Icons.bar_chart, true, '/profit')),
          Expanded(child: _buildNavItem("Profile", Icons.person_outline, false, '/profil')),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, bool active, String route) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => active ? null : _navigateTo(route),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFFFCE99) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: const Color(0xFF562F00)),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: active ? const Color(0xFF562F00) : Colors.grey,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

// PENJELASAN UNTUK SIDANG:
// CustomPainter memungkinkan kita untuk "menggambar" bebas di atas layar, 
// seperti menggambar grafik garis lengkung (bezier curve) ini.
// Sangat berguna untuk membuat UI yang tidak disediakan oleh widget bawaan.
class _ChartPainter extends CustomPainter {
  final List<double> points;
  _ChartPainter(this.points);

  @override
  void paint(Canvas canvas, Size size) {
    if (points.isEmpty) return;

    final paintDotFill = Paint()
      ..color = const Color(0xFFFF9442)
      ..style = PaintingStyle.fill;
    final paintDotBorder = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    if (points.length == 1) {
      final coord = Offset(size.width / 2, size.height * (1 - points[0]));
      canvas.drawCircle(coord, 5, paintDotFill);
      canvas.drawCircle(coord, 5, paintDotBorder);
      return;
    }

    final double spacing = size.width / (points.length - 1);
    final List<Offset> coordinates = [];
    for (int i = 0; i < points.length; i++) {
      coordinates.add(Offset(i * spacing, size.height * (1 - points[i])));
    }

    final path = Path();
    path.moveTo(coordinates[0].dx, coordinates[0].dy);

    for (int i = 0; i < coordinates.length - 1; i++) {
      final p1 = coordinates[i];
      final p2 = coordinates[i + 1];
      final controlPoint1 = Offset(p1.dx + spacing / 2, p1.dy);
      final controlPoint2 = Offset(p2.dx - spacing / 2, p2.dy);

      path.cubicTo(controlPoint1.dx, controlPoint1.dy, controlPoint2.dx,
          controlPoint2.dy, p2.dx, p2.dy);
    }

    final fillPath = Path()..addPath(path, Offset.zero);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    final paintFill = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0x80FF9442), Color(0x00FFFDF1)],
      ).createShader(Rect.fromLTRB(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, paintFill);

    final paintStroke = Paint()
      ..color = const Color(0xFFFF9442)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;
    canvas.drawPath(path, paintStroke);

    for (var coord in coordinates) {
      canvas.drawCircle(coord, 5, paintDotFill);
      canvas.drawCircle(coord, 5, paintDotBorder);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}