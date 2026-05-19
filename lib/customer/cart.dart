import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'popup_konfirmasi.dart';

class _CartItem {
  _CartItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.qty,
  });

  final String title;
  final String subtitle;
  final int price;
  int qty;

  Map<String, dynamic> toJson() {
    return {'title': title, 'subtitle': subtitle, 'price': price, 'qty': qty};
  }

  factory _CartItem.fromJson(Map<String, dynamic> json) {
    final parsedPrice = int.tryParse('${json['price'] ?? 0}') ?? 0;
    final parsedQty = int.tryParse('${json['qty'] ?? 0}') ?? 0;
    return _CartItem(
      title: json['title']?.toString() ?? 'Menu',
      subtitle: json['subtitle']?.toString() ?? '-',
      price: parsedPrice,
      qty: parsedQty < 0 ? 0 : parsedQty,
    );
  }

  _CartItem copy() {
    return _CartItem(title: title, subtitle: subtitle, price: price, qty: qty);
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  static const String _storageKey = 'customer_cart_items_v1';

  // Data default hanya dipakai saat belum ada data tersimpan.
  static final List<_CartItem> _defaultCartItems = [
    _CartItem(
      title: 'Mietiaw Pangsit Njedog',
      subtitle: 'Extra Spicy',
      price: 19000,
      qty: 2,
    ),
    _CartItem(
      title: 'Es Buah Segar',
      subtitle: 'Less Ice',
      price: 9000,
      qty: 1,
    ),
  ];

  // Cache sesi biar perpindahan halaman tetap cepat.
  static final List<_CartItem> _sessionCartItems = [];

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<_CartItem> get _cartItems => CartPage._sessionCartItems;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    _loadCartFromStorage();
  }

  // Getter untuk perhitungan otomatis
  int get totalPayment =>
      _cartItems.fold(0, (sum, item) => sum + (item.qty * item.price));
  int get totalItems => _cartItems.fold(0, (sum, item) => sum + item.qty);

  Future<void> _loadCartFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(CartPage._storageKey);

    List<_CartItem> loadedItems = [];
    if (raw == null || raw.isEmpty) {
      loadedItems = CartPage._defaultCartItems
          .map((item) => item.copy())
          .toList();
    } else {
      try {
        final decoded = jsonDecode(raw);
        if (decoded is List) {
          loadedItems = decoded
              .whereType<Map>()
              .map(
                (item) => _CartItem.fromJson(Map<String, dynamic>.from(item)),
              )
              .toList();
        }
      } catch (_) {
        loadedItems = CartPage._defaultCartItems
            .map((item) => item.copy())
            .toList();
      }
    }

    if (!mounted) return;
    setState(() {
      _cartItems
        ..clear()
        ..addAll(loadedItems.where((item) => item.qty > 0));
      _isInitializing = false;
    });

    // Pastikan state terbaru tersimpan permanen.
    await _saveCartToStorage();
  }

  Future<void> _saveCartToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = _cartItems.map((item) => item.toJson()).toList();
    await prefs.setString(CartPage._storageKey, jsonEncode(payload));
  }

  void _updateQty(int index, int newQty) {
    setState(() {
      if (newQty <= 0) {
        _cartItems.removeAt(index);
      } else {
        _cartItems[index].qty = newQty;
      }
    });
    _saveCartToStorage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF562F00)),
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/dashboard_menu');
            }
          },
        ),
        title: const Text(
          'My Cart',
          style: TextStyle(
            color: Color(0xFF562F00),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: _isInitializing
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF9442)),
            )
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),

                    if (_cartItems.isEmpty)
                      _buildEmptyCartState()
                    else
                      ...List.generate(_cartItems.length, (index) {
                        final item = _cartItems[index];
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: index == _cartItems.length - 1 ? 0 : 16,
                          ),
                          child: _buildCartItem(
                            item: item,
                            onQtyChanged: (val) => _updateQty(index, val),
                          ),
                        );
                      }),

                    const SizedBox(height: 24),
                    _buildAddMoreButton(),
                    const SizedBox(height: 32),

                    const Text(
                      'Payment Summary',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF562F00),
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildSummaryRow('Subtotal', 'Rp $totalPayment'),
                    _buildSummaryRow('Delivery Fee', 'Free'),
                    const Divider(height: 32, color: Color(0x19562F00)),
                    _buildSummaryRow(
                      'Total Payment',
                      'Rp $totalPayment',
                      isTotal: true,
                    ),

                    const SizedBox(height: 40),

                    // TOMBOL CHECKOUT (Sudah disambungkan ke Pop-up Konfirmasi)
                    ElevatedButton(
                      onPressed: () {
                        if (totalItems == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Keranjang kosong, tambahkan item dulu.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }
                        
                        // PERUBAHAN DI SINI: 
                        // Langsung memanggil class PopupKonfirmasi() tanpa lewat rute main.dart
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const PopupKonfirmasi()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFF9442),
                        minimumSize: const Size(double.infinity, 55),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Checkout Now',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
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
  Widget _buildCartItem({
    required _CartItem item,
    required ValueChanged<int> onQtyChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4E8),
              borderRadius: BorderRadius.circular(15),
            ),
            child: const Icon(Icons.fastfood, color: Color(0xFFFF9442)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(
                  item.subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${item.price}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFF9442),
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _qtyBtn(Icons.remove, () {
                if (item.qty > 0) onQtyChanged(item.qty - 1);
              }),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Text(
                  '${item.qty}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              _qtyBtn(Icons.add, () => onQtyChanged(item.qty + 1), isAdd: true),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartState() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Column(
        children: [
          Icon(
            Icons.remove_shopping_cart_outlined,
            color: Color(0xFFFF9442),
            size: 36,
          ),
          SizedBox(height: 10),
          Text(
            'Keranjang kamu kosong',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF562F00),
            ),
          ),
          SizedBox(height: 4),
          Text(
            'Tambahkan menu dulu ya.',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
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
        child: Icon(
          icon,
          size: 14,
          color: isAdd ? Colors.white : const Color(0xFFFF9442),
        ),
      ),
    );
  }

  // Widget Baris Ringkasan Pembayaran
  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 16 : 14,
            fontWeight: FontWeight.bold,
            color: isTotal ? const Color(0xFFFF9442) : Colors.black,
          ),
        ),
      ],
    );
  }

  // Widget Tombol Add More
  Widget _buildAddMoreButton() {
    return GestureDetector(
      onTap: () => Navigator.pushReplacementNamed(context, '/dashboard_menu'),
      child: Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          border: Border.all(color: Colors.orange.withOpacity(0.5)),
        ),
        child: const Center(
          child: Text(
            'Add More Items',
            style: TextStyle(
              color: Color(0xFFFF9442),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
