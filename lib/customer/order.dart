import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

// ✅ IMPORT SEMUA HALAMAN BIAR NAVIGASI NYAMBUNG
import 'dashboard_menu.dart';
import 'halaman_menu.dart';
import 'cart.dart';
import 'profil_customer.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  bool isActiveTab = true;
  bool _isLoading = true;
  
  List<dynamic> activeOrders = [];
  List<dynamic> historyOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  // ✅ FUNGSI TARIK DATA PESANAN DARI DATABASE XAMPP
  Future<void> _fetchOrders() async {
    setState(() => _isLoading = true);
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String userId = prefs.getString('id') ?? "1"; 

      final response = await http.get(
        Uri.parse("http://localhost/pangsit_njedok_api/get_customer_orders.php?customer_id=$userId")
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (mounted) {
          setState(() {
            activeOrders = data['active'] ?? [];
            historyOrders = data['history'] ?? [];
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      print("Error koneksi order: $e");
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage())),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.arrow_back, color: Color(0xFF954A00)),
          ),
        ),
        title: const Text('My Orders', style: TextStyle(color: Color(0xFF1B1C15), fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(color: const Color(0xFFF6F4E8), borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton('Active', isActiveTab, () => setState(() => isActiveTab = true))),
                  Expanded(child: _buildTabButton('History', !isActiveTab, () => setState(() => isActiveTab = false))),
                ],
              ),
            ),
          ),
          
          Expanded(
            child: RefreshIndicator(
              onRefresh: _fetchOrders,
              color: const Color(0xFFFF9442),
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442)))
                : SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(24),
                    child: isActiveTab ? _buildActiveContent() : _buildHistoryContent(),
                  ),
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent, borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] : [],
        ),
        child: Text(
          title, textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.bold, color: isSelected ? const Color(0xFF954A00) : const Color(0xFF554337)),
        ),
      ),
    );
  }

  Widget _buildActiveContent() {
    if (activeOrders.isEmpty) {
      return Column(
        children: [
          const SizedBox(height: 40),
          const Icon(Icons.receipt_long, size: 60, color: Colors.grey),
          const SizedBox(height: 16),
          const Text("Belum ada pesanan aktif nih.", style: TextStyle(color: Colors.grey, fontSize: 16)),
          const SizedBox(height: 40),
          _buildCravingBanner(),
        ],
      );
    }

    return Column(
      children: [
        ...activeOrders.map((order) {
          // Logika Penyesuaian Status Database dengan Tampilan UI
          String uiStatus = order['status'] == 'Menunggu' ? 'Waiting\nConfirmation' : 'Processing';
          Color uiColor = order['status'] == 'Menunggu' ? const Color(0xFF7B572C) : const Color(0xFFFF9442);
          
          // Logika Teks Bawah (Bottom Info)
          Widget bottomInfo = order['status'] == 'Menunggu'
              ? const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline, size: 18, color: Color(0xFF954A00)), SizedBox(width: 12),
                    Expanded(child: Text('Pesananmu sedang direview oleh Chef kami. Sabar ya komandan!', style: TextStyle(fontSize: 11, color: Color(0xFF554337), height: 1.5))),
                  ],
                )
              : const Row(
                  children: [
                    Icon(Icons.access_time, size: 16, color: Color(0xFF554337)), SizedBox(width: 8),
                    Text('Est. Completion', style: TextStyle(fontSize: 12, color: Color(0xFF554337))), Spacer(),
                    Text('Sedang Dimasak 🍳', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFFFF9442))),
                  ],
                );

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildActiveOrderCard(
              queueNumber: order['id']?.toString() ?? 'A-00', // Pakai ID Order sebagai antrian
              status: uiStatus, 
              statusColor: uiColor,
              itemName: order['items'] ?? 'Paket Pangsit Njedok', 
              itemImage: 'assets/images/esbuahleci.jpg', // Default image sementara
              price: 'Rp ${order['total_price'] ?? '0'}',
              paymentStatus: order['payment_method'] == 'cash' ? 'PAY AT CASHIER' : 'PAID', 
              details: order['order_type'] == 'dine_in' ? 'Makan di Tempat' : 'Bungkus',
              bottomInfo: bottomInfo,
            ),
          );
        }),
        const SizedBox(height: 24),
        _buildCravingBanner(),
        const SizedBox(height: 80), 
      ],
    );
  }

  Widget _buildHistoryContent() {
    if (historyOrders.isEmpty) {
      return const Column(
        children: [
          SizedBox(height: 60),
          Icon(Icons.history, size: 60, color: Colors.grey),
          SizedBox(height: 16),
          Text("Belum ada riwayat pesanan.", style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      );
    }

    return Column(
      children: [
        ...historyOrders.map((order) {
          bool isCancelled = order['status'] == 'Dibatalkan';
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildHistoryCard(
              '#${order['id']}', 
              order['status'].toString().toUpperCase(), 
              'Rp ${order['total_price']}', 
              order['items'] ?? 'Menu Pangsit Njedok', 
              isCancelled ? Colors.red.shade100 : const Color(0xFFFFCF9A),
              isCancelled: isCancelled,
            ),
          );
        }),
        const SizedBox(height: 16),
        const Icon(Icons.restaurant, color: Color(0xFFEAE8DD), size: 40),
        const Text("End of Records", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF554337))),
        const Text("Showing history from the last 90 days", style: TextStyle(color: Colors.grey, fontSize: 12)),
        const SizedBox(height: 80),
      ],
    );
  }

  Widget _buildActiveOrderCard({
    required String queueNumber, required String status, required Color statusColor,
    required String itemName, required String itemImage, required String price,
    required String paymentStatus, required String details, required Widget bottomInfo,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('ORDER NUMBER', style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
                  Text('#$queueNumber', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Color(0xFF562F00))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: statusColor.withOpacity(0.5))),
                child: Text(status, textAlign: TextAlign.center, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(itemImage, width: 64, height: 64, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 64, height: 64, color: Colors.grey[200], child: const Icon(Icons.fastfood, color: Colors.grey))),
              ),
              const SizedBox(width: 16),
              Expanded( 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(itemName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                    const SizedBox(height: 4),
                    Text(details, style: const TextStyle(fontSize: 12, color: Colors.grey), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF954A00))),
                  const SizedBox(height: 4),
                  Text(paymentStatus, style: const TextStyle(fontSize: 8, color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Divider(color: Color(0xFFF6F4E8), thickness: 1.5),
          ),
          bottomInfo
        ],
      ),
    );
  }

  Widget _buildHistoryCard(String id, String status, String price, String items, Color labelColor, {bool isCancelled = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)), const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: labelColor, borderRadius: BorderRadius.circular(6)),
                    child: Text(status, style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: isCancelled ? Colors.red : const Color(0xFF954A00))),
                  ),
                ],
              ),
              Text(price, style: TextStyle(fontWeight: FontWeight.bold, color: isCancelled ? Colors.grey : const Color(0xFF954A00), decoration: isCancelled ? TextDecoration.lineThrough : TextDecoration.none)),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity, padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF6F4E8), borderRadius: BorderRadius.circular(12)),
            child: Text(items, style: const TextStyle(fontSize: 13, color: Color(0xFF554337))),
          ),
        ],
      ),
    );
  }

  Widget _buildCravingBanner() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: const Color(0xFF954A00), borderRadius: BorderRadius.circular(30)),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Craving\nMore?', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1)),
              const SizedBox(height: 10),
              Text('Add a side of Fried Siomay while you wait for your main course.', style: TextStyle(color: Colors.white70, fontSize: 13)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MenuFoodScreen())),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF954A00), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                child: const Text('ORDER LAGI', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          Positioned(right: -10, bottom: -10, child: Icon(Icons.restaurant, size: 80, color: Colors.white.withOpacity(0.1)))
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.white, shape: const CircularNotchedRectangle(), notchMargin: 8.0, elevation: 10,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(Icons.home_outlined, 'Home', context.widget is DashboardPage, () { if (context.widget is! DashboardPage) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const DashboardPage())); }),
            _buildNavItem(Icons.restaurant_menu, 'Menu', context.widget is MenuFoodScreen, () { if (context.widget is! MenuFoodScreen) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MenuFoodScreen())); }),
            const SizedBox(width: 48), 
            _buildNavItem(Icons.receipt_long_outlined, 'Order', true, () {}),
            _buildNavItem(Icons.person_outline, 'Profil', context.widget is ProfilePage, () { if (context.widget is! ProfilePage) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const ProfilePage())); }),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return InkWell( 
      onTap: onTap, borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8)),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(color: isActive ? const Color(0xFFFF9442) : const Color(0xFF94A3B8), fontSize: 10, fontWeight: isActive ? FontWeight.bold : FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFFFF9442).withOpacity(0.4), blurRadius: 12, spreadRadius: 2)]),
      child: FloatingActionButton(
        onPressed: () { if (context.widget is! CartPage) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const CartPage())); },
        backgroundColor: const Color(0xFFFF9442), elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(color: Colors.white, width: 4)),
        child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
      ),
    );
  }
}