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

  // Getter untuk perhitungan otomatis
  int get totalPayment => (qtyMietiaw * priceMietiaw) + (qtyEsBuah * priceEsBuah);
  int get totalItems => qtyMietiaw + qtyEsBuah;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false, 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Color(0xFF562F00)),
        title: const Text(
          'My Cart', 
          style: TextStyle(color: Color(0xFF562F00), fontWeight: FontWeight.bold)
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              
              // Item 1: Mietiaw
              _buildCartItem(
                'Mietiaw Pangsit Njedog',
                'Extra Spicy',
                'Rp ${priceMietiaw.toString()}',
                qtyMietiaw,
                (val) => setState(() => qtyMietiaw = val),
              ),
              const SizedBox(height: 16),
              
              // Item 2: Es Buah
              _buildCartItem(
                'Es Buah Segar',
                'Less Ice',
                'Rp ${priceEsBuah.toString()}',
                qtyEsBuah,
                (val) => setState(() => qtyEsBuah = val),
              ),
              
              const SizedBox(height: 24),
              _buildAddMoreButton(),
              const SizedBox(height: 32),
              
              const Text(
                'Payment Summary', 
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF562F00))
              ),
              const SizedBox(height: 16),
              _buildSummaryRow('Subtotal', 'Rp $totalPayment'),
              _buildSummaryRow('Delivery Fee', 'Free'),
              const Divider(height: 32, color: Color(0x19562F00)),
              _buildSummaryRow('Total Payment', 'Rp $totalPayment', isTotal: true),
              
              const SizedBox(height: 40),
              
              // TOMBOL CHECKOUT (Sudah disambungkan ke Pop-up Konfirmasi)
              ElevatedButton(
                onPressed: () {
                  // Navigasi ke rute /konfirmasi yang ada di main.dart
                  Navigator.pushNamed(context, '/konfirmasi');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9442),
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                  elevation: 0,
                ),
                child: const Text(
                  'Checkout Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              const SizedBox(height: 40), 
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk Item Keranjang
  Widget _buildCartItem(String title, String subtitle, String price, int qty, Function(int) onQtyChanged) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: const Color(0xFFF6F4E8), borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.fastfood, color: Color(0xFFFF9442)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 8),
                Text(price, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9442))),
              ],
            ),
          ),
          Row(
            children: [
              _qtyBtn(Icons.remove, () { if (qty > 1) onQtyChanged(qty - 1); }),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.bold))),
              _qtyBtn(Icons.add, () => onQtyChanged(qty + 1), isAdd: true),
            ],
          )
        ],
      ),
    );
  }

  // Widget Tombol Tambah/Kurang Qty
  Widget _qtyBtn(IconData icon, VoidCallback tap, {bool isAdd = false}) {
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

  // Widget Baris Ringkasan Pembayaran
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: isTotal ? FontWeight.bold : FontWeight.normal)),
        Text(value, style: TextStyle(fontSize: isTotal ? 16 : 14, fontWeight: FontWeight.bold, color: isTotal ? const Color(0xFFFF9442) : Colors.black)),
      ],
    );
  }

  // Widget Tombol Add More
  Widget _buildAddMoreButton() {
    return Container(
      padding: const EdgeInsets.all(15),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.orange.withOpacity(0.5)),
      ),
      child: const Center(
        child: Text(
          'Add More Items', 
          style: TextStyle(color: Color(0xFFFF9442), fontWeight: FontWeight.bold)
        )
      ),
    );
  }
}