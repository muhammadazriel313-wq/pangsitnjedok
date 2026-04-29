import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/service/api_service.dart'; // Pastikan path ini benar

class EditProfil extends StatefulWidget {
  final Map<String, dynamic> initialData;

  const EditProfil({super.key, required this.initialData});

  @override
  State<EditProfil> createState() => _EditProfilState();
}

class _EditProfilState extends State<EditProfil> {
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _passwordController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  bool _isPasswordHidden = true; 
  Uint8List? _imageBytes;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name']);
    _usernameController = TextEditingController(text: widget.initialData['username']);
    _passwordController = TextEditingController(text: 'password123'); 
    _phoneController = TextEditingController(text: widget.initialData['phone']);
    _emailController = TextEditingController(text: widget.initialData['email']);
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

  // --- FUNGSI SIMPAN KE DATABASE ---
  Future<void> _saveProfile() async {
    // 1. Tampilkan Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(
        child: CircularProgressIndicator(color: Color(0xFFFF9442)),
      ),
    );

    // 2. Siapkan data untuk dikirim ke PHP
    Map<String, String> updatedData = {
      'name': _nameController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
    };
    
    // 3. Panggil ApiService
    // Pastikan di ApiService fungsi updateAdminProfil sudah kamu buat (seperti di diskusi sebelumnya)
    bool isSuccess = await ApiService.updateAdminProfil(updatedData);

    if (!mounted) return;
    Navigator.pop(context); // Tutup Loading

    if (isSuccess) {
      // Kembali ke halaman profil dengan membawa data terbaru agar UI Profil terupdate
      Navigator.pop(context, updatedData);
    } else {
      // Notifikasi Gagal
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Gagal menyimpan ke database. Cek koneksi XAMPP!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    PreferredSizeWidget buildAppBar() {
      return AppBar(
        backgroundColor: const Color(0xFFFFFDF1),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFC2410C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Color(0xFFFF9442), fontSize: 18, fontWeight: FontWeight.w700, fontFamily: 'Inter'),
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1.0),
          child: Container(color: const Color(0x7FFFEDD5), height: 1.0),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF1EA),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFFF9644), width: 4),
                      boxShadow: const [BoxShadow(color: Color(0x19000000), blurRadius: 15, offset: Offset(0, 10), spreadRadius: -5)],
                    ),
                    child: ClipOval(
                      child: _imageBytes != null
                          ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                          : Image.asset("assets/images/Dimas oi oi.jpeg", fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.person, size: 64, color: Color(0xFFFF9644))),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF9644),
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Color(0x19000000), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -4)],
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            Text(_nameController.text, style: const TextStyle(color: Color(0xFF562F00), fontSize: 24, fontWeight: FontWeight.w800, fontFamily: 'Inter')),
            const SizedBox(height: 4),
            const Text('HEAD ADMIN', style: TextStyle(color: Color(0xFFFF9644), fontSize: 14, fontWeight: FontWeight.w700, letterSpacing: 1.4, fontFamily: 'Inter')),
            const SizedBox(height: 32),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                border: Border.all(color: const Color(0xFFFFF7ED)),
                boxShadow: const [BoxShadow(color: Color(0x0A562F00), blurRadius: 30, offset: Offset(0, 8))],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLabel('Full Name'),
                  _buildTextField(
                    controller: _nameController, 
                    hint: 'Full Name',
                    onChanged: (val) => setState(() {}),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Username'),
                  _buildTextField(controller: _usernameController, hint: 'Username'),
                  const SizedBox(height: 16),

                  _buildLabel('Password'),
                  _buildTextField(
                    controller: _passwordController, 
                    hint: 'Password', 
                    isPassword: true,
                    isObscure: _isPasswordHidden,
                    onTogglePassword: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                  ),
                  const SizedBox(height: 16),

                  _buildLabel('Phone Number (No HP)'),
                  _buildTextField(controller: _phoneController, hint: 'Phone Number', isNumber: true),
                  const SizedBox(height: 16),

                  _buildLabel('Email Address'),
                  _buildTextField(controller: _emailController, hint: 'Email Address'),
                  const SizedBox(height: 32),

                  GestureDetector(
                    onTap: _saveProfile, // Menggunakan fungsi simpan database
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF9442),
                        borderRadius: BorderRadius.circular(32),
                        boxShadow: const [BoxShadow(color: Color(0x19000000), blurRadius: 6, offset: Offset(0, 4), spreadRadius: -1)],
                      ),
                      alignment: Alignment.center,
                      child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700, fontFamily: 'Inter')),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: const Color(0x4CFFDCBF), borderRadius: BorderRadius.circular(32), border: Border.all(color: const Color(0x7FFFDCBF))),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Icon(Icons.info_outline, color: Color(0xFF794C1B)),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Updating your profile will also update your credentials for the order management system. Make sure your email is valid for password recovery.',
                      style: TextStyle(color: Color(0xFF794C1B), fontSize: 14, fontFamily: 'Inter', height: 1.5),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 8),
      child: Text(text, style: const TextStyle(color: Color(0xFF554337), fontSize: 14, fontFamily: 'Inter')),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    bool isPassword = false,
    bool isObscure = false,
    VoidCallback? onTogglePassword,
    bool isNumber = false,
    Function(String)? onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFFFF1EA), borderRadius: BorderRadius.circular(32)),
      child: TextField(
        controller: controller,
        obscureText: isObscure,
        onChanged: onChanged,
        keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
        style: const TextStyle(color: Color(0xFF231A14), fontSize: 16, fontWeight: FontWeight.w600, fontFamily: 'Inter'),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: const TextStyle(color: Color(0xFFA1A1AA)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: isPassword 
              ? IconButton(icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFFF9442)), onPressed: onTogglePassword)
              : null,
        ),
      ),
    );
  }
}