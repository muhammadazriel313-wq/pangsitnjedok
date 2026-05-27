import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async'; // WAJIB ADA: Untuk fungsi Timer Live Update
import '/service/api_service.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  int _currentTab = 0; // 0 = Incoming, 1 = Processing, 2 = Completed
  bool _isLoading = true;
  List<dynamic> _allOrders = [];

  Timer? _timer;

  @override
  // PENJELASAN UNTUK SIDANG:
  // initState() adalah fungsi pertama yang dijalankan saat halaman ini dibuka.
  // Ibarat saat kita bangun tidur, ini hal pertama yang dilakukan sebelum aktivitas lain.
  // Di sini kita langsung mengambil data pesanan (_fetchOrders).
  void initState() {
    super.initState();
    _fetchOrders();
    // Refresh otomatis setiap 3 detik di belakang layar tanpa merusak UI
    _timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      if (mounted) {
        _fetchOrders();
      }
    });
  }

  Future<void> _fetchOrders() async {
    try {
      final orders = await ApiService.getOrders();
      if (mounted) {
        setState(() {
          _allOrders = orders;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Error fetching orders: $e");
      if (mounted && _isLoading) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  // PENJELASAN UNTUK SIDANG:
  // dispose() dijalankan saat kita keluar/pindah dari halaman ini.
  // Kita harus mematikan (cancel) hal-hal yang berjalan di latar belakang (seperti Timer),
  // agar tidak membebani memori HP (mencegah memory leak).
  void dispose() {
    // Matikan timer saat pindah halaman agar tidak terjadi memory leak (error)
    _timer?.cancel();
    super.dispose();
  }

  String _getStatusFromTab() {
    if (_currentTab == 0) return 'WAITING';
    if (_currentTab == 1) return 'PROCESSING';
    return 'COMPLETED';
  }

  void acceptOrder(String id) async {
    bool success = await ApiService.updateOrderStatus(id, 'PROCESSING');
    if (!mounted) return;
    if (success) {
      _fetchOrders(); // Memperbarui layar secara instan
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Order $id accepted and processing!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status to server.')),
      );
    }
  }

  void completeOrder(String id) async {
    bool success = await ApiService.updateOrderStatus(id, 'COMPLETED');
    if (!mounted) return;
    if (success) {
      _fetchOrders(); // Memperbarui layar secara instan
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Order $id completed!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to complete order.')),
      );
    }
  }

  // Fungsi Pop-up Konfirmasi Tolak Pesanan
  void _showRejectDialog(BuildContext parentContext, String id) {
    showDialog(
      context: parentContext,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Reject Order',
            style: TextStyle(
              color: Color(0xFF562F00),
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text('Are you sure you want to reject order $id?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext); // Tutup pop-up
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext); // Tutup pop-up

                // Mengirim perintah ke database untuk mengubah status menjadi CANCELLED/REJECTED
                bool success = await ApiService.updateOrderStatus(
                  id,
                  'CANCELLED',
                );
                if (!mounted) return;
                if (success) {
                  _fetchOrders(); // Langsung refresh layar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Order $id rejected successfully.')),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to reject order on server.'),
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(
                  0xFF562F00,
                ), // Sesuai tema warna aplikasi
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Yes, Reject',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buildHeader() {
      return Container(
        padding: const EdgeInsets.only(
          top: 40,
          left: 24,
          right: 24,
          bottom: 20,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDF1),
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFFFCE99)),
          ),
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future:
              ApiService.getAdminProfil(), // Memanggil data profil admin[cite: 14]
          builder: (context, snapshot) {
            final String adminName = snapshot.data?['name'] ?? 'Admin';

            return Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(width: 2, color: Color(0xFFFF9442)),
                    ),
                  ),
                  child: const Icon(
                    Icons.account_circle,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome, $adminName',
                      style: const TextStyle(
                        color: Color(0xFF562F00),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF9644)),
                  )
                : Builder(
                    builder: (context) {
                      final currentOrders = _allOrders
                          .where((o) => o['status'] == _getStatusFromTab())
                          .toList();

                      return SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: const Color(0x4CFFCE99),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: _buildTabButton(
                                      'Incoming',
                                      isActive: _currentTab == 0,
                                      onTap: () =>
                                          setState(() => _currentTab = 0),
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildTabButton(
                                      'Processing',
                                      isActive: _currentTab == 1,
                                      onTap: () =>
                                          setState(() => _currentTab = 1),
                                    ),
                                  ),
                                  Expanded(
                                    child: _buildTabButton(
                                      'Completed',
                                      isActive: _currentTab == 2,
                                      onTap: () =>
                                          setState(() => _currentTab = 2),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 32),
                            if (currentOrders.isEmpty)
                              _buildEmptyState()
                            else
                              ...currentOrders.map((order) {
                                List<dynamic> itemsRaw = [];
                                try {
                                  itemsRaw = json.decode(order['items_raw']);
                                } catch (e) {
                                  itemsRaw = [];
                                }

                                final mappedOrder = {
                                  'id': order['id'].toString(),
                                  'customerName':
                                      order['customerName'] ?? 'No Name',
                                  'no_telepon': order['no_telepon'] ?? '-',
                                  'status': order['status'],
                                  'timestamp': order['timestamp'] ?? '-',
                                  'totalAmount':
                                      order['totalAmount']
                                          .toString()
                                          .startsWith('Rp')
                                      ? order['totalAmount'].toString()
                                      : 'Rp ${order['totalAmount']}',
                                  'totalItems': '${itemsRaw.length} Items',
                                  'items': itemsRaw
                                      .map(
                                        (i) => {
                                          'name':
                                              '${i['qty']}x ${i['menu_id'] ?? i['name'] ?? 'Pangsit'}',
                                          'price': 'Rp ${i['price']}',
                                        },
                                      )
                                      .toList(),
                                };
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  child: _buildOrderCard(mappedOrder),
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

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(width: 2, color: const Color(0xFFFF9644)),
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_outline,
            color: Color(0x66562F00),
            size: 48,
          ),
          const SizedBox(height: 16),
          Text(
            _currentTab == 0
                ? 'No incoming orders'
                : _currentTab == 1
                ? 'No processing orders'
                : 'No completed orders',
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

  Widget _buildTabButton(
    String title, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF9644) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            color: isActive ? Colors.white : const Color(0xFF562F00),
            fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    String status = order['status'];
    List<dynamic> items = order['items'];
    Widget actionArea;
    if (status == 'WAITING') {
      actionArea = Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => _showRejectDialog(context, order['id']),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(width: 2, color: const Color(0x19562F00)),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Reject',
                  style: TextStyle(
                    color: Color(0xFF562F00),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: GestureDetector(
              onTap: () => acceptOrder(order['id']),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9644),
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Accept Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    } else if (status == 'PROCESSING') {
      actionArea = GestureDetector(
        onTap: () => completeOrder(order['id']),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9644),
            borderRadius: BorderRadius.circular(16),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Mark as Completed!',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
          ),
        ),
      );
    } else {
      actionArea = Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32),
          decoration: BoxDecoration(
            color: const Color(0xFFFF9644),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Completed!',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: const Color(0xFFFFCE99)),
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
                  Text(
                    order['id'],
                    style: const TextStyle(
                      color: Color(0xFFFF9644),
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    order['customerName'],
                    style: const TextStyle(
                      color: Color(0xFF562F00),
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0x19FF9644),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      status,
                      style: const TextStyle(
                        color: Color(0xFFFF9644),
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    order['timestamp'],
                    style: const TextStyle(
                      color: Color(0x66562F00),
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(item['name']),
                  Text(
                    item['price'],
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Items', style: TextStyle(fontSize: 12)),
                  Text(
                    order['totalItems'],
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Total Amount', style: TextStyle(fontSize: 12)),
                  Text(
                    order['totalAmount'],
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          actionArea,
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFDF1),
        border: Border(top: BorderSide(width: 1, color: Color(0xFFFFCE99))),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem(
            "Dashboard",
            Icons.dashboard_outlined,
            isActive: false,
            route: '/dashboard',
          ),
          _buildNavItem(
            "Orders",
            Icons.receipt_long,
            isActive: true,
            route: '/order',
          ),
          _buildNavItem(
            "Menu",
            Icons.restaurant_menu_outlined,
            isActive: false,
            route: '/menu',
          ),
          _buildNavItem(
            "Profit",
            Icons.bar_chart_outlined,
            isActive: false,
            route: '/profit',
          ),
          _buildNavItem(
            "Profile",
            Icons.person_outline,
            isActive: false,
            route: '/profil',
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    String label,
    IconData icon, {
    required bool isActive,
    required String route,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isActive) Navigator.pushReplacementNamed(context, route);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isActive ? const Color(0xFFFFCE99) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? const Color(0xFF562F00)
                  : const Color(0x99562F00),
              size: 24,
            ),
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
