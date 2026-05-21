import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'reviews.dart';



void main() {
  runApp(const RatingViewsPage());
}

class RatingViewsPage extends StatefulWidget {
  const RatingViewsPage({super.key});

  @override
  State<RatingViewsPage> createState() => _RatingViewsPageState();
}

class _RatingViewsPageState extends State<RatingViewsPage> {
  List<dynamic> _reviews = [];
  bool _isLoading = true;

  double _averageRating = 0.0;
  int _totalReviews = 0;
  List<int> _starCounts = [0, 0, 0, 0, 0];

  // --- VARIABEL BARU UNTUK FILTER INTERAKTIF ---
  String _selectedFilter = 'All Reviews'; // Default: Semua Ulasan

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() => _isLoading = true);
    try {
      final response = await http.get(
        Uri.parse("http://127.0.0.1/pangsit_api/get_reviews.php?t=${DateTime.now().millisecondsSinceEpoch}"), 
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        
        int total = data.length;
        double sum = 0;
        List<int> counts = [0, 0, 0, 0, 0];

        for (var review in data) {
          int rating = int.tryParse(review['rating'].toString()) ?? 0;
          if (rating >= 1 && rating <= 5) {
            sum += rating;
            counts[rating - 1]++;
          }
        }

        setState(() {
          _reviews = data;
          _totalReviews = total;
          _averageRating = total > 0 ? sum / total : 0.0;
          _starCounts = counts;
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error koneksi: $e"); // ✅ Diganti jadi debugPrint
      setState(() => _isLoading = false);
    }
  }

  String _formatDate(String datetime) {
    try {
      DateTime dt = DateTime.parse(datetime);
      return "${dt.day}-${dt.month}-${dt.year}";
    } catch (e) {
      return datetime;
    }
  }

  // --- FUNGSI BARU: Untuk mengubah status filter yang aktif ---
  void _onFilterTapped(String filterName) {
    setState(() {
      _selectedFilter = filterName;
    });
  }

  // --- FUNGSI BARU: Untuk menyaring data ulasan berdasarkan filter aktif ---
  List<dynamic> _getFilteredReviews() {
    if (_selectedFilter == 'All Reviews') {
      return _reviews;
    } else if (_selectedFilter == '5 Stars') {
      return _reviews.where((review) => int.tryParse(review['rating'].toString()) == 5).toList();
    } else if (_selectedFilter == '4 Stars') {
      return _reviews.where((review) => int.tryParse(review['rating'].toString()) == 4).toList();
    } else if (_selectedFilter == '3 Stars') {
      return _reviews.where((review) => int.tryParse(review['rating'].toString()) == 3).toList();
    } else if (_selectedFilter == '2 Stars') {
      return _reviews.where((review) => int.tryParse(review['rating'].toString()) == 2).toList();
    } else if (_selectedFilter == '1 Star') {
      return _reviews.where((review) => int.tryParse(review['rating'].toString()) == 1).toList();
    }
    return _reviews;
  }

  @override
  Widget build(BuildContext context) {
    List<dynamic> filteredReviews = _getFilteredReviews();

    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),   
      appBar: AppBar(
        backgroundColor: const Color(0xFFFCFAEE),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF954A00)),
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          onPressed: () {
            if (Navigator.canPop(context)) {
              Navigator.pop(context);
            } else {
              Navigator.pushReplacementNamed(context, '/profil_customer');
            }
          },
        ),
        title: Text(
          'Ratings & Reviews',
          style: GoogleFonts.plusJakartaSans(
            color: const Color(0xFF954A00),
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                // --- Ringkasan Rating Dinamis ---
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
                          Text(
                            _averageRating.toStringAsFixed(1),
                            style: GoogleFonts.plusJakartaSans(fontSize: 60, fontWeight: FontWeight.w900)
                          ),
                          Text('/5', style: GoogleFonts.plusJakartaSans(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < _averageRating.floor() 
                                ? Icons.star 
                                : (index < _averageRating.round() ? Icons.star_half : Icons.star_border),
                            color: Colors.orange, 
                            size: 28
                          );
                        }),
                      ),
                      
                      const SizedBox(height: 8),
                      Text('Based on $_totalReviews reviews', style: GoogleFonts.beVietnamPro(color: Colors.grey)),
                      const SizedBox(height: 32),
                      
                      _buildDynamicRatingBar('5 Star', 4),
                      _buildDynamicRatingBar('4 Star', 3),
                      _buildDynamicRatingBar('3 Star', 2),
                      _buildDynamicRatingBar('2 Star', 1),
                      _buildDynamicRatingBar('1 Star', 0),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- Filter Chips (Sudah Interaktif) ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal, // Memastikan bisa di-scroll ke samping jika tombolnya banyak
                  child: Row(
                    children: [
                      _buildFilterChip('All Reviews'),
                      const SizedBox(width: 12),
                      _buildFilterChip('5 Stars'),
                      const SizedBox(width: 12),
                      _buildFilterChip('4 Stars'),
                      const SizedBox(width: 12),
                      _buildFilterChip('3 Stars'),
                      const SizedBox(width: 12),
                      _buildFilterChip('2 Stars'),
                      const SizedBox(width: 12),
                      _buildFilterChip('1 Star'),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // --- Daftar Review (Menggunakan filteredReviews) ---
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: CircularProgressIndicator(color: Color(0xFFFF9442)), // Warna loading indikator oranye
                  )
                else if (filteredReviews.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text(
                      'Belum ada ulasan untuk $_selectedFilter.', 
                      style: const TextStyle(color: Colors.grey)
                    ),
                  )
                else
                  ...filteredReviews.map((item) {
                    List<String>? reviewImages;
                    if (item['images'] != null && (item['images'] as List).isNotEmpty) {
                      reviewImages = List<String>.from(item['images']);
                    }

                    return Column(
                      children: [
                        ReviewCard(
                          name: item['name'] ?? 'Unknown User',
                          tag: item['customer_tag'] ?? 'MEMBER',
                          date: _formatDate(item['created_at']), 
                          rating: int.tryParse(item['rating'].toString()) ?? 5,
                          content: item['content'] ?? '',
                          images: reviewImages,
                        ),
                        const SizedBox(height: 16),
                      ],
                    );
                  }),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // --- Tombol Floating Bottom ---
          Positioned(
            bottom: 30,
            left: 24,
            right: 24,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const ReviewsApp()),
                );
                _fetchReviews();
              },
              icon: const Icon(Icons.rate_review, color: Colors.white),
              label: Text('Write a Review', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9442), //  Warna Oranye
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 8,
                shadowColor: const Color(0xFFFF9442).withValues(alpha: 0.5), // ✅ Diganti jadi withValues
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDynamicRatingBar(String label, int starIndex) {
    double proportion = _totalReviews > 0 ? _starCounts[starIndex] / _totalReviews : 0.0;
    String percentage = '${(proportion * 100).round()}%';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 50, child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: proportion,
                backgroundColor: const Color(0xFFF0EEE2),
                color: const Color(0xFFFF9644),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 30, child: Text(percentage, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey))),
        ],
      ),
    );
  }

  // --- WIDGET DIPERBARUI: Filter Chip dengan interaksi GestureDetector dan Warna Oranye ---
  Widget _buildFilterChip(String label) {
    // Cek apakah label ini sama dengan filter yang sedang aktif
    bool isActive = _selectedFilter == label; 

    return GestureDetector(
      onTap: () => _onFilterTapped(label), // Memanggil fungsi ubah filter saat diklik
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF9442) : const Color(0xFFEAE8DD), // PERUBAHAN WARNA: Oranye jika aktif
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
      ),
    );
  }
}

// Widget ReviewCard tetap sama seperti sebelumnya
class ReviewCard extends StatefulWidget {
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
  State<ReviewCard> createState() => _ReviewCardState();
}

class _ReviewCardState extends State<ReviewCard> {
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
                      Text(widget.name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold)),
                      Text(widget.tag, style: GoogleFonts.plusJakartaSans(fontSize: 10, color: Colors.grey, letterSpacing: 1)),
                    ],
                  ),
                ],
              ),
              Text(widget.date, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(5, (index) => Icon(
              Icons.star, 
              size: 16, 
              color: index < widget.rating ? Colors.orange : Colors.grey[300],
            )),
          ),
          const SizedBox(height: 12),
          Text(widget.content, style: GoogleFonts.beVietnamPro(height: 1.5, color: const Color(0xFF554337))),
          if (widget.images != null) ...[
            const SizedBox(height: 16),
            Row(
              children: widget.images!.map((url) => Padding(
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
