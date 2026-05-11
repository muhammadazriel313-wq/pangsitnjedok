import 'package:flutter/material.dart';
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  // Controller untuk input field
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fungsi untuk mengambil data dari database via API
  Future<void> _loadUserData() async {
    try {
      // Simulasi data dari database (Dummy Data)
      await Future.delayed(const Duration(seconds: 1)); // Efek loading
      String nameFromDB = "Bocil Windut"; 
      String phoneFromDB = "081234567890";

      // MASUKKAN DATA KE CONTROLLER
      setState(() {
        nameController.text = nameFromDB;
        phoneController.text = phoneFromDB;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      print("Error loading data: $e");
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
          style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold),
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
                                  image: AssetImage('assets/images/nipis.jpeg'), // Gambar default
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
                  const Text(
                    'Bocil Windut',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
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
              onPressed: () async {
                // Simulasi pemanggilan API (Pastikan ApiService sudah diimport)
                // var result = await ApiService.gantiProfil(id: "1", ...);
                
                // Contoh dummy logic untuk demo:
                bool isSuccess = true; 

                if (isSuccess) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profil berhasil diperbarui!'),
                      backgroundColor: Color(0xFF954A00),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  Future.delayed(const Duration(seconds: 1), () {
                    if (mounted) Navigator.pop(context);
                  });
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9644),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 5,
                shadowColor: const Color(0xFFFF9644),
              ),
              child: const Text(
                'Save Changes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C3400)),
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