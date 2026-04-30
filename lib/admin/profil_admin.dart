import 'package:flutter/material.dart';
import '/service/api_service.dart';
import 'edit_profil.dart'; // Pastikan import ini ada

class ProfilReportAdmin extends StatefulWidget {
  const ProfilReportAdmin({super.key});

  @override
  State<ProfilReportAdmin> createState() => _ProfilReportAdminState();
}

class _ProfilReportAdminState extends State<ProfilReportAdmin> {
  // Variabel untuk menampung Future data profil
  late Future<Map<String, dynamic>?> _profilFuture;

  @override
  void initState() {
    super.initState();
    _profilFuture = ApiService.getAdminProfil();
  }

  // Fungsi untuk merefresh data setelah edit
  void _refreshData() {
    setState(() {
      _profilFuture = ApiService.getAdminProfil();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7ED),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFC2410C)),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'),
        ),
        title: const Text(
          'Admin Profile',
          style: TextStyle(color: Color(0xFFC2410C), fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profilFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442)));
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat profil admin"));
          }

          final data = snapshot.data!;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // Card Profil Utama
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: const [BoxShadow(color: Color(0x0A562F00), blurRadius: 40, offset: Offset(0, 10))],
                  ),
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFFFFEEDD),
                        backgroundImage: AssetImage("assets/images/Dimas oi oi.jpeg"),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['name'] ?? 'Admin',
                        style: const TextStyle(color: Color(0xFF562F00), fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "@${data['username'] ?? 'admin'}",
                        style: const TextStyle(color: Color(0xFFFF9442), fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),
                      
                      // Tombol Edit Profile (LOGIKA DIPERBAIKI DISINI)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfil(
                                // Pastikan data dikonversi ke Map<String, String> agar sinkron
                                initialData: {
                                  'name': data['name']?.toString() ?? '',
                                  'username': data['username']?.toString() ?? '',
                                  'phone': data['no_telepon']?.toString() ?? data['phone']?.toString() ?? '',
                                  'email': data['email']?.toString() ?? '',
                                },
                              ),
                            ),
                          ).then((value) {
                            if (value == true) _refreshData();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF562F00),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                        ),
                        child: const Text('Edit Profile', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Card Detail Info
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
                  child: Column(
                    children: [
                      _buildInfoRow(Icons.person_outline, "Full Name", data['name'] ?? '-'),
                      const Divider(height: 32),
                      _buildInfoRow(Icons.phone_android_outlined, "Phone Number", data['no_telepon'] ?? data['phone'] ?? '-'),
                      const Divider(height: 32),
                      _buildInfoRow(Icons.email_outlined, "Email Address", data['email'] ?? '-'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFFFF9442), size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            Text(value, style: const TextStyle(color: Color(0xFF562F00), fontSize: 16, fontWeight: FontWeight.w600)),
          ],
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDF1),
        border: Border(top: BorderSide(width: 1, color: Color(0xFFFFCE99))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem("Dashboard", Icons.dashboard_outlined, false, '/dashboard'),
          _buildNavItem("Orders", Icons.receipt_long_outlined, false, '/order'),
          _buildNavItem("Menu", Icons.restaurant_menu_outlined, false, '/menu'),
          _buildNavItem("Profit", Icons.bar_chart_outlined, false, '/profit'),
          _buildNavItem("Profile", Icons.person, true, '/profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, bool isActive, String route) {
    return GestureDetector(
      onTap: () { if (!isActive) Navigator.pushReplacementNamed(context, route); },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFFCE99) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(icon, color: const Color(0xFF562F00), size: 24),
          ),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFF562F00) : Colors.grey, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}