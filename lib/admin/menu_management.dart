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

  void _refreshData() {
    setState(() {}); 
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
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                   return const Center(child: Text("Database menu masih kosong"));
                }

                final allData = snapshot.data!;
                final activeData = allData.where((item) {
                String currentCategory = (item['category'] ?? '').toString().toLowerCase().trim();
                
                if (_isFoodTab) {
                  // Di tab FOOD: Tampilkan jika di database tertulis 'food' ATAU 'makanan'
                  return currentCategory == 'food' || currentCategory == 'makanan';
                } else {
                  // Di tab BEVERAGES: Tampilkan jika di database tertulis 'beverages' ATAU 'minuman'
                  return currentCategory == 'beverages' || currentCategory == 'minuman';
                }
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
                      
                      if (activeData.isEmpty)
                        Container(
                          height: 200, alignment: Alignment.center,
                          child: Text("Belum ada menu di kategori ini", style: TextStyle(color: Colors.grey[500], fontSize: 16)),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: activeData.length,
                          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 250, mainAxisSpacing: 16, crossAxisSpacing: 16, mainAxisExtent: 270, 
                          ),
                          itemBuilder: (context, index) {
                            final dbItem = activeData[index];
                            
                            // MAPPING DATA ANTI-NULL
                            String rawImg = dbItem['image_url']?.toString() ?? '';
                            
                            final item = {
                              'id': dbItem['id'] ?? 0,
                              'title': dbItem['title']?.toString() ?? 'Tanpa Nama',
                              'price': 'Rp ${dbItem['price'] ?? 0}',
                              'stock': (dbItem['stock'] ?? 0).toString(),
                              'category': dbItem['category']?.toString() ?? 'Lainnya',
                              'color': (int.tryParse(dbItem['stock']?.toString() ?? '0') ?? 0) < 10 ? Colors.red : Colors.green,
                              // Pastikan img tidak pernah null
                              'img': rawImg.isEmpty ? 'placeholder.png' : rawImg,
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

  Widget _buildMenuItemCard({required Map<String, dynamic> item}) {
    // --- LOGIKA PENDETEKSI GAMBAR (ASSETS ATAU UPLOADS) ---
    String imgStr = item['img'].toString();
    Widget imageWidget;

    if (imgStr.startsWith('http')) {
      imageWidget = Image.network(imgStr, fit: BoxFit.cover, errorBuilder: (c,e,s) => _fallbackImage());
    } else if (RegExp(r'^\d+_').hasMatch(imgStr)) {
      // Jika diawali deretan angka (hasil upload XAMPP)
      imageWidget = Image.network("${ApiService.baseUrl}/uploads/$imgStr", fit: BoxFit.cover, errorBuilder: (c,e,s) => _fallbackImage());
    } else {
      // Jika gambar manual bawaan lokal
      String finalAssetPath = imgStr.startsWith('assets/') ? imgStr : 'assets/images/$imgStr';
      imageWidget = Image.asset(finalAssetPath, fit: BoxFit.cover, errorBuilder: (c,e,s) => _fallbackImage());
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white, borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFFFEEDD)),
        boxShadow: const [BoxShadow(color: Color(0x08562F00), blurRadius: 20, offset: Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: SizedBox(height: 130, width: double.infinity, child: imageWidget),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
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
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _buildSmallBtn(Icons.edit_outlined, const Color(0xFFD97706), const Color(0xFFFEF3C7), () {
                      // Bawa item yang 100% aman (bebas null) ke halaman EditMenu[cite: 13]
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditMenu(item: Map<String, dynamic>.from(item)))).then((value) { if (value == true) _refreshData(); });
                    }),
                    const SizedBox(width: 8),
                    _buildSmallBtn(Icons.delete_outline, const Color(0xFFEF4444), const Color(0xFFFEE2E2), () => _showDeleteDialog(item)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _fallbackImage() => Container(color: Colors.grey[200], child: const Icon(Icons.fastfood, color: Colors.grey));

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 20),
      decoration: const BoxDecoration(color: Color(0xFFFFFDF1), border: Border(bottom: BorderSide(color: Color(0xFFFFCE99)))),
      child: FutureBuilder<Map<String, dynamic>?>(
        future: ApiService.getAdminProfil(),
        builder: (context, snapshot) {
          final String? imageUrl = snapshot.data?['image_url'];
          final String adminName = snapshot.data?['name'] ?? 'Admin';
          return Row(
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(width: 2, color: const Color(0xFFFF9442))),
                child: ClipOval(
                  child: (imageUrl != null && imageUrl.isNotEmpty)
                      ? Image.network("${ApiService.baseUrl}/uploads/$imageUrl", fit: BoxFit.cover, errorBuilder: (c, e, s) => Image.asset("assets/images/Dimas oi oi.jpeg", fit: BoxFit.cover))
                      : Image.asset("assets/images/Dimas oi oi.jpeg", fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              Text('Welcome, $adminName', style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          );
        },
      ),
    );
  }

  void _showDeleteDialog(Map<String, dynamic> item) {
    showDialog(context: context, builder: (BuildContext context) {
      return Dialog(backgroundColor: Colors.transparent, child: Container(width: 320, padding: const EdgeInsets.all(24), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24)),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          const Icon(Icons.delete_outline, color: Color(0xFFEF4444), size: 48), const SizedBox(height: 16),
          Text('Delete ${item['title']}?', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)), const SizedBox(height: 24),
          Row(children: [
            Expanded(child: GestureDetector(onTap: () => Navigator.pop(context), child: _buildDialogBtn('Batal', Colors.white, Colors.black, isBorder: true))), const SizedBox(width: 12),
            Expanded(child: GestureDetector(onTap: () async { await ApiService.deleteMenu(item['id'].toString()); Navigator.pop(context); _refreshData(); }, child: _buildDialogBtn('Delete', const Color(0xFFEF4444), Colors.white))),
          ])
        ]),
      ));
    });
  }

  Widget _buildTabController() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      Container(padding: const EdgeInsets.all(4), decoration: BoxDecoration(color: const Color(0xFFFDEAE0), borderRadius: BorderRadius.circular(30)),
        child: Row(children: [
          _buildTabBtn('FOOD', _isFoodTab, () => setState(() => _isFoodTab = true)),
          _buildTabBtn('BEVERAGES', !_isFoodTab, () => setState(() => _isFoodTab = false)),
        ]),
      ),
      FloatingActionButton.small(onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (c) => const TambahMenu())).then((v) => _refreshData()), backgroundColor: const Color(0xFFFF9644), child: const Icon(Icons.add, color: Colors.white)),
    ]);
  }

  Widget _buildTabBtn(String label, bool active, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8), decoration: BoxDecoration(color: active ? const Color(0xFFFF9644) : Colors.transparent, borderRadius: BorderRadius.circular(30)), child: Text(label, style: TextStyle(color: active ? Colors.white : Colors.brown, fontSize: 10, fontWeight: FontWeight.bold))));
  Widget _buildSmallBtn(IconData icon, Color color, Color bg, VoidCallback onTap) => GestureDetector(onTap: onTap, child: Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: bg, shape: BoxShape.circle), child: Icon(icon, color: color, size: 16)));
  Widget _buildDialogBtn(String label, Color bg, Color text, {bool isBorder = false}) => Container(padding: const EdgeInsets.symmetric(vertical: 12), decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(30), border: isBorder ? Border.all(color: Colors.grey) : null), alignment: Alignment.center, child: Text(label, style: TextStyle(color: text, fontWeight: FontWeight.bold)));
  Widget _buildBottomNav() => Container(padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
                              decoration: const BoxDecoration(color: Color(0xFFFFFDF1), 
                              border: Border(top: BorderSide(color: Color(0xFFFFCE99)))), 
                              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, 
                              children: [ _buildNavItem("Dashboard", Icons.dashboard_outlined, isActive: false, route: '/dashboard'),
                                          _buildNavItem("Orders", Icons.receipt_long_outlined, isActive: false, route: '/order'), 
                                          _buildNavItem("Menu", Icons.restaurant_menu, isActive: true, route: '/menu'), 
                                          _buildNavItem("Income", Icons.bar_chart, isActive: false, route: '/profit'), 
                                          _buildNavItem("Profile", Icons.person_outline, isActive: false, route: '/profil')]));
  Widget _buildNavItem(String label, IconData icon, 
  {required bool isActive, required String route}) => GestureDetector(onTap: () { if (!isActive) Navigator.pushReplacementNamed(context, route); }, 
            child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: isActive ? const Color(0xFF562F00) : Colors.grey), 
            Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFF562F00) : Colors.grey))]));
}