import 'package:flutter/material.dart';
import '/service/api_service.dart';
import 'edit_profil.dart'; // Pastikan import ini ada
import '../halaman_login.dart'; // Import halaman login untuk rute logout

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
    // Mengambil data profil saat inisialisasi
    _profilFuture = ApiService.getAdminProfil(); 
  }

  // Fungsi untuk merefresh data setelah kembali dari halaman edit
  void _refreshData() {
    setState(() {
      // Memicu FutureBuilder untuk mengambil data terbaru dari database
      _profilFuture = ApiService.getAdminProfil(); 
    });
  }

  // Menampilkan Dialog Konfirmasi Logout
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text(
            "Konfirmasi Logout", 
            style: TextStyle(color: Color(0xFF562F00), fontWeight: FontWeight.bold)
          ),
          content: const Text("Apakah Anda yakin ingin keluar dari akun ini?"),
          actions: [
            TextButton(
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: const Text("Logout", style: TextStyle(color: Colors.red)),
              onPressed: () {
                // Hapus semua riwayat routing agar tidak bisa klik 'Back' ke profil
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const HalamanLogin()),
                  (Route<dynamic> route) => false, 
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1), // Latar belakang krem muda
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFF7ED),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFC2410C)),
          onPressed: () => Navigator.pushReplacementNamed(context, '/dashboard'), // Kembali ke dashboard
        ),
        title: const Text(
          'Admin Profile',
          style: TextStyle(color: Color(0xFFC2410C), fontSize: 20, fontWeight: FontWeight.bold),
        ),
        actions: [
          // TOMBOL LOGOUT BARU
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: Color(0xFFC2410C)),
            onPressed: () => _showLogoutDialog(context),
            tooltip: 'Logout',
          ),
          const SizedBox(width: 8), // Sedikit jarak agar tidak terlalu mepet kanan
        ],
      ),
      body: FutureBuilder<Map<String, dynamic>?>(
        future: _profilFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442))); // Indikator loading
          }
          
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text("Gagal memuat profil admin")); // Penanganan error data
          }

          final data = snapshot.data!; // Mengambil data hasil response API

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
                      // Menggunakan NetworkImage agar foto profil berubah sesuai database
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: const Color(0xFFFFEEDD),
                        backgroundImage: (data['image_url'] != null && data['image_url'].toString().isNotEmpty)
                            ? NetworkImage("${ApiService.baseUrl}/uploads/${data['image_url']}") // Foto dari server
                            : const AssetImage("assets/images/Dimas oi oi.jpeg") as ImageProvider, // Foto default
                      ),
                      const SizedBox(height: 16),
                      Text(
                        data['name'] ?? 'Admin', // Menampilkan nama admin
                        style: const TextStyle(color: Color(0xFF562F00), fontSize: 22, fontWeight: FontWeight.w800),
                      ),
                      Text(
                        "@${data['username'] ?? 'admin'}", // Menampilkan username
                        style: const TextStyle(color: Color(0xFFFF9442), fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 24),
                      
                      // Tombol Edit Profile dengan logika refresh otomatis
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditProfil(
                                initialData: {
                                  'name': data['name']?.toString() ?? '',
                                  'username': data['username']?.toString() ?? '',
                                  'phone': data['no_telepon']?.toString() ?? data['phone']?.toString() ?? '',
                                  'email': data['email']?.toString() ?? '',
                                  'image_url': data['image_url']?.toString() ?? '', // Mengirim URL gambar saat ini
                                },
                              ),
                            ),
                          );
                          // Jika kembali membawa nilai true, lakukan refresh data
                          if (result == true) {
                            _refreshData();
                          }
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
      bottomNavigationBar: _buildBottomNav(), // Navigasi bawah
    );
  }

  // Widget baris informasi profil
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

  // Widget Navigasi Bawah
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
          _buildNavItem("Income", Icons.bar_chart_outlined, false, '/profit'),
          _buildNavItem("Profile", Icons.person, true, '/profil'),
        ],
      ),
    );
  }

  // Widget Item Navigasi
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
