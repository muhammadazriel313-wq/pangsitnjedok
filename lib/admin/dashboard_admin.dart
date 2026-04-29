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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(width: 2, color: const Color(0xFFFF9442)),
                    image: const DecorationImage(
                      image: AssetImage("assets/images/Dimas oi oi.jpeg"),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome, Dimas',
                      style: TextStyle(color: Color(0xFF562F00), fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
                    ),
                    Text(
                      'April 26, 2026',
                      style: TextStyle(color: Color(0xB2554337), fontSize: 12, fontWeight: FontWeight.w500, fontFamily: 'Inter'),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      );
    }

    // --- WIDGET STATISTIK CHART (GRAFIK) ---
    Widget buildChartCard() {
      final chartData = _isHourly
          ? {'10:00': 0.2, '12:00': 0.8, '14:00': 0.6, '16:00': 0.4, '18:00': 0.9, '20:00': 1.0}
          : {'Mon': 0.5, 'Tue': 0.7, 'Wed': 0.4, 'Thu': 0.9, 'Fri': 0.6, 'Sat': 1.0};

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
              'Daily Order Statistics',
              style: TextStyle(color: Color(0xFF562F00), fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 4),
            Text(
              _isHourly ? 'Hourly performance breakdown' : 'Weekly performance breakdown',
              style: const TextStyle(color: Color(0xFF554337), fontSize: 12, fontFamily: 'Inter'),
            ),
            const SizedBox(height: 16),

            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() { _isHourly = true; }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: _isHourly ? const Color(0xFFF7E5DB) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Hourly',
                      style: TextStyle(color: _isHourly ? const Color(0xFF562F00) : const Color(0xFF554337), fontSize: 12, fontWeight: FontWeight.bold, fontFamily: 'Inter'),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() { _isHourly = false; }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: !_isHourly ? const Color(0xFFF7E5DB) : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Daily',
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
                children: chartData.entries.map((entry) => _buildChartBar(entry.key, entry.value)).toList(),
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
            // ==============================================================
            // FUTURE BUILDER: MENGAMBIL DATA DARI XAMPP (API SERVICE)
            // ==============================================================
            child: FutureBuilder<Map<String, dynamic>>(
              future: ApiService.getDashboardData(),
              builder: (context, snapshot) {
                // 1. Sedang Loading
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9644)));
                } 
                // 2. Terjadi Error (XAMPP mati atau alamat salah)
                else if (snapshot.hasError) {
                  return Center(
                    child: Text("Error Database:\n${snapshot.error}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                  );
                } 
                // 3. Data Berhasil Diambil
                else if (snapshot.hasData) {
                  final data = snapshot.data!;
                  
                  // Menarik data live dari database XAMPP
                  final revenue = data['revenue'] ?? 'Rp 0';
                  final newOrders = data['new_orders']?.toString() ?? '0';
                  final lowStock = data['low_stock']?.toString() ?? '0';

                  // --- SUSUNAN KONTEN PORTRAIT (LIVE DATA) ---
                  final portraitContent = [
                    _buildStatCard(title: "Today's Revenue", value: revenue, badgeLabel: "LIVE UPDATE", icon: Icons.visibility_outlined),
                    const SizedBox(height: 16),
                    _buildStatCard(title: "New Orders", value: newOrders, badgeLabel: "WAITING", icon: Icons.shopping_bag_outlined),
                    const SizedBox(height: 16),
                    _buildStatCard(title: "Low Stock Items", value: lowStock, badgeLabel: "WARNING", subtitle: "Menus with < 10 stock", icon: Icons.warning_amber_rounded),
                    const SizedBox(height: 32),
                    buildChartCard(),
                    const SizedBox(height: 32),
                    _buildActionCard(
                      title: "Active Menu Items", subtitle: "Keep your selection fresh\nand updated.", actionText: "MANAGE MENU →", color: const Color(0xFFF7E5DB), icon: Icons.restaurant_menu,
                      onTap: () => Navigator.pushReplacementNamed(context, '/menu'),
                    ),
                    const SizedBox(height: 16),
                    _buildActionCard(
                      title: "New Customers", subtitle: "+12 new registrations today.", actionText: "VIEW DETAILS →", color: const Color(0xFFFDEAE0), icon: Icons.people_outline,
                      onTap: () => Navigator.pushNamed(context, '/customers'),
                    ),
                  ];

                  // --- SUSUNAN KONTEN LANDSCAPE (LIVE DATA) ---
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
                        Expanded(flex: 3, child: buildChartCard()),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: Column(
                            children: [
                              _buildActionCard(
                                title: "Active Menu Items", subtitle: "Keep your selection fresh\nand updated.", actionText: "MANAGE MENU →", color: const Color(0xFFF7E5DB), icon: Icons.restaurant_menu,
                                onTap: () => Navigator.pushReplacementNamed(context, '/menu'),
                              ),
                              const SizedBox(height: 16),
                              _buildActionCard(
                                title: "New Customers", subtitle: "+12 new registrations today.", actionText: "VIEW DETAILS →", color: const Color(0xFFFDEAE0), icon: Icons.people_outline,
                                onTap: () => Navigator.pushNamed(context, '/customers'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ];

                  // Return Hasil Akhir UI
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: isPortrait ? portraitContent : landscapeContent,
                    ),
                  );
                }

                // Fallback jika anehnya data kosong
                return const Center(child: Text("Tidak ada data."));
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
            _buildNavItem("Profit", Icons.bar_chart_outlined, isActive: false, context: context, route: '/profit'),
            _buildNavItem("Profile", Icons.person_outline, isActive: false, context: context, route: '/profil'),
          ],
        ),
      ),
    );
  }

  // --- KOMPONEN REUSABLE ---

  Widget _buildStatCard({required String title, required String value, required String badgeLabel, String? subtitle, required IconData icon}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFFFCE99),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Color(0x0C000000), blurRadius: 2, offset: Offset(0, 1))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.white.withOpacity(0.3), shape: BoxShape.circle),
                child: Icon(icon, color: const Color(0xFF562F00), size: 20),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFF562F00), borderRadius: BorderRadius.circular(20)),
                child: Text(badgeLabel, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(color: Color(0xB2562F00), fontSize: 14, fontWeight: FontWeight.w500, fontFamily: 'Inter')),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(color: Color(0xFF562F00), fontSize: 24, fontWeight: FontWeight.w900, fontFamily: 'Inter')),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Color(0x99562F00), fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Inter')),
          ]
        ],
      ),
    );
  }

  Widget _buildActionCard({required String title, required String subtitle, required String actionText, required Color color, required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24), border: Border.all(color: const Color(0x33FFCE99))),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Icon(icon, color: const Color(0xFFFF9644), size: 30),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(color: Color(0xFF562F00), fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                  const SizedBox(height: 4),
                  Text(subtitle, style: const TextStyle(color: Color(0xFF554337), fontSize: 12, fontFamily: 'Inter')),
                  const SizedBox(height: 12),
                  Text(actionText, style: const TextStyle(color: Color(0xFFFF9644), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1, fontFamily: 'Inter')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartBar(String label, double percentage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: percentage),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, child) {
              return FractionallySizedBox(
                heightFactor: value,
                child: Container(
                  width: 32,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFF9644),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Color(0xFF554337), fontSize: 10, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
      ],
    );
  }

  Widget _buildNavItem(String label, IconData icon, {required bool isActive, required BuildContext context, required String route}) {
    return GestureDetector(
      onTap: () {
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route); 
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: isActive ? 16 : 8, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFFCE99) : Colors.transparent, 
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: isActive ? const Color(0xFF562F00) : const Color(0x99562F00), size: 24),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isActive ? const Color(0xFF562F00) : const Color(0x99562F00),
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
              fontFamily: 'Inter'
            ),
          ),
        ],
      ),
    );
  }
}