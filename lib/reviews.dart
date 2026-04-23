import 'package:flutter/material.dart';

void main() {
  runApp(const ReviewsApp());
}

class ReviewsApp extends StatelessWidget {
  const ReviewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light().copyWith(
        scaffoldBackgroundColor: const Color(0xFFFCFAEE),
      ),
      home: const WriteAReviewScreen(),
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
  bool _submitted = false;

  final List<String> tags = [
    'Taste',
    'Packaging',
    'Portion Size',
    'Value for Money',
  ];

  final List<String> starLabels = [
    '',
    'Terrible',
    'Bad',
    'Okay',
    'Good',
    'Amazing!',
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

  void _submitReview() {
    if (selectedStars == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Silakan beri rating bintang terlebih dahulu!'),
          backgroundColor: Colors.red[700],
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _submitted = true);

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
              width: 72,
              height: 72,
              decoration: const ShapeDecoration(
                color: Color(0xFFFFCF9A),
                shape: CircleBorder(),
              ),
              child: const Icon(Icons.check_rounded, color: Color(0xFF954A00), size: 40),
            ),
            const SizedBox(height: 20),
            const Text(
              'Thank you for your\nreview!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF1B1C15),
                fontSize: 22,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Your feedback helps us cook better for you. We appreciate your time!',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xFF554337),
                fontSize: 14,
                fontFamily: 'Be Vietnam Pro',
                fontWeight: FontWeight.w400,
                height: 1.57,
              ),
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () {
                Navigator.of(ctx).pop();
                setState(() {
                  selectedStars = 0;
                  selectedTags = {};
                  _reviewController.clear();
                  charCount = 0;
                  _submitted = false;
                });
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: ShapeDecoration(
                  color: const Color(0xFF954A00),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Back to Home',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                  ),
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
          // Top App Bar
          Container(
            color: const Color(0xFFFCFAEE),
            padding: const EdgeInsets.only(top: 52, left: 16, right: 16, bottom: 12),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    child: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF954A00),
                      size: 24,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Rate Your Order',
                  style: TextStyle(
                    color: Color(0xFF954A00),
                    fontSize: 18,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.56,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),

                  // Order Card
                  _buildOrderCard(),
                  const SizedBox(height: 32),

                  // Star Rating Section
                  _buildStarRatingSection(),
                  const SizedBox(height: 32),

                  // Tags Section
                  _buildTagsSection(),
                  const SizedBox(height: 32),

                  // Text Review Section
                  _buildTextReviewSection(),
                  const SizedBox(height: 32),

                  // Submit Button
                  _buildSubmitButton(),
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
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28),
        ),
        shadows: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: const Color(0xFFF0EEE2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Image.network(
              'https://images.unsplash.com/photo-1496116218417-1a781b1c416c?w=80&h=80&fit=crop',
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(
                Icons.restaurant,
                size: 40,
                color: Color(0xFF954A00),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Pangsit Njedog\nSpesial',
                  style: TextStyle(
                    color: Color(0xFF954A00),
                    fontSize: 18,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w700,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Order #PN-88291 •\nYesterday',
                  style: TextStyle(
                    color: Color(0xFF554337),
                    fontSize: 14,
                    fontFamily: 'Be Vietnam Pro',
                    fontWeight: FontWeight.w500,
                    height: 1.43,
                  ),
                ),
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
        const Center(
          child: Text(
            'How was your meal?',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF1B1C15),
              fontSize: 24,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w800,
              height: 1.33,
            ),
          ),
        ),
        const SizedBox(height: 8),
        const Center(
          child: Text(
            'Your feedback helps us cook better for you!',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Color(0xFF554337),
              fontSize: 16,
              fontFamily: 'Be Vietnam Pro',
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // Star Row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            final starIndex = index + 1;
            final isFilled = starIndex <= selectedStars;
            return GestureDetector(
              onTap: () => setState(() => selectedStars = starIndex),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: AnimatedScale(
                  scale: isFilled ? 1.15 : 1.0,
                  duration: const Duration(milliseconds: 150),
                  child: Icon(
                    isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
                    color: isFilled ? const Color(0xFFFF9442) : const Color(0xFFD4CEBD),
                    size: 52,
                  ),
                ),
              ),
            );
          }),
        ),

        // Star label
        if (selectedStars > 0) ...[
          const SizedBox(height: 8),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 200),
            child: Text(
              starLabels[selectedStars],
              key: ValueKey(selectedStars),
              style: const TextStyle(
                color: Color(0xFFFF9442),
                fontSize: 15,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTagsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'WHAT DID YOU LOVE MOST?',
            style: TextStyle(
              color: Color(0xFF887366),
              fontSize: 11,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.50,
              letterSpacing: 1.10,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: tags.map((tag) {
            final isSelected = selectedTags.contains(tag);
            return GestureDetector(
              onTap: () => _toggleTag(tag),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 11),
                decoration: ShapeDecoration(
                  color: isSelected ? const Color(0xFFFFCF9A) : const Color(0xFFF6F4E8),
                  shape: RoundedRectangleBorder(
                    side: isSelected
                        ? BorderSide.none
                        : const BorderSide(width: 1, color: Color(0xFFE4E3D7)),
                    borderRadius: BorderRadius.circular(9999),
                  ),
                  shadows: isSelected
                      ? [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          )
                        ]
                      : [],
                ),
                child: Text(
                  tag,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFF7A562B) : const Color(0xFF554337),
                    fontSize: 14,
                    fontFamily: 'Plus Jakarta Sans',
                    fontWeight: FontWeight.w600,
                    height: 1.43,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTextReviewSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 4),
          child: Text(
            'TELL US MORE',
            style: TextStyle(
              color: Color(0xFF887366),
              fontSize: 11,
              fontFamily: 'Plus Jakarta Sans',
              fontWeight: FontWeight.w700,
              height: 1.50,
              letterSpacing: 1.10,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          decoration: ShapeDecoration(
            color: const Color(0xFFF6F4E8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Stack(
            children: [
              TextField(
                controller: _reviewController,
                maxLength: 1000,
                maxLines: 7,
                style: const TextStyle(
                  color: Color(0xFF1B1C15),
                  fontSize: 16,
                  fontFamily: 'Be Vietnam Pro',
                  fontWeight: FontWeight.w400,
                  height: 1.50,
                ),
                decoration: const InputDecoration(
                  hintText: 'Write your feedback here...',
                  hintStyle: TextStyle(
                    color: Color(0xFF887366),
                    fontSize: 16,
                    fontFamily: 'Be Vietnam Pro',
                    fontWeight: FontWeight.w400,
                    height: 1.50,
                  ),
                  counterText: '',
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(
                    top: 24,
                    left: 24,
                    right: 24,
                    bottom: 48,
                  ),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 16,
                child: Text(
                  '$charCount/1000',
                  style: const TextStyle(
                    color: Color(0xFF887366),
                    fontSize: 12,
                    fontFamily: 'Be Vietnam Pro',
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _submitReview,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: ShapeDecoration(
          color: const Color(0xFF954A00),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          shadows: [
            BoxShadow(
              color: const Color(0xFF954A00).withOpacity(0.35),
              blurRadius: 20,
              offset: const Offset(0, 10),
              spreadRadius: -4,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Submit Review',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontFamily: 'Plus Jakarta Sans',
                fontWeight: FontWeight.w800,
                height: 1.56,
              ),
            ),
            SizedBox(width: 10),
            Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ],
        ),
      ),
    );
  }
}