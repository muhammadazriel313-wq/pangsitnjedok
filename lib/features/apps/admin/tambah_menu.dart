import 'dart:typed_data'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/network/api_services.dart'; // Wajib di-import

class TambahMenu extends StatefulWidget {
  const TambahMenu({super.key});

  @override
  State<TambahMenu> createState() => _TambahMenuState();
}

class _TambahMenuState extends State<TambahMenu> {
  // 1. TAMBAH CONTROLLER UNTUK MENANGKAP INPUTAN
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  
  bool _isFoodCategory = true; 
  Uint8List? _imageBytes; 
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  // 2. FUNGSI SIMPAN DATA KE DATABASE MYSQL
 // --- UBAH FUNGSI INI SAJA DI tambah_menu.dart ---
  Future<void> _simpanKeDatabase() async {
    // Validasi kosong
    if (_nameController.text.trim().isEmpty || 
        _priceController.text.trim().isEmpty || 
        _stockController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi!'), backgroundColor: Colors.orange),
      );
      return;
    }

    // Tampilkan Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442))),
    );

    // Bersihkan format angka
    String cleanPrice = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    String cleanStock = _stockController.text.replaceAll(RegExp(r'[^0-9]'), '');

    // Siapkan data teks
    Map<String, dynamic> dataBaru = {
      'title': _nameController.text.trim(),
      'price': cleanPrice.isEmpty ? '0' : cleanPrice,
      'stock': cleanStock.isEmpty ? '0' : cleanStock,
      'category': _isFoodCategory ? 'Makanan' : 'Minuman',
    };

    // Panggil API Tambah, sekalian kirimkan _imageBytes fotonya
    bool success = await ApiService.addMenu(
      dataBaru,
      imageBytes: _imageBytes, 
      fileName: 'menu_baru.jpg' // Beri nama sembarang agar PHP tahu ekstensi file-nya
    );

    if (!mounted) return;
    Navigator.pop(context); // Tutup loading

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu berhasil ditambahkan!'), backgroundColor: Colors.green),
      );
      Navigator.pop(context, true); // Kembali ke menu management dan refresh
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan menu.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
                                  Image.memory(_imageBytes!, width: double.infinity, height: 250, fit: BoxFit.cover),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.6), borderRadius: BorderRadius.circular(20)),
                                    child: const Text('Tap to Change Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            )
                          : Column(
                              children: [
                                Container(
                                  width: 80, height: 80,
                                  decoration: BoxDecoration(color: const Color(0x19FF9442), shape: BoxShape.circle, border: Border.all(width: 2, color: const Color(0xFFFF9442))),
                                  child: const Icon(Icons.cloud_upload_outlined, color: Color(0xFFFF9442), size: 36),
                                ),
                                const SizedBox(height: 16),
                                const Text('Upload Menu Photo', style: TextStyle(color: Color(0xFF231A14), fontSize: 18, fontWeight: FontWeight.w800)),
                                const SizedBox(height: 8),
                                const Text('High-quality photos of your delicious menu items help increase sales.', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFF554337), fontSize: 14)),
                                const SizedBox(height: 24),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  decoration: BoxDecoration(color: const Color(0xFFFF9442), borderRadius: BorderRadius.circular(30)),
                                  child: const Text('Choose File', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                                ),
                              ],
                            ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(32),
                      border: Border.all(color: const Color(0x7FFFEDD5)),
                      boxShadow: const [BoxShadow(color: Color(0x0A562F00), blurRadius: 30.0, offset: Offset(0, 8.0))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('PRODUCT NAME'),
                        // Pasang controller
                        _buildTextField(controller: _nameController, hint: 'e.g., Mietiaw Mentai Extra Pedas'),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('PRICE'),
                                  // Pasang controller
                                  _buildTextField(controller: _priceController, hint: '19,000', prefix: 'Rp ', isNumber: true),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('INITIAL STOCK'),
                                  // Pasang controller
                                  _buildTextField(controller: _stockController, hint: '50', isNumber: true),
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
                                  child: Text('Food', style: TextStyle(color: _isFoodCategory ? Colors.white : const Color(0xFF554337), fontSize: 14, fontWeight: FontWeight.w700)),
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
                                  child: Text('Beverages', style: TextStyle(color: !_isFoodCategory ? Colors.white : const Color(0xFF554337), fontSize: 14, fontWeight: FontWeight.w700)),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        _buildLabel('DESCRIPTION'),
                        _buildTextField(
                          hint: "Tell your customers about this dish's ingredients...",
                          maxLines: 4,
                        ),
                        const SizedBox(height: 32),

                        // 3. PANGGIL FUNGSI SIMPAN DI SINI
                        GestureDetector(
                          onTap: _simpanKeDatabase, // <-- Diganti memanggil fungsi di atas
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9442),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [BoxShadow(color: Color(0x3F000000), blurRadius: 20.0, offset: Offset(0, 10.0), spreadRadius: -10.0)],
                            ),
                            alignment: Alignment.center,
                            child: const Text('Simpan Menu', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
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
      child: Text(text, style: const TextStyle(color: Color(0xFF964900), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
    );
  }

  // Tambahkan property 'controller' pada fungsi ini
  Widget _buildTextField({TextEditingController? controller, required String hint, String? prefix, int maxLines = 1, bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCC1B2)),
      ),
      child: TextField(
        controller: controller, // Menangkap input
        maxLines: maxLines,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        style: const TextStyle(color: Color(0xFF562F00), fontSize: 16),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0x7F887366), fontSize: 14),
          prefixIcon: prefix != null
              ? Padding(
                  padding: const EdgeInsets.only(left: 16, top: 14, bottom: 14, right: 8),
                  child: Text(prefix, style: const TextStyle(color: Color(0xFFFF9442), fontSize: 16, fontWeight: FontWeight.w700)),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }
}