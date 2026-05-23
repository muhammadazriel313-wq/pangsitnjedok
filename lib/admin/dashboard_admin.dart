import 'package:flutter/material.dart';
import '/service/api_service.dart'; 

class DashboardAdmin extends StatefulWidget {
  const DashboardAdmin({super.key});

  @override
  State<DashboardAdmin> createState() => _DashboardAdminState();
}

class _DashboardAdminState extends State<DashboardAdmin> {
  // --- VARIABEL STATE ---
  bool _isHourly = true;

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    final isPortrait = orientation == Orientation.portrait;

    // --- WIDGET HEADER ---
    Widget buildHeader() {
  return Container(
    padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 20),
    decoration: const BoxDecoration(
      color: Color(0xFFFFFDF1),
      border: Border(bottom: BorderSide(width: 1, color: Color(0xFFFFCE99))),
    ),
    child: FutureBuilder<Map<String, dynamic>>(
      future: ApiService.getDashboardData(), // Mengambil data profil dari API[cite: 15]
      builder: (context, snapshot) {
        // Ambil data dari snapshot jika tersedia
        final String adminName = snapshot.data?['name'] ?? 'Admin';

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, $adminName', // Nama admin dinamis
                      style: const TextStyle(
                        color: Color(0xFF562F00), 
                        fontSize: 16, 
                        fontWeight: FontWeight.w700, 
                        fontFamily: 'Inter'
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    ),
  );
}


    // --- WIDGET STATISTIK CHART DENGAN DATA DUMMY AESTHETIC ---
    Widget buildChartCard(Map<String, dynamic> apiData) {
      // 1. DATA DUMMY AESTHETIC (WEEKLY & MONTHLY)
      final Map<String, dynamic> weeklyStatsDummy = {
        'Mon': 0.3,
        'Tue': 0.5,
        'Wed': 0.4,
        'Thu': 0.8,
        'Fri': 0.9,
        'Sat': 1.0, // Puncak tertinggi di akhir pekan
        'Sun': 0.7,
      };

      final Map<String, dynamic> monthlyStatsDummy = {
        'W1': 0.6,
        'W2': 0.8,
        'W3': 0.5,
        'W4': 0.9, // Puncak di akhir bulan
      };

      // 2. Memilih data yang ditampilkan berdasarkan tombol switch
      final chartData = _isHourly ? weeklyStatsDummy : monthlyStatsDummy;

      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0x4CFFCE99)),
          boxShadow: const [BoxShadow(color: Color(0x0A562F00), blurRadius: 30, offset: Offset(0, 8))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Statistics',
              style: TextStyle(color: Color(0xFF562F00), fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 4),
            Text(
              _isHourly ? 'Weekly performance' : 'Monthly performance (W1-W4)',
              style: const TextStyle(color: Color(0xFF554337), fontSize: 12, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _isHourly = true),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isHourly ? const Color(0xFFF7E5DB) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Weekly',
                      style: TextStyle(color: _isHourly ? const Color(0xFF562F00) : const Color(0xFF554337), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _isHourly = false),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: !_isHourly ? const Color(0xFFF7E5DB) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Monthly',
                      style: TextStyle(color: !_isHourly ? const Color(0xFF562F00) : const Color(0xFF554337), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: chartData.entries.map((entry) {
                  // Menggunakan data dummy yang sudah berupa angka desimal yang aman
                  final double barValue = (entry.value as num).toDouble();
                  
                  return Expanded(
                    child: _buildChartBar(entry.key, barValue),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: FutureBuilder<Map<String, dynamic>>(
              future: ApiService.getDashboardData(), // Sekarang juga mengambil data statistik
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9644)));
                } else if (snapshot.hasError) {
                  return Center(child: Text("Database Error:\n${snapshot.error}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)));
                } else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  final revenue = data['revenue'] ?? 'Rp 0';
                  final newOrders = data['new_orders']?.toString() ?? '0';
                  final lowStock = data['low_stock']?.toString() ?? '0';

                  // --- SUSUNAN KONTEN PORTRAIT ---
                  final portraitContent = [
                    _buildStatCard(title: "Today's Revenue", value: revenue, badgeLabel: "LIVE UPDATE", icon: Icons.visibility_outlined),
                    const SizedBox(height: 16),
                    _buildStatCard(title: "New Orders", value: newOrders, badgeLabel: "WAITING", icon: Icons.shopping_bag_outlined),
                    const SizedBox(height: 16),
                    _buildStatCard(title: "Low Stock Items", value: lowStock, badgeLabel: "WARNING", subtitle: "Menus with < 10 stock", icon: Icons.warning_amber_rounded),
                    const SizedBox(height: 32),
                    buildChartCard(data), // Mengirim data snapshot ke diagram
                    const SizedBox(height: 32),
                    _buildActionCard(title: "Active Menu Items", subtitle: "Keep your selection fresh\nand updated.", actionText: "MANAGE MENU →", color: const Color(0xFFF7E5DB), icon: Icons.restaurant_menu, onTap: () => Navigator.pushReplacementNamed(context, '/menu')),
                    const SizedBox(height: 16),
                    _buildActionCard(title: "New Customers", subtitle: "+12 new registrations today.", actionText: "VIEW DETAILS →", color: const Color(0xFFFDEAE0), icon: Icons.people_outline, onTap: () => Navigator.pushNamed(context, '/customers')),
                  ];

                  // --- SUSUNAN KONTEN LANDSCAPE ---
                  final landscapeContent = [
                    Row(
                      children: [
                        Expanded(child: _buildStatCard(title: "Today's Revenue", value: revenue, badgeLabel: "LIVE UPDATE", icon: Icons.visibility_outlined)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard(title: "New Orders", value: newOrders, badgeLabel: "WAITING", icon: Icons.shopping_bag_outlined)),
                        const SizedBox(width: 16),
                        Expanded(child: _buildStatCard(title: "Low Stock Items", value: lowStock, badgeLabel: "WARNING", subtitle: "Menus with < 10 stock", icon: Icons.warning_amber_rounded)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: buildChartCard(data)), // Mengirim data snapshot ke diagram
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildActionCard(title: "Active Menu Items", subtitle: "Keep your selection fresh\nand updated.", actionText: "MANAGE MENU →", color: const Color(0xFFF7E5DB), icon: Icons.restaurant_menu, onTap: () => Navigator.pushReplacementNamed(context, '/menu')),
                              const SizedBox(height: 16),
                              _buildActionCard(title: "New Customers", subtitle: "+12 new registrations today.", actionText: "VIEW DETAILS →", color: const Color(0xFFFDEAE0), icon: Icons.people_outline, onTap: () => Navigator.pushNamed(context, '/customers')),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ];

                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: isPortrait ? portraitContent : landscapeContent),
                  );
                }
                return const Center(child: Text("No data available."));
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDF1),
          border: Border(top: BorderSide(width: 1, color: Color(0xFFFFCE99))),
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30), topRight: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Color(0x0C562F00), blurRadius: 10, offset: Offset(0, -4))],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildNavItem("Dashboard", Icons.dashboard_outlined, isActive: true, context: context, route: '/dashboard'),
            _buildNavItem("Orders", Icons.receipt_long_outlined, isActive: false, context: context, route: '/order'),
            _buildNavItem("Menu", Icons.restaurant_menu_outlined, isActive: false, context: context, route: '/menu'),
            _buildNavItem("Income", Icons.bar_chart_outlined, isActive: false, context: context, route: '/profit'),
            _buildNavItem("Profile", Icons.person_outline, isActive: false, context: context, route: '/profil'),
          ],
        ),
      ),
    );
  }

  // --- KOMPONEN REUSABLE (TETAP SAMA) ---
  Widget _buildStatCard({required String title, required String value, required String badgeLabel, String? subtitle, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFFFFCE99), borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 77), shape: BoxShape.circle), child: Icon(icon, color: const Color(0xFF562F00), size: 20)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6), decoration: BoxDecoration(color: const Color(0xFF562F00), borderRadius: BorderRadius.circular(20)), child: Text(badgeLabel, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Inter'))),
        ]),
        const SizedBox(height: 20),
        Text(title, style: const TextStyle(color: Color(0xB2562F00), fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Color(0xFF562F00), fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'Inter')),
        if (subtitle != null) ...[const SizedBox(height: 4), Text(subtitle, style: const TextStyle(color: Color(0x99562F00), fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter'))]
      ]),
    );
  }

  Widget _buildActionCard({required String title, required String subtitle, required String actionText, required Color color, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0x33FFCE99))),
        child: Row(children: [
          Container(width: 60, height: 60, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)), child: Icon(icon, color: const Color(0xFFFF9644), size: 30)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(color: Color(0xFF562F00), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Color(0xFF554337), fontSize: 12, fontFamily: 'Inter')),
            const SizedBox(height: 12),
            Text(actionText, style: const TextStyle(color: Color(0xFFFF9644), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1, fontFamily: 'Inter')),
          ])),
        ]),
      ),
    );
  }

  Widget _buildChartBar(String label, double percentage) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      // Flexible membantu batang menyesuaikan ruang yang tersedia
      Flexible(
        child: TweenAnimationBuilder<double>(
          tween: Tween<double>(begin: 0, end: percentage),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (context, value, child) {
            return FractionallySizedBox(
              // Gunakan clamp agar minimal ada sedikit batang yang terlihat (5%)
              heightFactor: value.clamp(0.05, 1.0), 
              child: Container(
                width: 25, // Tentukan lebar batang yang pasti
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9644), 
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8), 
                    topRight: Radius.circular(8),
                  ),
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: 8),
      Text(
        label, 
        style: const TextStyle(
          color: Color(0xFF554337), 
          fontSize: 10, 
          fontWeight: FontWeight.bold, 
          fontFamily: 'Inter',
        ),
      ),
    ],
  );
}

  Widget _buildNavItem(String label, IconData icon, {required bool isActive, required BuildContext context, required String route}) {
    return GestureDetector(
      onTap: () { if (!isActive) Navigator.pushReplacementNamed(context, route); },
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Container(padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 8, vertical: 8), decoration: BoxDecoration(color: isActive ? const Color(0xFFFFCE99) : Colors.transparent, borderRadius: BorderRadius.circular(20)), child: Icon(icon, color: isActive ? const Color(0xFF562F00) : const Color(0x99562F00), size: 24)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: isActive ? const Color(0xFF562F00) : const Color(0x99562F00), fontSize: 10, fontWeight: isActive ? FontWeight.w700 : FontWeight.w500, fontFamily: 'Inter')),
      ]),
    );
  }
  
}