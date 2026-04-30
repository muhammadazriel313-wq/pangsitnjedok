import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/service/api_service.dart';

class EditMenu extends StatefulWidget {
  final Map<String, dynamic> item; 

  const EditMenu({super.key, required this.item});

  @override
  State<EditMenu> createState() => _EditMenuState();
}

class _EditMenuState extends State<EditMenu> {
  late TextEditingController _nameController;
  late TextEditingController _priceController;
  late TextEditingController _stockController;
  late bool _isFoodCategory;
  
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item['title']);
    // Hanya ambil angkanya saja saat awal diload
    _priceController = TextEditingController(
      text: widget.item['price'].toString().replaceAll(RegExp(r'[^0-9]'), '')
    );
    _stockController = TextEditingController(text: widget.item['stock'].toString());
    
    // Pastikan kategori cocok persis dengan database (Makanan/Minuman)[cite: 11]
    _isFoodCategory = widget.item['category'] == 'Makanan';
  }

  // --- FUNGSI UPDATE DATA AMAN ---
  Future<void> _updateMenuData() async {
    // 1. VALIDASI: Cek apakah ada kolom yang kosong
    if (_nameController.text.trim().isEmpty || 
        _priceController.text.trim().isEmpty || 
        _stockController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua kolom harus diisi!'),
          backgroundColor: Colors.orange,
        ),
      );
      return; // Berhenti eksekusi jika ada yang kosong
    }

    // Tampilkan loading[cite: 11]
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF9442)),
      ),
    );

    // 2. BERSIHKAN DATA HARGA DAN STOK: Pastikan hanya angka yang dikirim
    String cleanPrice = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    String cleanStock = _stockController.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 3. SIAPKAN DATA: Tipe dynamic dan pastikan kategori valid[cite: 11]
    Map<String, dynamic> dataToUpdate = {
      'id': widget.item['id'], 
      'title': _nameController.text.trim(), // Hilangkan spasi berlebih
      'price': cleanPrice.isEmpty ? '0' : cleanPrice, // Default 0 jika tiba-tiba kosong
      'stock': cleanStock.isEmpty ? '0' : cleanStock, // Default 0
      'category': _isFoodCategory ? 'Makanan' : 'Minuman', // Harus Makanan/Minuman[cite: 11]
    };

    // Kirim ke API[cite: 11]
    bool success = await ApiService.updateMenu(dataToUpdate);

    // Pastikan widget masih ada sebelum menutup dialog
    if (!mounted) return;
    Navigator.pop(context); // Tutup loading

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menu berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true); // Refresh daftar menu[cite: 11]
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui menu ke database.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
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
              'Edit Menu Item',
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
                      height: 250,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF1EA),
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: const Color(0x7FFFEDD5)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            _imageBytes != null
                                ? Image.memory(_imageBytes!, width: double.infinity, height: 250, fit: BoxFit.cover)
                                : Image.asset(widget.item['img'], width: double.infinity, height: 250, fit: BoxFit.cover),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(color: Colors.black.withOpacity(0.5), borderRadius: BorderRadius.circular(20)),
                              child: const Text('Tap to Change Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: const [BoxShadow(color: Color(0x0A562F00), blurRadius: 30.0, offset: Offset(0, 8.0))],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('PRODUCT NAME'),
                        _buildTextField(controller: _nameController, hint: 'Product Name'),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('PRICE'),
                                  _buildTextField(controller: _priceController, hint: 'Price', prefix: 'Rp ', isNumber: true),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('STOCK'),
                                  _buildTextField(controller: _stockController, hint: 'Stock', isNumber: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildLabel('CATEGORY'),
                        Row(
                          children: [
                            _buildCatBtn('Food', _isFoodCategory, () => setState(() => _isFoodCategory = true)),
                            const SizedBox(width: 12),
                            _buildCatBtn('Beverages', !_isFoodCategory, () => setState(() => _isFoodCategory = false)),
                          ],
                        ),
                        const SizedBox(height: 32),
                        GestureDetector(
                          onTap: _updateMenuData, 
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9442),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [BoxShadow(color: Color(0x33FF9442), blurRadius: 15.0, offset: Offset(0, 8.0))],
                            ),
                            alignment: Alignment.center,
                            child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w800)),
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

  // --- HELPER WIDGETS ---
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(text, style: const TextStyle(color: Color(0xFF964900), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
  );

  Widget _buildTextField({required TextEditingController controller, required String hint, String? prefix, bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: const Color(0xFFDCC1B2))),
      child: TextField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint,
          prefixIcon: prefix != null ? Padding(padding: const EdgeInsets.all(14), child: Text(prefix, style: const TextStyle(color: Color(0xFFFF9442), fontWeight: FontWeight.bold))) : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildCatBtn(String label, bool active, VoidCallback onTap) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: active ? const Color(0xFFFF9442) : Colors.transparent,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: active ? const Color(0xFFFF9442) : const Color(0xFFDCC1B2), width: 2),
          ),
          alignment: Alignment.center,
          child: Text(label, style: TextStyle(color: active ? Colors.white : const Color(0xFF554337), fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}