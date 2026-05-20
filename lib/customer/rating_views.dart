import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'reviews.dart'; 

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

  String _selectedFilter = 'All Reviews'; 

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    setState(() => _isLoading = true);
    try {
      // ✅ URL SUDAH BENAR
      final response = await http.get(
        Uri.parse("http://localhost/pangsit_njedok_api/get_reviews.php?t=${DateTime.now().millisecondsSinceEpoch}"), 
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

        if (mounted) {
          setState(() {
            _reviews = data;
            _totalReviews = total;
            _averageRating = total > 0 ? sum / total : 0.0;
            _starCounts = counts;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      debugPrint("Error koneksi: $e"); 
      if (mounted) setState(() => _isLoading = false);
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

  void _onFilterTapped(String filterName) {
    setState(() {
      _selectedFilter = filterName;
    });
  }

  List<dynamic> _getFilteredReviews() {
    if (_selectedFilter == 'All Reviews') return _reviews;
    if (_selectedFilter == '5 Stars') return _reviews.where((r) => int.tryParse(r['rating'].toString()) == 5).toList();
    if (_selectedFilter == '4 Stars') return _reviews.where((r) => int.tryParse(r['rating'].toString()) == 4).toList();
    if (_selectedFilter == '3 Stars') return _reviews.where((r) => int.tryParse(r['rating'].toString()) == 3).toList();
    if (_selectedFilter == '2 Stars') return _reviews.where((r) => int.tryParse(r['rating'].toString()) == 2).toList();
    if (_selectedFilter == '1 Star') return _reviews.where((r) => int.tryParse(r['rating'].toString()) == 1).toList();
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
          onPressed: () => Navigator.pop(context), 
        ),
        title: Text(
          'Ratings & Reviews',
          style: GoogleFonts.plusJakartaSans(color: const Color(0xFF954A00), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              children: [
                // --- KOTAK RINGKASAN RATING ---
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
                            style: GoogleFonts.plusJakartaSans(fontSize: 56, fontWeight: FontWeight.w900, color: const Color(0xFF1B1C15))
                          ),
                          Text('/5', style: GoogleFonts.plusJakartaSans(fontSize: 24, color: Colors.grey, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          return Icon(
                            index < _averageRating.floor() ? Icons.star : (index < _averageRating.round() ? Icons.star_half : Icons.star_border),
                            color: const Color(0xFFFF9442), 
                            size: 28
                          );
                        }),
                      ),
                      const SizedBox(height: 8),
                      Text('Based on $_totalReviews reviews', style: GoogleFonts.beVietnamPro(color: const Color(0xFF94A3B8))),
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

                // --- FILTER CHIPS ---
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
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
                const SizedBox(height: 24),

                // --- DAFTAR REVIEW ---
                if (_isLoading)
                  const Padding(padding: EdgeInsets.only(top: 40), child: CircularProgressIndicator(color: Color(0xFFFF9442)))
                else if (filteredReviews.isEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 40),
                    child: Text('Belum ada ulasan untuk $_selectedFilter.', style: const TextStyle(color: Colors.grey)),
                  )
                else
                  ...filteredReviews.map((item) {
                    List<String>? reviewImages;
                    if (item['images'] != null && (item['images'] as List).isNotEmpty) {
                      reviewImages = List<String>.from(item['images']);
                    }

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16),
                      child: ReviewCard(
                        name: item['name'] ?? 'Pecinta Pangsit',
                        tag: item['customer_tag'] ?? 'MEMBER',
                        date: _formatDate(item['created_at'] ?? DateTime.now().toString()), 
                        rating: int.tryParse(item['rating'].toString()) ?? 5,
                        content: item['content'] ?? '',
                        images: reviewImages,
                      ),
                    );
                  }),

                const SizedBox(height: 100), 
              ],
            ),
          ),

          // --- TOMBOL WRITE REVIEW ---
          Positioned(
            bottom: 30, left: 24, right: 24,
            child: ElevatedButton.icon(
              onPressed: () async {
                await Navigator.push(context, MaterialPageRoute(builder: (context) => const ReviewsApp()));
                _fetchReviews();
              },
              icon: const Icon(Icons.rate_review_outlined, color: Colors.white),
              label: Text('Write a Review', style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9442), 
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 8,
                shadowColor: const Color(0xFFFF9442).withOpacity(0.4), 
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
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 45, child: Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF554337)))),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: proportion,
                backgroundColor: const Color(0xFFEAE8DD),
                color: const Color(0xFFFF9442),
                minHeight: 8,
              ),
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(width: 35, child: Text(percentage, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8), fontWeight: FontWeight.bold))),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label) {
    bool isActive = _selectedFilter == label; 
    return GestureDetector(
      onTap: () => _onFilterTapped(label), 
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFFFF9442) : const Color(0xFFEAE8DD), 
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            color: isActive ? Colors.white : const Color(0xFF554337),
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const CircleAvatar(
                    radius: 22, 
                    backgroundImage: AssetImage('assets/images/nipis.jpeg'), 
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name, style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16, color: const Color(0xFF1B1C15))),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(color: const Color(0xFFFFEDD5), borderRadius: BorderRadius.circular(8)),
                        child: Text(tag, style: GoogleFonts.plusJakartaSans(fontSize: 10, fontWeight: FontWeight.bold, color: const Color(0xFF954A00))),
                      ),
                    ],
                  ),
                ],
              ),
              Row(
                children: [
                  Text(date, style: GoogleFonts.plusJakartaSans(fontSize: 12, color: const Color(0xFF94A3B8), fontWeight: FontWeight.w600)),
                  const SizedBox(width: 8),
                  const Icon(Icons.more_horiz, color: Color(0xFF94A3B8), size: 20),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: List.generate(5, (index) => Icon(
              Icons.star, size: 18, 
              color: index < rating ? const Color(0xFFFF9442) : const Color(0xFFEAE8DD),
            )),
          ),
          const SizedBox(height: 12),
          Text(content, style: GoogleFonts.beVietnamPro(height: 1.5, color: const Color(0xFF554337), fontSize: 14)),
          
          if (images != null && images!.isNotEmpty) ...[
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: images!.map((url) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(url, width: 80, height: 80, fit: BoxFit.cover, errorBuilder: (_,__,___) => Container(width: 80, height: 80, color: Colors.grey[200], child: const Icon(Icons.image, color: Colors.grey))),
                  ),
                )).toList(),
              ),
            ),
          ],
          
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFF6F4E8), thickness: 1.5),
          ),
          
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF6F4E8),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.thumb_up_outlined, size: 16, color: Color(0xFF554337)),
                    const SizedBox(width: 6),
                    Text('Helpful?', style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF554337))),
                  ],
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}