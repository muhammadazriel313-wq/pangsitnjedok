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
    // Gunakan safe-operator fallback agar terhindar dari error null[cite: 16]
    _nameController = TextEditingController(
      text: widget.item['title']?.toString() ?? '',
    );
    _priceController = TextEditingController(
      text:
          widget.item['price']?.toString().replaceAll(RegExp(r'[^0-9]'), '') ??
          '0',
    );
    _stockController = TextEditingController(
      text: widget.item['stock']?.toString() ?? '0',
    );

    // Mendeteksi apakah kategori sebelumnya Food/Makanan agar tombol aktifnya benar[cite: 16]
    String cat = widget.item['category']?.toString().toLowerCase().trim() ?? '';
    _isFoodCategory = (cat == 'makanan' || cat == 'food');
  }

  Future<void> _updateMenuData() async {
    if (_nameController.text.trim().isEmpty ||
        _priceController.text.trim().isEmpty ||
        _stockController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Semua kolom harus diisi!'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF9442)),
      ),
    );

    // PERUBAHAN KRUSIAL DI SINI:
    // Pastikan kategori yang dikirim konsisten formatnya (huruf kecil) agar tidak "hilang" di filter[cite: 16]
    Map<String, String> dataToUpdate = {
      'id': widget.item['id']?.toString() ?? '0',
      'title': _nameController.text.trim(),
      'price': _priceController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      'stock': _stockController.text.replaceAll(RegExp(r'[^0-9]'), ''),
      'category': _isFoodCategory ? 'food' : 'beverages',
    };

    // Panggil API UPDATE beserta file gambarnya[cite: 16]
    bool success = await ApiService.updateMenu(
      dataToUpdate,
      imageBytes: _imageBytes,
    );

    if (!mounted) return;
    Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Menu berhasil diperbarui!'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal memperbarui menu.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- PENENTUAN GAMBAR LAMA SECARA AMAN ---
    String imgStr = widget.item['img']?.toString() ?? 'placeholder.png';
    Widget oldImageWidget;

    if (imgStr.startsWith('http')) {
      oldImageWidget = Image.network(
        imgStr,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _fallbackImage(),
      );
    } else if (RegExp(r'^\d+_').hasMatch(imgStr)) {
      oldImageWidget = Image.network(
        "${ApiService.baseUrl}/uploads/$imgStr",
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _fallbackImage(),
      );
    } else {
      String finalAssetPath = imgStr.startsWith('assets/')
          ? imgStr
          : 'assets/images/$imgStr';
      oldImageWidget = Image.asset(
        finalAssetPath,
        fit: BoxFit.cover,
        errorBuilder: (c, e, s) => _fallbackImage(),
      );
    }

    Widget buildHeader() {
      return Container(
        padding: const EdgeInsets.only(
          top: 40,
          left: 24,
          right: 24,
          bottom: 20,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDF1),
          border: Border(
            bottom: BorderSide(width: 1, color: Color(0xFFFFCE99)),
          ),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFFFCE99),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_back,
                  color: Color(0xFF562F00),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Text(
              'Edit Menu Item',
              style: TextStyle(
                color: Color(0xFFFF9442),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
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
                            // Tampilkan foto dari galeri JIKA ADA, kalau tidak tampilkan foto DB
                            _imageBytes != null
                                ? Image.memory(
                                    _imageBytes!,
                                    width: double.infinity,
                                    height: 250,
                                    fit: BoxFit.cover,
                                  )
                                : SizedBox(
                                    width: double.infinity,
                                    height: 250,
                                    child: oldImageWidget,
                                  ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'Tap to Change Photo',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
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
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x0A562F00),
                          blurRadius: 30.0,
                          offset: Offset(0, 8.0),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('PRODUCT NAME'),
                        _buildTextField(
                          controller: _nameController,
                          hint: 'Product Name',
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('PRICE'),
                                  _buildTextField(
                                    controller: _priceController,
                                    hint: 'Price',
                                    prefix: 'Rp ',
                                    isNumber: true,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('STOCK'),
                                  _buildTextField(
                                    controller: _stockController,
                                    hint: 'Stock',
                                    isNumber: true,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        _buildLabel('CATEGORY'),
                        Row(
                          children: [
                            _buildCatBtn(
                              'Food',
                              _isFoodCategory,
                              () => setState(() => _isFoodCategory = true),
                            ),
                            const SizedBox(width: 12),
                            _buildCatBtn(
                              'Beverages',
                              !_isFoodCategory,
                              () => setState(() => _isFoodCategory = false),
                            ),
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
                              boxShadow: const [
                                BoxShadow(
                                  color: Color(0x33FF9442),
                                  blurRadius: 15.0,
                                  offset: Offset(0, 8.0),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
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

  Widget _fallbackImage() => Container(
    color: Colors.grey[200],
    child: const Icon(Icons.fastfood, color: Colors.grey),
  );
  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(
      text,
      style: const TextStyle(
        color: Color(0xFF964900),
        fontSize: 10,
        fontWeight: FontWeight.w800,
        letterSpacing: 1,
      ),
    ),
  );
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    String? prefix,
    bool isNumber = false,
  }) => Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: const Color(0xFFDCC1B2)),
    ),
    child: TextField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: prefix != null
            ? Padding(
                padding: const EdgeInsets.all(14),
                child: Text(
                  prefix,
                  style: const TextStyle(
                    color: Color(0xFFFF9442),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            : null,
        border: InputBorder.none,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    ),
  );
  Widget _buildCatBtn(String label, bool active, VoidCallback onTap) =>
      Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: active ? const Color(0xFFFF9442) : Colors.transparent,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(
                color: active
                    ? const Color(0xFFFF9442)
                    : const Color(0xFFDCC1B2),
                width: 2,
              ),
            ),
            alignment: Alignment.center,
            child: Text(
              label,
              style: TextStyle(
                color: active ? Colors.white : const Color(0xFF554337),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      );
}
