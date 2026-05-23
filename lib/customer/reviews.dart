import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; 
import 'dart:convert';
import 'rating_views.dart'; 
// ✅ IMPORT SUDAH DIALAHKAN KE DASHBOARD MENU
import 'dashboard_menu.dart'; 
import '../service/api_service.dart';

class ReviewsApp extends StatefulWidget {
  const ReviewsApp({super.key});

  @override
  State<ReviewsApp> createState() => _ReviewsAppState();
}

class _ReviewsAppState extends State<ReviewsApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, 
      home: WriteAReviewScreen(),
    );
  }
}

class WriteAReviewScreen extends StatefulWidget {
  const WriteAReviewScreen({super.key});

  @override
  State<WriteAReviewScreen> createState() => _WriteAReviewScreenState();
}

class _WriteAReviewScreenState extends State<WriteAReviewScreen> {
  int selectedStars = 4;
  int hoveredStar = 0;
  Set<String> selectedTags = {'Taste', 'Portion Size'};
  final TextEditingController _reviewController = TextEditingController();
  int charCount = 0;
  bool _isSubmitting = false; 

  final List<String> tags = [
    'Taste',
    'Packaging',
    'Portion Size',
    'Value for Money',
  ];

  @override
  void initState() {
    super.initState();
    _reviewController.addListener(() {
      setState(() {
        charCount = _reviewController.text.length;
      });
    });
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (selectedTags.contains(tag)) {
        selectedTags.remove(tag);
      } else {
        selectedTags.add(tag);
      }
    });
  }

  Future<void> _submitReview() async {
    if (selectedStars == 0) {
      if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please give a star rating first!'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      String combinedTags = selectedTags.isEmpty ? "REGULAR" : selectedTags.join(", ");

      final Map<String, dynamic> dataYangDikirim = {
        "customer_id": "1", 
        "rating": selectedStars.toString(),
        "tag": combinedTags,
        "content": _reviewController.text,
      };

      final response = await http.post(
        Uri.parse("${ApiService.baseUrl}/submit_review.php"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(dataYangDikirim), 
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result['status'] == 'success') {
          _showSuccessDialog();
        } else {
          if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed: ${result['message']}')),
          );
        }
      }
    } catch (e) {
      if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Network error: $e')),
      );
    } finally {
      setState(() => _isSubmitting = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        backgroundColor: const Color(0xFFFCFAEE),
        contentPadding: const EdgeInsets.all(32),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72, height: 72,
              decoration: const ShapeDecoration(color: Color(0xFFFFCF9A), shape: CircleBorder()),
              child: const Icon(Icons.check_rounded, color: Color(0xFF954A00), size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for your\nreview!',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF1B1C15), fontSize: 22, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w800, height: 1.35),
            ),
            
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop(); // Tutup pop-up dialog
                
                // ✅ SEKARANG SUDAH MENGARAH KE DASHBOARD PAGE & MENGHAPUS RIWAYAT HALAMAN SEBELUMNYA
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardPage()), 
                  (Route<dynamic> route) => false,
                );
              },
              child: Container(
                width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: ShapeDecoration(
                  color: const Color(0xFF954A00),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  'Back to Home',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFFCFAEE),
            padding: const EdgeInsets.only(top: 52, left: 16, right: 16, bottom: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RatingViewsPage()));
                  },
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(Icons.arrow_back, color: Color(0xFF954A00), size: 24),
                  ),
                ),
                const SizedBox(width: 12),
                const Text('Rate Your Order', style: TextStyle(color: Color(0xFF954A00), fontSize: 18, fontFamily: 'Plus Jakarta Sans', fontWeight: FontWeight.w700)),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildOrderCard(),
                  const SizedBox(height: 32),
                  _buildStarRatingSection(),
                  const SizedBox(height: 32),
                  _buildTagsSection(),
                  const SizedBox(height: 32),
                  _buildTextReviewSection(),
                  const SizedBox(height: 32),
                  _isSubmitting 
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFF954A00)))
                    : _buildSubmitButton(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard() {
    return Container(
      width: double.infinity, padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        shadows: [BoxShadow(color: Colors.black.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Row(
        children: [
          Container(
            width: 80, height: 80,
            decoration: BoxDecoration(color: const Color(0xFFF0EEE2), borderRadius: BorderRadius.circular(16)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.asset('assets/images/ptulangrangu.jpeg', fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.fastfood, color: Colors.grey)),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Pangsit Njedog\nSpesial', style: TextStyle(color: Color(0xFF954A00), fontSize: 18, fontWeight: FontWeight.bold)),
                Text('Order #PN-88291', style: TextStyle(color: Color(0xFF554337), fontSize: 14)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarRatingSection() {
    return Column(
      children: [
        const Center(child: Text('How was your meal?', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800))),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= selectedStars;
            return GestureDetector(
              onTap: () => setState(() => selectedStars = starIndex),
              child: Icon(
                isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                color: isFilled ? const Color(0xFFFF9442) : const Color(0xFFD4CEBD),
                size: 52,
              ),
            );
          }),
        ),
      ],
    );
  }

  Widget _buildTagsSection() {
    return Wrap(
      spacing: 10,
      children: tags.map((tag) {
        final isSelected = selectedTags.contains(tag);
        return GestureDetector(
          onTap: () => _toggleTag(tag),
          child: Chip(
            label: Text(tag),
            backgroundColor: isSelected ? const Color(0xFFFFCF9A) : const Color(0xFFF6F4E8),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTextReviewSection() {
    return TextField(
      controller: _reviewController,
      maxLines: 5,
      decoration: InputDecoration(
        hintText: 'Write your feedback here...',
        filled: true,
        fillColor: const Color(0xFFF6F4E8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24), borderSide: BorderSide.none),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: _submitReview,
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFF9442),
        minimumSize: const Size(double.infinity, 60),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      ),
      child: const Text('Submit Review', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    );
  }
}