import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
import '../service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  bool isActiveTab = true; // Tab aktif milikmu
  bool _isLoading = true;
  List<dynamic> _orders = [];
  String _customerName = "";
  String _customerPhone = "";
  
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _fetchCustomerDataAndOrders();
    // Refresh otomatis setiap 3 detik di belakang layar tanpa merusak UI customer
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      if (mounted) {
        _fetchOrdersOnly(); 
      }
    });
  }

  Future<void> _fetchCustomerDataAndOrders() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final customerId = prefs.getString('customer_id') ?? "1"; // Ambil ID customer dari session HP
      final profile = await ApiService.getProfile(customerId);
      if (profile['status'] == 'success' && profile['data'] is Map) {
        final data = Map<String, dynamic>.from(profile['data'] as Map);
        _customerName = (data['name'] ?? 'Customer').toString();
        _customerPhone = (data['no_telepon'] ?? '-').toString();
      }
      await _fetchOrdersOnly();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _fetchOrdersOnly() async {
    try {
      final orders = await ApiService.getCustomerOrders(
        phoneNumber: _customerPhone,
        customerName: _customerName,
      );
      if (mounted) {
        setState(() {
          _orders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
    }
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      child: Column(
        children: [
          const Icon(Icons.receipt_long_outlined, color: Color(0x66562F00), size: 48),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(
              color: Color(0x66562F00),
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  String _getProductImage(String productName) {
    final nameLower = productName.toLowerCase();
    if (nameLower.contains('tulang rangu') || nameLower.contains('rangu')) {
      return 'assets/images/pangsittulangrangu.jpg';
    } else if (nameLower.contains('goreng')) {
      return 'assets/images/pangsitgoreng.jpg';
    } else if (nameLower.contains('wonton') || nameLower.contains('chili')) {
      return 'assets/images/wontonchilioil.jpg';
    } else if (nameLower.contains('mentai')) {
      return 'assets/images/wontonmentai.jpg';
    } else if (nameLower.contains('mietiaw') || nameLower.contains('mietieaw') || nameLower.contains('tiaw')) {
      return 'assets/images/mietieawchilioil.jpg';
    } else if (nameLower.contains('siomay')) {
      return 'assets/images/siomay.jpg';
    } else if (nameLower.contains('oseng')) {
      return 'assets/images/osengpangsit.jpg';
    } else if (nameLower.contains('es') || nameLower.contains('leci') || nameLower.contains('buah') || nameLower.contains('teh') || nameLower.contains('lemon') || nameLower.contains('jeruk') || nameLower.contains('sbuah')) {
      return 'assets/images/esbuahleci.jpg';
    }
    return 'assets/images/logopangsitnjedok.png';
  }

  @override
  void dispose() {
    // Matikan timer saat pindah halaman agar aplikasi tidak berat/error
    _timer?.cancel(); 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFDF1), Color(0xFFFFE8D6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                leading: GestureDetector(
                  onTap: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    } else {
                      Navigator.pushReplacementNamed(context, '/dashboard_menu');
                    }
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(12.0), // Berikan sedikit padding agar lebih mudah diklik
                    child: Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF954A00)),
                  ),
                ),
                title: const Text(
                  'My Orders',
                  style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
          const SizedBox(height: 10),
          // --- Tombol Switch Active & History ---
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F4E8),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(child: _buildTabButton('Active', isActiveTab, () => setState(() => isActiveTab = true))),
                  Expanded(child: _buildTabButton('History', !isActiveTab, () => setState(() => isActiveTab = false))),
                ],
              ),
            ),
          ),

          // --- Konten Berdasarkan Tab yang Dipilih ---
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: isActiveTab ? _buildActiveContent() : _buildHistoryContent(),
            ),
          ),
        ],
      ),
      ),
      ),
      // --- Bottom Navigation Bar ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF9442).withValues(alpha: 0.4),
              blurRadius: 12,
              spreadRadius: 2,
            )
          ]
        ),
        child: FloatingActionButton(
          backgroundColor: const Color(0xFFFF9442),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
            side: const BorderSide(color: Colors.white, width: 4)
          ),
          onPressed: () => Navigator.pushNamed(context, '/cart'),
          child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
        ),
      ),
      bottomNavigationBar: buildBottomNavbar(context, '/order_customer'),
    );
  }

  // --- WIDGET HELPERS ---

  Widget _buildTabButton(String title, bool isSelected, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isSelected ? [const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))] : [],
        ),
        child: Text(
          title,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: isSelected ? const Color(0xFF954A00) : const Color(0xFF554337),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveContent() {
    final activeOrders = _orders.where((o) {
      final status = (o['status'] ?? '').toString().toUpperCase();
      return status == 'WAITING' || status == 'PROCESSING';
    }).toList();

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(color: Color(0xFFFF9442)),
        ),
      );
    }

    if (activeOrders.isEmpty) {
      return _buildEmptyState("No active orders");
    }

    return Column(
      children: [
        ...activeOrders.map((order) {
          List<dynamic> itemsRaw = [];
          try {
            itemsRaw = json.decode(order['items_raw']);
          } catch (e) {
            itemsRaw = [];
          }

          String itemName = "Pangsit Njedog Order";
          String details = "Total: ${itemsRaw.length} item";
          if (itemsRaw.isNotEmpty) {
            itemName = itemsRaw[0]['menu_id'] ?? itemsRaw[0]['name'] ?? 'Pangsit';
            details = itemsRaw.map((i) => "${i['qty']}x ${i['menu_id'] ?? i['name'] ?? 'Pangsit'}").join(" • ");
          }

          final status = (order['status'] ?? '').toString();
          final String queueNo = (order['id'] ?? '').toString().length > 5 
              ? (order['id'] ?? '').toString().substring((order['id'] ?? '').toString().length - 5) 
              : (order['id'] ?? '').toString();

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildActiveOrderCard(
              queueNumber: queueNo,
              status: status,
              statusColor: status.toUpperCase() == 'PROCESSING' ? const Color(0xFFFF9442) : const Color(0xFF7B572C),
              itemName: itemName,
              itemImage: _getProductImage(itemName),
              price: '${order['totalAmount']}',
              paymentStatus: status.toUpperCase() == 'PROCESSING' ? 'PAID' : 'WAITING CONFIRMATION',
              details: details,
              bottomInfo: Row(
                children: [
                  const Icon(Icons.access_time, size: 16, color: Color(0xFF554337)),
                  const SizedBox(width: 8),
                  const Text('Status', style: TextStyle(fontSize: 12, color: Color(0xFF554337))),
                  const Spacer(),
                  Text(
                    status.toUpperCase() == 'PROCESSING' ? 'Processing' : 'Waiting Confirmation',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
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
    final historyOrders = _orders.where((o) {
      final status = (o['status'] ?? '').toString().toUpperCase();
      return status == 'COMPLETED' || status == 'CANCELLED';
    }).toList();

    if (_isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(40.0),
          child: CircularProgressIndicator(color: Color(0xFFFF9442)),
        ),
      );
    }

    if (historyOrders.isEmpty) {
      return _buildEmptyState("No history records");
    }

    return Column(
      children: [
        ...historyOrders.map((order) {
          List<dynamic> itemsRaw = [];
          try {
            itemsRaw = json.decode(order['items_raw']);
          } catch (e) {
            itemsRaw = [];
          }

          String itemsSummary = "Order details empty";
          if (itemsRaw.isNotEmpty) {
            itemsSummary = itemsRaw.map((i) => "${i['qty']}x ${i['menu_id'] ?? i['name'] ?? 'Pangsit'}").join(", ");
          }

          final status = (order['status'] ?? '').toString().toUpperCase();
          final isCancelled = status == 'CANCELLED';
          final labelColor = isCancelled ? Colors.red[100]! : const Color(0xFFFFCF9A);

          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildHistoryCard(
              '#${order['id']}',
              status,
              '${order['totalAmount']}',
              itemsSummary,
              labelColor,
              isCancelled: isCancelled,
            ),
          );
        }),
        const SizedBox(height: 16),
        const Icon(Icons.restaurant, color: Color(0xFFEAE8DD), size: 40),
        const Text("End of Records", style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF554337))),
        const Text("Showing history from the last 90 days", style: TextStyle(color: Colors.grey, fontSize: 12)),
      ],
    );
  }

  Widget _buildActiveOrderCard({
    required String queueNumber,
    required String status,
    required Color statusColor,
    required String itemName,
    required String itemImage,
    required String price,
    required String paymentStatus,
    required String details,
    required Widget bottomInfo,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('QUEUE NUMBER', style: TextStyle(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
                  Text(queueNumber, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Color(0xFF562F00))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withValues(alpha: 0.5)),
                ),
                child: Text(status, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          const SizedBox(height: 20),
          Row(
  children: [
    // 1. Bagian Gambar
    ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: itemImage.startsWith('assets/')
          ? Image.asset(
              itemImage,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 64,
                  height: 64,
                  color: const Color(0xFFF6F4E8),
                  child: const Icon(Icons.fastfood, color: Color(0xFFFF9442)),
                );
              },
            )
          : Image.network(
              itemImage,
              width: 64,
              height: 64,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 64,
                  height: 64,
                  color: const Color(0xFFF6F4E8),
                  child: const Icon(Icons.fastfood, color: Color(0xFFFF9442)),
                );
              },
            ),
    ),
    const SizedBox(width: 16),
    
    // 2. Bagian Teks (Wajib pakai Expanded)
    Expanded( 
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            itemName,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            overflow: TextOverflow.ellipsis, // Tambahkan titik-titik jika kepanjangan
          ),
          Text(
            details,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    ),
    
    // 3. Bagian Harga
    Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF954A00))),
        Text(paymentStatus, style: const TextStyle(fontSize: 8, color: Colors.grey)),
      ],
    ),
  ],
)

        ],
      ),
    );
  }

  Widget _buildHistoryCard(String id, String status, String price, String items, Color labelColor, {bool isCancelled = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(id, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(color: labelColor, borderRadius: BorderRadius.circular(4)),
                    child: Text(status, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              Text(
                price,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF954A00),
                  decoration: isCancelled ? TextDecoration.lineThrough : TextDecoration.none,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF6F4E8), borderRadius: BorderRadius.circular(12)),
            child: Text(items, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }

  // Widget: Craving Banner (Brown)
  Widget _buildCravingBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF954A00),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Craving\nMore?', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900, height: 1)),
              const SizedBox(height: 10),
              Text('Add a side of Fried Siomay while you wait for your main course.',
                  style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/dashboard_menu');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF954A00),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('ADD TO ORDER', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              )
            ],
          ),
          Positioned(
            right: -10, bottom: -10,
            child: Icon(Icons.restaurant, size: 80, color: Colors.white.withValues(alpha: 0.1)),
          )
        ],
      ),
    );
  }

}
