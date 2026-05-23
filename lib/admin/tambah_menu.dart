import 'dart:typed_data'; 
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // Library untuk memilih foto dari galeri HP
import '/service/api_service.dart'; // Library koneksi API backend kita

// Ini adalah StatefulWidget halaman tambah menu baru.
// Kita pakai StatefulWidget karena ada banyak inputan dinamis seperti teks nama, harga, stok, dan upload foto.
class TambahMenu extends StatefulWidget {
  const TambahMenu({super.key});

  @override
  State<TambahMenu> createState() => _TambahMenuState();
}

class _TambahMenuState extends State<TambahMenu> {
  // --- CONTROLLER UNTUK MENANGKAP INPUTAN TEKS ---
  // Controller ini bertugas membaca apa saja yang diketik oleh admin di layar.
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _stockController = TextEditingController();
  
  // Penanda kategori: jika true berarti Makanan, jika false berarti Minuman. Bawaannya adalah Makanan (true).
  bool _isFoodCategory = true; 
  
  // Variabel untuk menyimpan data biner foto yang sudah dipilih.
  Uint8List? _imageBytes; 
  
  // Instansiasi library ImagePicker untuk membuka galeri HP
  final ImagePicker _picker = ImagePicker();

  // --- FUNGSI MEMILIH FOTO DARI GALERI ---
  Future<void> _pickImage() async {
    // Membuka galeri HP dan menunggu admin memilih salah satu foto
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // Jika admin berhasil memilih foto, kita baca fotonya menjadi bentuk bytes (biner data)
      final bytes = await pickedFile.readAsBytes();
      // Panggil setState agar Flutter langsung memperbarui tampilan dengan menampilkan foto tersebut di layar
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  // --- FUNGSI MENYIMPAN MENU BARU KE DATABASE (API) ---
  Future<void> _simpanKeDatabase() async {
    // 1. Validasi Input Kosong
    // trim() digunakan untuk menghapus spasi kosong di awal dan akhir teks agar admin tidak sekedar mengetik spasi.
    if (_nameController.text.trim().isEmpty || 
        _priceController.text.trim().isEmpty || 
        _stockController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields must be filled!'), backgroundColor: Colors.orange),
      );
      return; // Stop fungsi di sini, jangan lanjut simpan
    }

    // 2. Tampilkan Animasi Loading Dialog
    // Kita munculkan pop-up loading yang tidak bisa ditutup manual (barrierDismissible: false) biar admin tahu proses sedang berjalan.
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442))),
    );

    // 3. Bersihkan Format Angka
    // Menghapus karakter non-angka (seperti huruf, simbol Rp, titik, atau koma) dari harga dan stok sebelum dikirim ke database
    String cleanPrice = _priceController.text.replaceAll(RegExp(r'[^0-9]'), '');
    String cleanStock = _stockController.text.replaceAll(RegExp(r'[^0-9]'), '');

    // 4. Siapkan Data Menu dalam format Map (Key-Value)
    Map<String, dynamic> dataBaru = {
      'title': _nameController.text.trim(),
      'price': cleanPrice.isEmpty ? '0' : cleanPrice,
      'stock': cleanStock.isEmpty ? '0' : cleanStock,
      'category': _isFoodCategory ? 'Makanan' : 'Minuman',
    };

    // 5. Panggil API Tambah Menu dari ApiService
    // Kita sekalian kirimkan data biner foto (_imageBytes) beserta nama file sembarangan.
    bool success = await ApiService.addMenu(
      dataBaru,
      imageBytes: _imageBytes, 
      fileName: 'menu_baru.jpg' 
    );

    // Jika halaman sudah ditutup sebelum proses selesai, kita hentikan eksekusi kode selanjutnya
    if (!mounted) return;
    Navigator.pop(context); // Menutup pop-up loading dialog yang muncul tadi

    // 6. Respon Sukses / Gagal
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Menu added successfully!'), backgroundColor: Colors.green),
      );
      // Kembali ke halaman sebelumnya (Menu Management) sambil membawa nilai 'true' 
      // supaya halaman sebelumnya langsung melakukan refresh daftar menu secara otomatis.
      Navigator.pop(context, true); 
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to add menu.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- WIDGET HEADER (BAGIAN ATAS HALAMAN) ---
    Widget buildHeader() {
      return Container(
        padding: const EdgeInsets.only(top: 40, left: 24, right: 24, bottom: 20),
        decoration: const BoxDecoration(
          color: Color(0xFFFFFDF1),
          border: Border(bottom: BorderSide(width: 1, color: Color(0xFFFFCE99))),
        ),
        child: Row(
          children: [
            // Tombol Kembali berbentuk bulat manis
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
          buildHeader(), // Tampilkan header di paling atas
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // --- KOTAK UPLOAD / PREVIEW FOTO MENU ---
                  GestureDetector(
                    onTap: _pickImage, // Jika diklik, buka galeri
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
                      // JIKA SUDAH PILIH FOTO: Tampilkan preview fotonya di layar
                      child: _imageBytes != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Image.memory(_imageBytes!, width: double.infinity, height: 250, fit: BoxFit.cover),
                                  // Overlay gelap transparan tipis beserta instruksi ubah foto
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    decoration: BoxDecoration(color: Colors.black.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(20)),
                                    child: const Text('Tap to Change Photo', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  )
                                ],
                              ),
                            )
                          // JIKA BELUM PILIH FOTO: Tampilkan ikon upload dan teks panduan
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

                  // --- FORM INPUT DATA MENU ---
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
                        // Input Nama Produk
                        _buildLabel('PRODUCT NAME'),
                        _buildTextField(controller: _nameController, hint: 'e.g., Mietiaw Mentai Extra Pedas'),
                        const SizedBox(height: 24),

                        // Input Harga dan Stok Awal bersebelahan
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildLabel('PRICE'),
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
                                  _buildTextField(controller: _stockController, hint: '50', isNumber: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Pilihan Kategori (Makanan / Minuman) berbentuk tombol geser
                        _buildLabel('CATEGORY'),
                        Row(
                          children: [
                            // Tombol Makanan (Food)
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
                            // Tombol Minuman (Beverages)
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

                        // Input Deskripsi Produk
                        _buildLabel('DESCRIPTION'),
                        _buildTextField(
                          hint: "Tell your customers about this dish's ingredients...",
                          maxLines: 4,
                        ),
                        const SizedBox(height: 32),

                        // Tombol Simpan Menu Besar di Paling Bawah Form
                        GestureDetector(
                          onTap: _simpanKeDatabase, 
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF9442),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: const [BoxShadow(color: Color(0x3F000000), blurRadius: 20.0, offset: Offset(0, 10.0), spreadRadius: -10.0)],
                            ),
                            child: const Text('Save Menu', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
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

  // --- WIDGET MEMBUAT LABEL TEKS FORM KECIL ---
  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text, style: const TextStyle(color: Color(0xFF964900), fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1)),
    );
  }

  // --- WIDGET CUSTOM TEXT FIELD UNTUK FORM INPUT ---
  Widget _buildTextField({TextEditingController? controller, required String hint, String? prefix, int maxLines = 1, bool isNumber = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDCC1B2)),
      ),
      child: TextField(
        controller: controller, // Hubungkan controller agar ketikan admin tertangkap
        maxLines: maxLines,
        // Jika isNumber adalah true, HP otomatis memunculkan keyboard angka saja
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
