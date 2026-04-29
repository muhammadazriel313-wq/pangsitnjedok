import 'dart:typed_data'; // <-- TAMBAHAN BARU: Untuk membaca data bytes di Web
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class TambahMenu extends StatefulWidget {
  const TambahMenu({super.key});

  @override
  State<TambahMenu> createState() => _TambahMenuState();
}

class _TambahMenuState extends State<TambahMenu> {
  bool _isFoodCategory = true; 
  
  // --- VARIABEL UNTUK FOTO (WEB SUPPORTED) ---
  Uint8List? _imageBytes; // <-- Menyimpan data foto dalam bentuk byte agar Web tidak error
  final ImagePicker _picker = ImagePicker();

  // --- FUNGSI MENGAMBIL FOTO DARI GALERI ---
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    
    if (pickedFile != null) {
      // Baca foto sebagai "bytes" (angka mentah), ini diwajibkan untuk Flutter Web
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- CUSTOM HEADER ---
    Widget buildHeader() {
      return Container(
        padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDF1),
          border: Border(bottom: BorderSide(width: 1, color: Color(0xFFFFCE99))),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context), 
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(color: Color(0xFFFFCE99), shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back, color: Color(0xFF562F00), size: 20),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Add New Menu',
              style: TextStyle(color: Color(0xFFFF9442), fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Inter'),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      body: Column(
        children: [
          buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- UPLOAD FOTO AREA (INTERAKTIF & WEB SAFE) ---
                  GestureDetector(
                    onTap: _pickImage, 
                    child: Container(
                      width: double.infinity,
                      padding: _imageBytes != null 
                          ? EdgeInsets.zero 
                          : const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1EA),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0x7FFFEDD5)),
                      ),
                      child: _imageBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // --- INI YANG DIUBAH: Menggunakan Image.memory ---
                                  Image.memory(
                                    _imageBytes!,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withOpacity(0.6),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: const Text('Tap to Change Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontFamily: 'Inter')),
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: const Color(0x19FF9442),
                                    shape: BoxShape.circle,
                                    border: Border.all(width: 2, color: const Color(0xFFFF9442)),
                                  ),
                                  child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFFFF9442), size: 36),
                                ),
                                const SizedBox(height: 16),
                                const Text('Upload Menu Photo', style: TextStyle(color: Color(0xFF231A14), fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Inter')),
                                const SizedBox(height: 8),
                                const Text(
                                  'High-quality photos of your delicious menu items help increase sales.',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(color: Color(0xFF554337), fontSize: 14, fontFamily: 'Inter'),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(color: const Color(0xFFFF9442), borderRadius: BorderRadius.circular(30)),
                                  child: const Text('Choose File', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // --- FORM INPUT ---
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0x7FFFEDD5)),
                      boxShadow: const [BoxShadow(color: Color(0x0A562F00), blurRadius: 30.0, offset: Offset(0, 8.0))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('PRODUCT NAME'),
                        _buildTextField(hint: 'e.g., Mietiaw Mentai Extra Pedas'),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('PRICE'),
                                  _buildTextField(hint: '19,000', prefix: 'Rp '),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('INITIAL STOCK'),
                                  _buildTextField(hint: '50', isNumber: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        _buildLabel('CATEGORY'),
                        Row(
                          children: [
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isFoodCategory = true),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: _isFoodCategory ? const Color(0xFFFF9442) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: _isFoodCategory ? const Color(0xFFFF9442) : const Color(0xFFDCC1B2), width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Food', style: TextStyle(color: _isFoodCategory ? Colors.white : const Color(0xFF554337), fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: GestureDetector(
                                onTap: () => setState(() => _isFoodCategory = false),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  decoration: BoxDecoration(
                                    color: !_isFoodCategory ? const Color(0xFFFF9442) : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(color: !_isFoodCategory ? const Color(0xFFFF9442) : const Color(0xFFDCC1B2), width: 2),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text('Beverages', style: TextStyle(color: !_isFoodCategory ? Colors.white : const Color(0xFF554337), fontSize: 14, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        _buildLabel('DESCRIPTION'),
                        _buildTextField(
                          hint: "Tell your customers about this dish's ingredients, spice level, or unique preparation style...",
                          maxLines: 4,
                        ),
                        const SizedBox(height: 32),

                        // BUTTON SIMPAN MENU
                        GestureDetector(
                          onTap: () {
                            if (_imageBytes == null) {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Harap upload foto menu terlebih dahulu!')));
                              return;
                            }
                            Navigator.pop(context); 
                            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Menu berhasil ditambahkan!')));
                          },
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9442),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [BoxShadow(color: Color(0x3F000000), blurRadius: 20.0, offset: Offset(0, 10.0), spreadRadius: -10.0)],
                            ),
                            alignment: Alignment.center,
                            child: const Text('Simpan Menu', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800, fontFamily: 'Inter')),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: Color(0xFF964900), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1, fontFamily: 'Inter')),
    );
  }

  Widget _buildTextField({required String hint, String? prefix, int maxLines = 1, bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCC1B2)),
      ),
      child: TextField(
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Color(0xFF562F00), fontSize: 16, fontFamily: 'Inter'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0x7F887366), fontSize: 14, fontFamily: 'Inter'),
          prefixIcon: prefix != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16, top: 14, bottom: 14, right: 8),
                  child: Text(prefix, style: const TextStyle(color: Color(0xFFFF9442), fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}