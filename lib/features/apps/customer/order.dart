import 'package:flutter/material.dart';

void main() {
  runApp(const FigmaToCodeApp());
}

class FigmaToCodeApp extends StatelessWidget {
  const FigmaToCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Plus Jakarta Sans',
        scaffoldBackgroundColor: const Color(0xFFFCFAEE),
      ),
      home: const MyOrdersPage(),
    );
  }
}

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  bool isActiveTab = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Orders',
          style: TextStyle(color: Color(0xFF1B1C15), fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      body: Column(
        children: [
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
      // --- Bottom Navigation Bar ---
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFFF9442),
        shape: const CircleBorder(),
        onPressed: () {},
        child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 8,
        child: SizedBox(
          height: 60,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _navItem(Icons.home_outlined, 'Home', false),
              _navItem(Icons.restaurant_menu_outlined, 'Menu', false),
              const SizedBox(width: 40),
              _navItem(Icons.receipt_long, 'Orders', true),
              _navItem(Icons.person_outline, 'Profile', false),
            ],
          ),
        ),
      ),
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
    return Column(
      children: [
        _buildActiveOrderCard(
          queueNumber: 'A-12',
          status: 'Processing',
          statusColor: const Color(0xFFFF9442),
          itemName: 'Spicy Umami Pangsit (XL)',
          itemImage: 'https://via.placeholder.com/64',
          price: 'Rp 45.000',
          paymentStatus: 'PAID VIA QRIS',
          details: 'Extra Chili Oil • Toasted Garlic',
          bottomInfo: const Row(
            children: [
              Icon(Icons.access_time, size: 16, color: Color(0xFF554337)),
              SizedBox(width: 8),
              Text('Est. Completion', style: TextStyle(fontSize: 12, color: Color(0xFF554337))),
              Spacer(),
              Text('8 mins left', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _buildActiveOrderCard(
          queueNumber: 'A-15',
          status: 'Waiting\nConfirmation',
          statusColor: const Color(0xFF7B572C),
          itemName: 'Njedog Special Ramen',
          itemImage: 'https://picsum.photos/100',
          price: 'Rp 52.000',
          paymentStatus: 'WAITING PAYMENT',
          details: 'Soft Boiled Egg • Seaweed',
          bottomInfo: const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.info_outline, size: 18, color: Color(0xFF954A00)),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Your order is being reviewed by the chef. Please stay nearby for pickup notification.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF554337), height: 1.5),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        _buildCravingBanner(), // Panggil banner di sini
        const SizedBox(height: 80), 
      ],
    );
  }

  Widget _buildHistoryContent() {
    return Column(
      children: [
        _buildHistoryCard('#A-242', 'COMPLETED', 'Rp 42.000', '1x Pangsit Njedog Original', const Color(0xFFFFCF9A)),
        const SizedBox(height: 16),
        _buildHistoryCard('#B-019', 'COMPLETED', 'Rp 58.000', '2x Pangsit Special Umami', const Color(0xFFFFCF9A)),
        const SizedBox(height: 16),
        _buildHistoryCard('#A-991', 'CANCELLED', 'Rp 22.000', '1x Mie Ayam Njedog', const Color(0xFFFFDAD6), isCancelled: true),
        const SizedBox(height: 30),
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
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
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
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.5)),
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
      child: Image.network(
        itemImage,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        // Tambahkan errorBuilder agar jika gambar gagal, aplikasi tidak rusak
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: 64,
            height: 64,
            color: Colors.grey[300],
            child: const Icon(Icons.broken_image, color: Colors.grey),
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
        boxShadow: [const BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
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
          if (isCancelled) ...[
            const SizedBox(height: 8),
            const Text("Reason: Customer cancelled before preparation.", style: TextStyle(color: Colors.red, fontSize: 10, fontWeight: FontWeight.w500)),
          ]
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
                  style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 13)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
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
            child: Icon(Icons.restaurant, size: 80, color: Colors.white.withOpacity(0.1)),
          )
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: isActive ? const Color(0xFFFF9442) : Colors.grey),
        Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFFFF9442) : Colors.grey)),
      ],
    );
  }
}