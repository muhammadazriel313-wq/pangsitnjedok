import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class RatingsReviewsPage extends StatelessWidget {
  const RatingsReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAEE),
        elevation: 0,
        leading: const Icon(Icons.arrow_back, color: Color(0xFF954A00)),
        title: Text(
          'Ratings & Reviews',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF954A00),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFDAB9),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                'UMAMI VERIFIED',
                style: GoogleFonts.plusJakartaSans(
                  color: const Color(0xFF8B4513),
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // --- Ringkasan Rating ---
                Container(
                  padding: const EdgeInsets.all(32),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF6F4E8),
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text('4.8', style: GoogleFonts.plusJakartaSans(fontSize: 60, fontWeight: FontWeight.w900)),
                          Text('/5', style: GoogleFonts.plusJakartaSans(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.star, color: Colors.orange, size: 28),
                          Icon(Icons.star, color: Colors.orange, size: 28),
                          Icon(Icons.star, color: Colors.orange, size: 28),
                          Icon(Icons.star, color: Colors.orange, size: 28),
                          Icon(Icons.star_half, color: Colors.orange, size: 28),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Based on 1,248 reviews', style: GoogleFonts.beVietnamPro(color: Colors.grey)),
                      const SizedBox(height: 32),
                      _buildRatingBar('5 Star', 0.85, '85%'),
                      _buildRatingBar('4 Star', 0.10, '10%'),
                      _buildRatingBar('3 Star', 0.03, '3%'),
                      _buildRatingBar('2 Star', 0.01, '1%'),
                      _buildRatingBar('1 Star', 0.01, '1%'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- Filter Chips ---
                Row(
                  children: [
                    _buildFilterChip('All Reviews', isActive: true),
                    const SizedBox(width: 12),
                    _buildFilterChip('5 Stars'),
                    const SizedBox(width: 12),
                    _buildFilterChip('4 Stars'),
                  ],
                ),
                const SizedBox(height: 32),

                // --- Daftar Review ---
                const ReviewCard(
                  name: 'Adrian Wijaya',
                  tag: 'VERIFIED UMAMI EATER',
                  date: '2 days ago',
                  content: 'The Mietiaw Mentai is amazing! The balance of spice and creaminess is just perfect. I\'ve tried many mentai dishes, but this one hits differently. Highly recommended!',
                  images: ['https://placehold.co/100x100', 'https://placehold.co/100x100'],
                ),
                const SizedBox(height: 16),
                const ReviewCard(
                  name: 'Siti Rahma',
                  tag: 'GOURMET GUIDE',
                  date: '1 week ago',
                  rating: 4,
                  content: 'Great flavor and portion size. The Njedog Spicy Level 3 is quite kicky, so be careful if you\'re not a fan of heat. Service was fast even during the busy lunch hour.',
                ),
                const SizedBox(height: 16),
                const ReviewCard(
                  name: 'Bambang S.',
                  tag: 'LOCAL CONTRIBUTOR',
                  date: '2 weeks ago',
                  content: 'Best value for money in town. The "Chef\'s Special" dumplings are a must-try. I keep coming back for the consistent quality.',
                ),
                const SizedBox(height: 100), // Spasi agar tidak tertutup tombol bawah
              ],
            ),
          ),

          // --- Tombol Floating Bottom ---
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.rate_review, color: Colors.white),
              label: Text('Write a Review', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF954A00),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 8,
                shadowColor: const Color(0xFF954A00).withOpacity(0.5),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(String label, double value, String percent) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 50, child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: value,
                backgroundColor: const Color(0xFFF0EEE2),
                color: const Color(0xFFFF9644),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 30, child: Text(percent, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey))),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, {bool isActive = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF954A00) : const Color(0xFFEAE8DD),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.plusJakartaSans(
          color: isActive ? Colors.white : Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String name, tag, date, content;
  final int rating;
  final List<String>? images;

  const ReviewCard({
    super.key,
    required this.name,
    required this.tag,
    required this.date,
    required this.content,
    this.rating = 5,
    this.images,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0x19DBC1B2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const CircleAvatar(radius: 24, backgroundImage: NetworkImage('https://placehold.co/100x100')),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                      Text(tag, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
                    ],
                  ),
                ],
              ),
              Text(date, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) => Icon(
              Icons.star, 
              size: 16, 
              color: index < rating ? Colors.orange : Colors.grey[300]
            )),
          ),
          const SizedBox(height: 12),
          Text(content, style: GoogleFonts.beVietnamPro(height: 1.5, color: const Color(0xFF554337))),
          if (images != null) ...[
            const SizedBox(height: 16),
            Row(
              children: images!.map((url) => Padding(
                padding: const EdgeInsets.only(right: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(url, width: 80, height: 80, fit: BoxFit.cover),
                ),
              )).toList(),
            ),
          ]
        ],
      ),
    );
  }
}