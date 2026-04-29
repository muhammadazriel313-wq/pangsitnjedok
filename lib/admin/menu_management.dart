import 'package:flutter/material.dart';
import '/service/api_service.dart'; 
import 'tambah_menu.dart'; 
import 'edit_menu.dart';

class MenuManagement extends StatefulWidget {
  const MenuManagement({super.key});

  @override
  State<MenuManagement> createState() => _MenuManagementState();
}

class _MenuManagementState extends State<MenuManagement> {
  bool _isFoodTab = true;

  // --- FUNGSI REFRESH DATA ---
  void _refreshData() {
    setState(() {}); // Memicu FutureBuilder untuk mengambil data ulang dari MySQL
  }

  // --- FUNGSI POP-UP DELETE ---
  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 320,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [BoxShadow(color: Color(0x3F000000), blurRadius: 20.0, offset: Offset(0, 10.0))],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: const BoxDecoration(color: Color(0xFFFEE2E2), shape: BoxShape.circle),
                  child: const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 32), 
                ),
                const SizedBox(height: 16),
                const Text('Hapus Menu?', style: TextStyle(color: Color(0xFF231A14), fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Text('Apakah Anda yakin ingin menghapus "${item['title']}"?', textAlign: TextAlign.center, style: const TextStyle(color: Color(0xFF554337), fontSize: 14)),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.pop(context), 
                        child: _buildDialogBtn('Batal', Colors.white, const Color(0xFF562F00), isBorder: true),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          // TODO: Tambahkan ApiService.deleteMenu(item['id'])
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('${item['title']} dihapus')));
                          _refreshData();
                        },
                        child: _buildDialogBtn('Hapus', const Color(0xFFEF4444), Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: ApiService.getMenus(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: Color(0xFFFF9644)));
                }
                if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}"));
                if (!snapshot.hasData || snapshot.data!.isEmpty) return const Center(child: Text("Menu kosong"));

                final allData = snapshot.data!;
                final activeData = allData.where((item) {
                  String category = _isFoodTab ? 'Makanan' : 'Minuman';
                  return item['category'] == category;
                }).toList();

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTabController(),
                      const SizedBox(height: 16),
                      Text('${activeData.length} Items', style: const TextStyle(color: Color(0xFF562F00), fontSize: 24, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activeData.length,
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250,
                          mainAxisSpacing: 16,
                          crossAxisSpacing: 16,
                          mainAxisExtent: 260, 
                        ),
                        itemBuilder: (context, index) {
                          final dbItem = activeData[index];
                          final item = {
                            'id': dbItem['id'],
                            'title': dbItem['title'],
                            'price': 'Rp ${dbItem['price']}',
                            'stock': dbItem['stock'].toString(),
                            'category': dbItem['category'],
                            'color': (int.parse(dbItem['stock'].toString()) < 10) ? Colors.red : Colors.green,
                            'img': dbItem['image_url'] ?? "assets/images/placeholder.png",
                          };
                          return _buildMenuItemCard(item: item);
                        },
                      ),
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

  // --- UI COMPONENTS ---

  Widget _buildMenuItemCard({required Map<String, dynamic> item}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFEEDD)),
        boxShadow: const [BoxShadow(color: Color(0x08562F00), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                child: Image.asset(item['img'], height: 140, width: double.infinity, fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(color: Colors.grey[200], child: const Icon(Icons.fastfood)),
                ),
              ),
              Positioned(
                top: 12, right: 12,
                child: Row(
                  children: [
                    _buildSmallBtn(Icons.edit_outlined, const Color(0xFFD97706), const Color(0xFFFEF3C7), () {
                      Navigator.push(
                        context, 
                        MaterialPageRoute(
                          builder: (context) => EditMenu(item: Map<String, dynamic>.from(item))
                        )
                      ).then((value) {
                        if (value == true) _refreshData();
                      });
                    }),
                    const SizedBox(width: 8),
                    _buildSmallBtn(Icons.delete_outline, const Color(0xFFEF4444), const Color(0xFFFEE2E2), () => _showDeleteDialog(item)),
                  ],
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['title'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(item['price'], style: const TextStyle(color: Color(0xFFFF9644), fontWeight: FontWeight.w900)),
                    Text('Stk: ${item['stock']}', style: TextStyle(color: item['color'], fontSize: 10, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 20),
      decoration: const BoxDecoration(color: Color(0xFFFFFDF1), border: Border(bottom: BorderSide(color: Color(0xFFFFCE99)))),
      child: Row(
        children: [
          CircleAvatar(backgroundImage: const AssetImage("assets/images/Dimas oi oi.jpeg"), radius: 22),
          const SizedBox(width: 16),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('Welcome, Admin', style: TextStyle(fontWeight: FontWeight.w700)),
          ]),
        ],
      ),
    );
  }

  Widget _buildTabController() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(color: const Color(0xFFFDEAE0), borderRadius: BorderRadius.circular(30)),
          child: Row(
            children: [
              _buildTabBtn('FOOD', _isFoodTab, () => setState(() => _isFoodTab = true)),
              _buildTabBtn('BEVERAGES', !_isFoodTab, () => setState(() => _isFoodTab = false)),
            ],
          ),
        ),
        FloatingActionButton.small(
          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TambahMenu())).then((v) => _refreshData()),
          backgroundColor: const Color(0xFFFF9644),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ],
    );
  }

  Widget _buildTabBtn(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        decoration: BoxDecoration(color: active ? const Color(0xFFFF9644) : Colors.transparent, borderRadius: BorderRadius.circular(30)),
        child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.brown, fontSize: 10, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildSmallBtn(IconData icon, Color color, Color bg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: color, size: 16)),
    );
  }

  Widget _buildDialogBtn(String label, Color bg, Color text, {bool isBorder = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30), border: isBorder ? Border.all(color: const Color(0xFFDCC1B2)) : null),
      alignment: Alignment.center,
      child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBottomNav() {
    return Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24), decoration: const BoxDecoration(color: Color(0xFFFFFDF1), border: Border(top: BorderSide(color: Color(0xFFFFCE99)))),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        _buildNavItem("Dashboard", Icons.dashboard_outlined, isActive: false, context: context, route: '/dashboard'),
        _buildNavItem("Orders", Icons.receipt_long_outlined, isActive: false, context: context, route: '/order'),
        _buildNavItem("Menu", Icons.restaurant_menu, isActive: true, context: context, route: '/menu'),
        _buildNavItem("Profit", Icons.bar_chart, isActive: false, context: context, route: '/profit'),
        _buildNavItem("Profile", Icons.person_outline, isActive: false, context: context, route: '/profil'),
      ]),
    );
  }
  Widget _buildNavItem(String label, IconData icon, {required bool isActive, required BuildContext context, required String route}) {
    return GestureDetector(onTap: () { if (!isActive) Navigator.pushReplacementNamed(context, route); },
      child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: isActive ? const Color(0xFF562F00) : Colors.grey), Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFF562F00) : Colors.grey))]),
    );
  }
}