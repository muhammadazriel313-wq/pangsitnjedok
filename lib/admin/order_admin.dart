import 'package:flutter/material.dart';
import 'dart:convert';
import '/service/api_service.dart';

class OrderManagement extends StatefulWidget {
  const OrderManagement({super.key});

  @override
  State<OrderManagement> createState() => _OrderManagementState();
}

class _OrderManagementState extends State<OrderManagement> {
  int _currentTab = 0; // 0 = Incoming, 1 = Processing, 2 = Completed

  String _getStatusFromTab() {
    if (_currentTab == 0) return 'WAITING';
    if (_currentTab == 1) return 'PROCESSING';
    return 'COMPLETED';
  }

  void acceptOrder(String id) async {
    bool success = await ApiService.updateOrderStatus(id, 'PROCESSING');
    if (success) {
      setState(() {}); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pesanan $id diterima dan sedang diproses!'))
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal memperbarui status ke server.'))
      );
    }
  }

  void completeOrder(String id) async {
    bool success = await ApiService.updateOrderStatus(id, 'COMPLETED');
    if (success) {
      setState(() {}); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pesanan $id telah selesai!'))
      );
    }
  }

  void rejectOrder(String id) async {
    bool success = await ApiService.updateOrderStatus(id, 'REJECTED');
    if (success) {
      setState(() {}); 
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pesanan $id telah ditolak.'))
      );
    }
  }

  void _showRejectDialog(BuildContext context, String orderId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        int selectedReason = 0;
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            Widget buildReasonOption(int index, String text) {
              bool isSelected = selectedReason == index;
              return GestureDetector(
                onTap: () => setStateDialog(() => selectedReason = index),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0x7FFFF7ED) : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(width: 2, color: isSelected ? const Color(0xFF964900) : const Color(0xFFF5F5F4)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 22, height: 22,
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFF97316) : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(width: 2, color: isSelected ? const Color(0xFFF97316) : const Color(0xFFD6D3D1)),
                        ),
                        child: isSelected ? const Icon(Icons.circle, size: 10, color: Colors.white) : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(child: Text(text, style: const TextStyle(color: Color(0xFF231A14), fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'))),
                    ],
                  ),
                ),
              );
            }

            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 340, padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Container(padding: const EdgeInsets.all(10), decoration: const BoxDecoration(color: Color(0xFFFED7AA), shape: BoxShape.circle), child: const Icon(Icons.warning_amber_rounded, color: Color(0xFFEA580C), size: 28)),
                        const SizedBox(width: 12),
                        const Expanded(child: Text('Anda Yakin Menolak Pesanan?', style: TextStyle(color: Color(0xFF231A14), fontSize: 20, fontWeight: FontWeight.w800, fontFamily: 'Inter', height: 1.2))),
                      ],
                    ),
                    const SizedBox(height: 24),
                    buildReasonOption(0, 'Menu belum tersedia saat ini'),
                    buildReasonOption(1, 'Restoran sudah hampir tutup'),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(child: GestureDetector(onTap: () => Navigator.pop(context), child: const Center(child: Text('Batal', style: TextStyle(color: Color(0xFF231A14), fontWeight: FontWeight.w700))))),
                        Expanded(flex: 2, child: GestureDetector(
                          onTap: () {
                            rejectOrder(orderId);
                            Navigator.pop(context);
                          },
                          child: Container(padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: const Color(0xFFEA580C), borderRadius: BorderRadius.circular(9999)), alignment: Alignment.center, child: const Text('Tolak Pesanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))),
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // --- PERBAIKAN: Header Dinamis Menggunakan FutureBuilder ---
    Widget buildHeader() {
      return Container(
        padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDF1), 
          border: Border(bottom: BorderSide(width: 1, color: Color(0xFFFFCE99)))
        ),
        child: FutureBuilder<Map<String, dynamic>?>(
          future: ApiService.getAdminProfil(), // Memanggil data profil admin[cite: 14]
          builder: (context, snapshot) {
            final String? imageUrl = snapshot.data?['image_url'];
            final String adminName = snapshot.data?['name'] ?? 'Admin';

            return Row(
              children: [
                Container(
                  width: 44, 
                  height: 44, 
                  decoration: BoxDecoration(
                    shape: BoxShape.circle, 
                    border: Border.all(width: 2, color: const Color(0xFFFF9442))
                  ),
                  child: ClipOval(
                    child: (imageUrl != null && imageUrl.isNotEmpty)
                        ? Image.network(
                            "${ApiService.baseUrl}/uploads/$imageUrl", // Foto dinamis[cite: 14]
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => 
                                Image.asset("assets/images/Dimas oi oi.jpeg", fit: BoxFit.cover),
                          )
                        : Image.asset("assets/images/Dimas oi oi.jpeg", fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start, 
                  children: [
                    Text(
                      'Welcome, $adminName', 
                      style: const TextStyle(color: Color(0xFF562F00), fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter')
                    ),
                  ]
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
            child: FutureBuilder<List<dynamic>>(
              future: ApiService.getOrders(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9644)));
                }
                if (snapshot.hasError) {
                  return Center(child: Text("Error Database:\n${snapshot.error}", textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)));
                }

                final allOrders = snapshot.data ?? [];
                final currentOrders = allOrders.where((o) => o['status'] == _getStatusFromTab()).toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: const Color(0x4CFFCE99), borderRadius: BorderRadius.circular(16)),
                        child: Row(
                          children: [
                            Expanded(child: _buildTabButton('Incoming', isActive: _currentTab == 0, onTap: () => setState(() => _currentTab = 0))),
                            Expanded(child: _buildTabButton('Processing', isActive: _currentTab == 1, onTap: () => setState(() => _currentTab = 1))),
                            Expanded(child: _buildTabButton('Completed', isActive: _currentTab == 2, onTap: () => setState(() => _currentTab = 2))),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),
                      if (currentOrders.isEmpty)
                        _buildEmptyState()
                      else
                        ...currentOrders.map((order) {
                          List<dynamic> itemsRaw = [];
                          try { itemsRaw = json.decode(order['items_raw']); } catch (e) { itemsRaw = []; }

                          final mappedOrder = {
                            'id': order['id'].toString(),
                            'customerName': order['customerName'] ?? 'No Name',
                            'no_telepon': order['no_telepon'] ?? '-',
                            'status': order['status'],
                            'timestamp': order['timestamp'] ?? '-',
                            'totalAmount': 'Rp ${order['totalAmount']}',
                            'totalItems': '${itemsRaw.length} Items',
                            'items': itemsRaw.map((i) => {
                              'name': '${i['qty']}x ${i['name']}',
                              'price': 'Rp ${i['price']}'
                            }).toList(),
                          };
                          return Padding(padding: const EdgeInsets.only(bottom: 24), child: _buildOrderCard(mappedOrder));
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

  // (Sisa widget _buildEmptyState, _buildTabButton, _buildOrderCard, _buildBottomNav, _buildNavItem tetap sama seperti desain asli kamu)
  Widget _buildEmptyState() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(width: 2, color: const Color(0xFFFF9644))),
      child: Column(
        children: [
          const Icon(Icons.check_circle_outline, color: Color(0x66562F00), size: 48),
          const SizedBox(height: 16),
          Text(_currentTab == 0 ? 'No incoming orders' : _currentTab == 1 ? 'No processing orders' : 'No completed orders', style: const TextStyle(color: Color(0x66562F00), fontSize: 16, fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }

  Widget _buildTabButton(String title, {required bool isActive, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: isActive ? const Color(0xFFFF9644) : Colors.transparent, borderRadius: BorderRadius.circular(12)),
        alignment: Alignment.center,
        child: Text(title, style: TextStyle(color: isActive ? Colors.white : const Color(0xFF562F00), fontWeight: isActive ? FontWeight.w700 : FontWeight.w500)),
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
          Expanded(child: GestureDetector(onTap: () => _showRejectDialog(context, order['id']), child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(width: 2, color: const Color(0x19562F00))), alignment: Alignment.center, child: const Text('Reject', style: TextStyle(color: Color(0xFF562F00), fontWeight: FontWeight.w700))))),
          const SizedBox(width: 16),
          Expanded(child: GestureDetector(onTap: () => acceptOrder(order['id']), child: Container(padding: const EdgeInsets.symmetric(vertical: 14), decoration: BoxDecoration(color: const Color(0xFFFF9644), borderRadius: BorderRadius.circular(12)), alignment: Alignment.center, child: const Text('Accept Order', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))))),
        ],
      );
    } else if (status == 'PROCESSING') {
      actionArea = GestureDetector(onTap: () => completeOrder(order['id']), child: Container(width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16), decoration: BoxDecoration(color: const Color(0xFFFF9644), borderRadius: BorderRadius.circular(16)), alignment: Alignment.center, child: const Text('Mark as Completed!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))));
    } else {
      actionArea = Center(child: Container(padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 32), decoration: BoxDecoration(color: const Color(0xFFFF9644), borderRadius: BorderRadius.circular(12)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.check_circle_outline, color: Colors.white, size: 20), SizedBox(width: 8), Text('Completed!', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700))])));
    }

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0xFFFFCE99))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(order['id'], style: const TextStyle(color: Color(0xFFFF9644), fontSize: 32, fontWeight: FontWeight.w900)),
                Text(order['customerName'], style: const TextStyle(color: Color(0xFF562F00), fontSize: 18, fontWeight: FontWeight.w700)),
              ]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
                Container(padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4), decoration: BoxDecoration(color: const Color(0x19FF9644), borderRadius: BorderRadius.circular(20)), child: Text(status, style: const TextStyle(color: Color(0xFFFF9644), fontSize: 10, fontWeight: FontWeight.w800))),
                const SizedBox(height: 4),
                Text(order['timestamp'], style: const TextStyle(color: Color(0x66562F00), fontSize: 11)),
              ]),
            ],
          ),
          const SizedBox(height: 20),
          ...items.map((item) => Padding(padding: const EdgeInsets.only(bottom: 8), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(item['name']), Text(item['price'], style: const TextStyle(fontWeight: FontWeight.w700))]))),
          const Divider(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('Total Items', style: TextStyle(fontSize: 12)), Text(order['totalItems'], style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700))]),
              Column(crossAxisAlignment: CrossAxisAlignment.end, children: [const Text('Total Amount', style: TextStyle(fontSize: 12)), Text(order['totalAmount'], style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900))]),
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
      decoration: const BoxDecoration(color: Color(0xFFFFFDF1), border: Border(top: BorderSide(width: 1, color: Color(0xFFFFCE99)))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildNavItem("Dashboard", Icons.dashboard_outlined, isActive: false, route: '/dashboard'),
          _buildNavItem("Orders", Icons.receipt_long, isActive: true, route: '/order'),
          _buildNavItem("Menu", Icons.restaurant_menu_outlined, isActive: false, route: '/menu'),
          _buildNavItem("profit", Icons.bar_chart_outlined, isActive: false, route: '/profit'),
          _buildNavItem("Profile", Icons.person_outline, isActive: false, route: '/profil'),
        ],
      ),
    );
  }

  Widget _buildNavItem(String label, IconData icon, {required bool isActive, required String route}) {
    return GestureDetector(
      onTap: () { if (!isActive) Navigator.pushReplacementNamed(context, route); },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), decoration: BoxDecoration(color: isActive ? const Color(0xFFFFCE99) : Colors.transparent, borderRadius: BorderRadius.circular(20)), child: Icon(icon, color: isActive ? const Color(0xFF562F00) : const Color(0x99562F00), size: 24)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}