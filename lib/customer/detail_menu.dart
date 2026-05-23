import 'package:flutter/material.dart';
import '../service/api_service.dart';

class DetailMenuPage extends StatelessWidget {
  final dynamic item;

  const DetailMenuPage({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    int id = int.tryParse(item['id'].toString()) ?? 0;
    String title = item['title'] ?? item['name'] ?? 'Detail Menu';
    
    // Format price if it contains 'Rp'
    String rawPrice = item['price']?.toString() ?? '0';
    String price = rawPrice;
    if (!rawPrice.toLowerCase().contains('rp')) {
      price = "Rp $rawPrice";
    }
    
    String imageUrl = item['image_url'] ?? item['image'] ?? '';
    String description = item['description'] ?? 'Hidangan lezat spesial dari dapur kami yang dibuat dengan bahan-bahan pilihan terbaik. Nikmati kelezatan otentik di setiap gigitan.';

    Widget imageWidget;
    if (imageUrl.isNotEmpty) {
      if (imageUrl.startsWith('http')) {
        imageWidget = Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 100));
      } else {
        imageWidget = Image.network("${ApiService.baseUrl}/uploads/$imageUrl", fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, size: 100));
      }
    } else {
      imageWidget = const Icon(Icons.fastfood, size: 100, color: Colors.grey);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 400.0,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.white,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Hero(
                    tag: 'menu_image_$id', // Tag ini harus sama dengan yang ada di list!
                    child: imageWidget,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  transform: Matrix4.translationValues(0.0, -30.0, 0.0),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Container(
                            width: 50,
                            height: 5,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                title,
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Color(0xFF0F172A),
                                  height: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFFFF9442),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF4EC),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.star, color: Color(0xFFFF9442), size: 16),
                                  SizedBox(width: 4),
                                  Text(
                                    '4.8',
                                    style: TextStyle(
                                      color: Color(0xFFFF9442),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              '(120+ Reviews)',
                              style: TextStyle(
                                color: Color(0xFF64748B),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        const Text(
                          "Deskripsi",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF0F172A),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          description,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Color(0xFF64748B),
                            height: 1.6,
                          ),
                        ),
                        const SizedBox(height: 100), // Ruang kosong untuk tombol bawah
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 20,
                    offset: const Offset(0, -10),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFFF9442),
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  shadowColor: const Color(0xFFFF9442).withValues(alpha: 0.5),
                ),
                child: const Text(
                  "Kembali ke Daftar Menu",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
