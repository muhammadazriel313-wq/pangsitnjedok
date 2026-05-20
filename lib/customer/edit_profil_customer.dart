import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasipangsitnjedok/core/constants/navigasi_helper.dart';
import 'package:aplikasipangsitnjedok/core/network/api_services.dart'; // ✅ Import sudah benar
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  
  bool isLoading = true; 
  String userId = ""; 

  Uint8List? _imageBytes; 
  final ImagePicker _picker = ImagePicker();

  // ✅ 1. TAMBAHKAN VARIABEL UNTUK MENYIMPAN URL FOTO DARI DATABASE
  String? existingImageUrl; 

  @override
  void initState() {
    super.initState();
    _loadUserData();

    nameController.addListener(() {
      if (mounted) setState(() {}); 
    });
  }

  Future<void> _loadUserData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('id') ?? "1"; 

      var response = await ApiService.getProfile(userId); 

      if (response['status'] == 'success') {
        final userData = response['data'];
        if (mounted) {
          setState(() {
            nameController.text = userData['name'] ?? "";
            phoneController.text = userData['no_telepon'] ?? ""; 
            
            // ✅ 2. TANGKAP URL FOTO DARI DATABASE DI SINI
            existingImageUrl = userData['foto_profil']; 
            
            isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(
      source: ImageSource.gallery, 
      imageQuality: 80, 
    );
    
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _imageBytes = bytes;
      });
    }
  }

  void _saveChanges() async {
    setState(() => isLoading = true); 

    try {
      var response = await ApiService.updateProfileCustomer(
        userId, 
        nameController.text, 
        phoneController.text,
        imageBytes: _imageBytes 
      );

      if (response['status'] == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil Berhasil Diupdate!")));
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Gagal: ${response['message']}")),
          );
        }
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: const Padding(
            padding: EdgeInsets.all(12.0),
            child: Icon(Icons.arrow_back, color: Color(0xFF954A00)),
          ),
        ),
        title: const Text('Profile', style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9644)))
          : SingleChildScrollView(
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
                              width: 120, height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, 
                                border: Border.all(color: const Color(0xFFFF9644), width: 4),
                                // ✅ 3. LOGIKA FOTO DINAMIS YANG SUDAH DIPERBAIKI
                                image: _imageBytes != null
                                    ? DecorationImage(
                                        image: MemoryImage(_imageBytes!), // Tampilkan kalau abis milih dari galeri
                                        fit: BoxFit.cover,
                                      )
                                    : (existingImageUrl != null && existingImageUrl!.isNotEmpty
                                        ? DecorationImage(
                                            image: NetworkImage(existingImageUrl!), // Tampilkan dari database kalau ada
                                            fit: BoxFit.cover,
                                          )
                                        : const DecorationImage(
                                            image: AssetImage('assets/images/nipis.jpeg'), // Default kalau masih kosong
                                            fit: BoxFit.cover,
                                          )),
                              ),
                            ),
                            Positioned(
                              bottom: 0, right: 0,
                              child: editCircleIcon(onTap: _pickImage),
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
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(32),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20)],
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
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveChanges, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9644),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 5, shadowColor: const Color(0xFFFF9644),
                    ),
                    child: isLoading 
                        ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Color(0xFF6C3400), strokeWidth: 3))
                        : const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C3400))),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
      bottomNavigationBar: buildBottomNavbar(context, '/profil_customer'),
      floatingActionButton: _buildFab(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF554337), fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true, fillColor: const Color(0xFFE4E3D7),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
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
        decoration: const BoxDecoration(color: Color(0xFF954A00), shape: BoxShape.circle),
        child: const Icon(Icons.edit, color: Colors.white, size: 16),
      ),
    );
  }

  Widget _buildFab(BuildContext context) {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(color: const Color(0xFFFF9644).withOpacity(0.4), blurRadius: 12, spreadRadius: 2)]),
      child: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, '/cart'),
        backgroundColor: const Color(0xFFFF9644), elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50), side: const BorderSide(color: Colors.white, width: 4)),
        child: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
      ),
    );
  }
}