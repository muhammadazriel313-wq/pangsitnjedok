import 'package:flutter/material.dart';
import '/service/api_service.dart';

class ManageCustomers extends StatefulWidget {
  const ManageCustomers({super.key});

  @override
  State<ManageCustomers> createState() => _ManageCustomersState();
}

class _ManageCustomersState extends State<ManageCustomers> {
  late Future<List<dynamic>> _customersFuture;

  @override
  void initState() {
    super.initState();
    _customersFuture = ApiService.getCustomers();
  }

  // 1. Fungsi Navigasi Standar (Tanpa Smooth Transition)
  void _navigateTo(String route) {
    Navigator.pushReplacementNamed(context, route);
  }

  // 2. Fungsi Logika Hapus Pelanggan
  void _deleteCustomer(String id, String name) async {
    // Memanggil ApiService yang sudah kita buat sebelumnya
    bool success = await ApiService.deleteCustomer(id);

    if (success) {
      setState(() {
        _customersFuture =
            ApiService.getCustomers(); // Memicu FutureBuilder untuk refresh data otomatis
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer $name has been deleted'),
          backgroundColor: Colors.green,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete customer. Check database connection.'),
          backgroundColor: Colors.red,
        ),
      );
    }
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
          onPressed: () => _navigateTo('/dashboard'),
        ),
        title: const Text(
          'Manage Customers',
          style: TextStyle(
            color: Color(0xFFC2410C),
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _customersFuture, // Mengambil data dari tabel customer
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9442)),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No customer data yet"));
          }

          final customers = snapshot.data!;

          return Column(
            children: [
              // Header Statistik (Warna Cokelat Gelap)
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFF562F00),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Registered Customers',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),
                      Text(
                        '${customers.length} People',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // List View Pelanggan
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: customers.length,
                  itemBuilder: (context, index) {
                    final item = customers[index];
                    return _customerItemCard(
                      item['id'].toString(),
                      item['customer_name'] ?? 'No Name',
                      item['no_telepon'] ?? '-',
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // 3. Widget Card Pelanggan (Ikon Hapus di Kanan)
  Widget _customerItemCard(String id, String name, String phone) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFCE99)),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFFFFCE99),
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                color: Color(0xFF562F00),
                fontWeight: FontWeight.bold,
              ),
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
                    fontSize: 16,
                  ),
                ),
                Text(
                  phone,
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          // Ikon Hapus dengan Konfirmasi AwesomeDialog
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: () {
              // Menampilkan Pop-up Kotak Sederhana di Tengah
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    title: const Text("Delete Customer"),
                    content: Text("Are you sure you want to delete $name?"),
                    actions: [
                      TextButton(
                        child: const Text(
                          "Cancel",
                          style: TextStyle(color: Colors.grey),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      TextButton(
                        child: const Text(
                          "Delete",
                          style: TextStyle(color: Colors.red),
                        ),
                        onPressed: () {
                          Navigator.pop(context); // Tutup dialog
                          _deleteCustomer(id, name); // Jalankan fungsi hapus
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  // 4. Widget Bottom Navigation Bar (Statis/Manual)
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
          _navItem("Dashboard", Icons.dashboard_outlined, false, '/dashboard'),
          _navItem("Orders", Icons.receipt_long_outlined, false, '/orders'),
          _navItem("Menu", Icons.restaurant_menu_outlined, false, '/menu'),
          _navItem("Income", Icons.bar_chart_outlined, false, '/profit'),
          _navItem("Profile", Icons.person_outline, false, '/profil'),
        ],
      ),
    );
  }

  Widget _navItem(String label, IconData icon, bool active, String route) {
    return GestureDetector(
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
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
