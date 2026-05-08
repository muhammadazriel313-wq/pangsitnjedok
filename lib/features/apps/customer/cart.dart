import 'package:flutter/material.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  // Data State untuk Interaktivitas
  int qtyMietiaw = 2;
  int qtyEsBuah = 1;
  int priceMietiaw = 19000;
  int priceEsBuah = 9000;

  int get totalPayment => (qtyMietiaw * priceMietiaw) + (qtyEsBuah * priceEsBuah);
  int get totalItems => qtyMietiaw + qtyEsBuah;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Kita matikan extendBody agar konten otomatis berhenti di atas BottomAppBar
      extendBody: false, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Color(0xFF562F00)),
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
                  _buildCartItem(
                    name: 'Mietiaw Mentai',
                    desc: 'Extra Saus Mentai (+Rp 4.000)',
                    price: priceMietiaw,
                    qty: qtyMietiaw,
                    onAdd: () => setState(() => qtyMietiaw++),
                    onRemove: () => setState(() => qtyMietiaw > 0 ? qtyMietiaw-- : null),
                  ),
                  const SizedBox(height: 16),
                  _buildCartItem(
                    name: 'Es Buah Lecy',
                    desc: 'Regular Size',
                    price: priceEsBuah,
                    qty: qtyEsBuah,
                    onAdd: () => setState(() => qtyEsBuah++),
                    onRemove: () => setState(() => qtyEsBuah > 0 ? qtyEsBuah-- : null),
                  ),
                  const SizedBox(height: 20),
                  _buildAddMoreButton(),
                ],
              ),
            ),
          ),
          _buildPaymentPanel(), // Panel Checkout diletakkan di atas Navigasi
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
floatingActionButton: FloatingActionButton(
  backgroundColor: const Color(0xFFFF9442),
  elevation: 4,
  // Memastikan bentuknya lingkaran sempurna
  shape: const CircleBorder(), 
  onPressed: () {
    // Aksi saat keranjang diklik
  },
  child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
),
      bottomNavigationBar: BottomAppBar(
  color: Colors.white,
  // Memberikan efek lengkungan untuk FloatingActionButton
  shape: const CircularNotchedRectangle(), 
  // Jarak antara lengkungan dengan tombol FAB
  notchMargin: 8, 
  child: SizedBox(
    height: 60, // Tinggi bar navigasi
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        // Item Navigasi Kiri
        _navItem(Icons.home_outlined, 'Home'),
        _navItem(Icons.restaurant_menu_outlined, 'Menu'),
        
        // Spacer (SizedBox) untuk memberi ruang bagi tombol FAB di tengah
        const SizedBox(width: 40), 
        
        // Item Navigasi Kanan
        _navItem(Icons.receipt_long_outlined, 'Orders'),
        _navItem(Icons.person_outline, 'Profile'),
      ],
    ),
  ),
),
    );
  }

  Widget _buildPaymentPanel() {
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
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9442),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text('Checkout Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem({required String name, required String desc, required int price, required int qty, required VoidCallback onAdd, required VoidCallback onRemove}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        children: [
          Container(
            width: 70, height: 70,
            decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.fastfood, color: Colors.grey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF562F00))),
                Text(desc, style: const TextStyle(fontSize: 10, color: Colors.grey)),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _btnQty(Icons.remove, onRemove),
                        Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$qty')),
                        _btnQty(Icons.add, onAdd, isAdd: true),
                      ],
                    ),
                    Text('Rp ${(price * qty).toString()}', style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9442))),
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
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: isAdd ? const Color(0xFFFF9442) : Colors.transparent,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFFF9442)),
        ),
        child: Icon(icon, size: 14, color: isAdd ? Colors.white : const Color(0xFFFF9442)),
      ),
    );
  }

  Widget _buildAddMoreButton() {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: const Center(child: Text('Add More Items', style: TextStyle(color: Color(0xFFFF9442)))),
    );
  }

 Widget _navItem(IconData icon, String label) {
  return InkWell(
    onTap: () {
      // Tambahkan logika pindah halaman di sini
    },
    child: Column(
      mainAxisSize: MainAxisSize.min, // Agar ukuran kolom mengikuti isi
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.grey, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
  );
}
}