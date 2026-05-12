import 'package:flutter/material.dart';
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
import 'package:aplikasipangsitnjedok/core/network/api_services.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

// ✅ TAMBAHKAN BARIS INI:
import '../service/api_service.dart';


class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  // Controller untuk input field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = true; //karena data akan diambil dari database, jadi kita buat loading dulu sebelum data muncul

  // Variabel untuk menyimpan file gambar yang dipilih
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();

  // Fungsi untuk membuka file explorer (galeri)
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, // Langsung membuka galeri/file explorer
      imageQuality: 80, // Opsional: kompres kualitas
    );
    if (pickedFile != null) {
    print("Gambar dipilih: ${pickedFile.path}"); // Cek di console
    setState(() {
      _imageFile = File(pickedFile.path);
    });
  } else {
    print("Tidak ada gambar yang dipilih.");
  }
  }

// Fungsi untuk mengambil data user dari database (simulasi)

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Tambahkan listener agar nama di header update otomatis saat mengetik
    nameController.addListener(() {
      if (mounted) {
        setState(() {}); 
      }
    });
  }

  // Fungsi untuk mengambil data dari database via API
  Future<void> _loadUserData() async {
  try {
    // 1. Panggil API get_profile.php, pastikan URL di ApiService sudah benar
    var response = await ApiService.getProfile("1"); // Ganti "1" dengan ID yang sesuai

    if (response['status'] == 'success') {
      // 2. Ambil data dari key 'data' sesuai format JSON di PHP kamu
      final userData = response['data'];
      
      setState(() {
        nameController.text = userData['name'] ?? ""; // Ambil field 'name'
        phoneController.text = userData['no_telepon'] ?? ""; // Ambil field 'no_telepon'
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print("Gagal mengambil data: ${response['message']}");
    }
  } catch (e) {
    setState(() => isLoading = false);
    print("Error loading data: $e");
  }
}

  void _saveChanges() async {
    setState(() => isLoading = true); // Mulai loading, tombol jadi abu-abu

    try {
      print("Mengirim data update...");
      var response = await ApiService.updateProfile("1", nameController.text, phoneController.text);

      if (response['status'] == 'success') {
      if (mounted) Navigator.pop(context, true);
      } else {
        // Tampilkan error jika gagal
        if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal: ${response['message']}")),
        );
      }
    }
  } catch (e) {
    print("Error: $e");
    } finally {
        if (mounted) setState(() => isLoading = false); // Matikan loading jika sudah selesai
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: const Padding(
          padding: EdgeInsets.all(12.0), // Berikan sedikit padding agar lebih mudah diklik
          child: Icon(Icons.arrow_back, color: Color(0xFF954A00)),
        ),
      ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold, fontSize: 18),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFFF9644), width: 4),
                          image: _imageFile != null
                              ? DecorationImage(
                                  image: FileImage(_imageFile!), // Menggunakan file dari HP
                                  fit: BoxFit.cover,
                                )
                              : const DecorationImage(
                                  image: AssetImage('assets/images/esbuahleci.jpg'), // Gambar default
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: editCircleIcon(
                          onTap: () {
                            _pickImage();
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    nameController.text.isEmpty ? "Nama Customer" : nameController.text,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),
            // Form Container
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20),
                ],
              ),
              child: Column(
                children: [
                  _buildTextField("Full Name", nameController),
                  const SizedBox(height: 20),
                  _buildTextField("Phone Number", phoneController),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Save Button
            ElevatedButton(
              onPressed: isLoading ? null : _saveChanges, // Nonaktifkan tombol saat loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9644),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 5,
                shadowColor: const Color(0xFFFF9644),
              ),
              child: isLoading 
    ? const SizedBox(
        height: 24,
        width: 24,
        child: CircularProgressIndicator(
          color: Color(0xFF6C3400),
          strokeWidth: 3,
        ),
      )
        : const Text(
            'Save Changes',
            style: TextStyle(
              fontSize: 18, 
              fontWeight: FontWeight.bold, 
              color: Color(0xFF6C3400)
            ),
          ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavbar(context, false),
      floatingActionButton: buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF554337), fontSize: 14),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE4E3D7),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }

  Widget editCircleIcon({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Color(0xFF954A00),
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.edit, color: Colors.white, size: 16),
      ),
    );
  }
}