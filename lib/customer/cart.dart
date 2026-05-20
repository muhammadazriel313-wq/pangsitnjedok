import 'package:flutter/material.dart';

// ✅ IMPORT SEMUA HALAMAN TERMASUK POP-UP
import 'dashboard_menu.dart';
import 'halaman_menu.dart';
import 'order.dart';
import 'profil_customer.dart';
import 'popup_konfirmasi.dart'; // Import pop up-nya

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [
    {'name': 'Mietiaw Mentai', 'desc': 'Extra Saus Mentai (+Rp 4.000)', 'price': 19000, 'qty': 2},
    {'name': 'Es Buah Lecy', 'desc': 'Regular Size', 'price': 9000, 'qty': 1}
  ];

  int get totalPayment => cartItems.fold(0, (sum, item) => sum + ((item['price'] as int) * (item['qty'] as int)));
  int get totalItems => cartItems.fold(0, (sum, item) => sum + (item['qty'] as int));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false, 
      backgroundColor: const Color(0xFFFCFAEE), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF562F00)),
          onPressed: () => Navigator.pop(context), 
        ),
        title: const Text('My Cart', style: TextStyle(color: Color(0xFF562F00), fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  if (cartItems.isEmpty)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 50),
                      child: Center(
                        child: Text("Keranjangmu masih kosong nih, Komandan!\nYuk tambah menu lagi.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ),
                    )
                  else
                    ...cartItems.asMap().entries.map((entry) {
                      int index = entry.key;
                      var item = entry.value;

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: _buildCartItem(
                          name: item['name'], desc: item['desc'], price: item['price'], qty: item['qty'],
                          onAdd: () => setState(() => cartItems[index]['qty']++),
                          onRemove: () => setState(() { if (cartItems[index]['qty'] > 1) cartItems[index]['qty']--; }),
                          onDelete: () => setState(() => cartItems.removeAt(index))
                        ),
                      );
                    }),
                  
                  const SizedBox(height: 20),
                  _buildAddMoreButton(), 
                  const SizedBox(height: 40), 
                ],
              ),
            ),
          ),
          
          if (cartItems.isNotEmpty) _buildPaymentPanel(context), // Kirim context ke fungsi panel
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildPaymentPanel(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Total Payment', style: TextStyle(color: Colors.grey)),
                  Text('Rp ${totalPayment.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF562F00))),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(color: const Color(0xFFFFE5D1), borderRadius: BorderRadius.circular(10)),
                child: Text('$totalItems Items', style: const TextStyle(color: Color(0xFFFF9442), fontWeight: FontWeight.bold)),
              )
            ],
          ),
          const SizedBox(height: 15),
          SizedBox(
            width: double.infinity, height: 50,
            child: ElevatedButton(
              onPressed: () {
                // ✅ TRIGGER POP UP KONFIRMASI SAAT KLIK CHECKOUT
                showDialog(
                  context: context,
                  builder: (context) => const PopupKonfirmasi(),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9442),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Checkout Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({required String name, required String desc, required int price, required int qty, required VoidCallback onAdd, required VoidCallback onRemove, required VoidCallback onDelete}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 70, height: 70, decoration: BoxDecoration(color: const Color(0xFFF6F4E8), borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.fastfood, color: Color(0xFF954A00)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1B1C15))),
                          const SizedBox(height: 4),
                          Text(desc, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: onDelete,
                      child: const Padding(padding: EdgeInsets.only(left: 8.0, bottom: 8.0), child: Icon(Icons.delete_outline, color: Colors.redAccent, size: 22)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _btnQty(Icons.remove, onRemove),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                        _btnQty(Icons.add, onAdd, isAdd: true),
                      ],
                    ),
                    Text('Rp ${(price * qty).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFFFF9442))),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _btnQty(IconData icon, VoidCallback tap, {bool isAdd = false}) {
    return GestureDetector(
      onTap: tap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(color: isAdd ? const Color(0xFFFF9442) : Colors.transparent, shape: BoxShape.circle, border: Border.all(color: const Color(0xFFFF9442), width: 1.5)),
        child: Icon(icon, size: 14, color: isAdd ? Colors.white : const Color(0xFFFF9442)),
      ),
    );
  }

  Widget _buildAddMoreButton() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const MenuFoodScreen())),
      child: Container(
        padding: const EdgeInsets.all(15), width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15), border: Border.all(color: const Color(0xFFFF9442).withOpacity(0.5), width: 1.5), color: const Color(0xFFFFF7ED)),
        child: const Center(child: Text('Add More Items', style: TextStyle(color: Color(0xFFFF9442), fontWeight: FontWeight.bold, fontSize: 16))),
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
            _buildNavItem(Icons.receipt_long_outlined, 'Order', context.widget is MyOrdersPage, () { if (context.widget is! MyOrdersPage) Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyOrdersPage())); }),
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