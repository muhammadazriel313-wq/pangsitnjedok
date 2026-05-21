import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aplikasipangsitnjedok/core/network/api_services_profile.dart'; 
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
  String? existingImageUrl; 

  @override
  void initState() {
    super.initState();
    _loadUserData();
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
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  // ✅ DIPERBAIKI: Memanggil fungsi yang ada di ApiService kamu
  void _saveChanges() async {
    setState(() => isLoading = true); 
    try {
      // Menggunakan fungsi updateProfile yang ada di ApiService kamu
      var response = await ApiService.updateProfile(userId, nameController.text, phoneController.text);

      if (response['status'] == 'success') {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profil Berhasil Diupdate!")));
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: ${response['message']}")));
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
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFF954A00))),
      ),
      body: isLoading 
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  // Foto Profil
                  Center(
                    child: Stack(
                      children: [
                        Container(
                          width: 120, height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, 
                            border: Border.all(color: const Color(0xFFFF9644), width: 4),
                            image: _imageBytes != null
                                ? DecorationImage(image: MemoryImage(_imageBytes!), fit: BoxFit.cover)
                                : (existingImageUrl != null ? DecorationImage(image: NetworkImage(existingImageUrl!), fit: BoxFit.cover) : const DecorationImage(image: AssetImage('assets/images/nipis.jpeg'), fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(bottom: 0, right: 0, child: editCircleIcon(onTap: _pickImage)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  _buildTextField("Full Name", nameController),
                  const SizedBox(height: 20),
                  _buildTextField("Phone Number", phoneController),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveChanges, 
                    child: const Text('Save Changes'),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 8),
        TextFormField(controller: controller),
      ],
    );
  }

  Widget editCircleIcon({VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFF954A00), shape: BoxShape.circle), child: const Icon(Icons.edit, color: Colors.white, size: 16)),
    );
  }
}