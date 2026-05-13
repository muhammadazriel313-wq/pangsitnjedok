import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/service/api_service.dart'; 

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
  Uint8List? _imageBytes; // Menampung bytes gambar yang baru dipilih[cite: 14]
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    // Inisialisasi controller dengan data awal dari halaman profil[cite: 14]
    _nameController = TextEditingController(text: widget.initialData['name']);
    _usernameController = TextEditingController(text: widget.initialData['username']);
    // Password dikosongkan secara default agar tidak terupdate jika tidak diisi
    _passwordController = TextEditingController(text: ''); 
    _phoneController = TextEditingController(text: widget.initialData['phone']);
    _emailController = TextEditingController(text: widget.initialData['email']);
  }

  // Fungsi untuk memilih gambar dari galeri[cite: 14]
  Future<void> _pickImage() async {
    final XFile? pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() => _imageBytes = bytes);
    }
  }

  // Fungsi untuk menyimpan perubahan ke database[cite: 14, 16]
  Future<void> _saveProfile() async {
    // Tampilkan loading dialog agar user tidak melakukan interaksi ganda[cite: 14]
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442))),
    );

    // Siapkan data teks untuk dikirim ke PHP[cite: 14]
    Map<String, String> updatedData = {
      'name': _nameController.text,
      'username': _usernameController.text,
      'password': _passwordController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
    };
    
    // Panggil API update dengan menyertakan bytes gambar[cite: 14, 16]
    bool isSuccess = await ApiService.updateAdminProfil(
      updatedData, 
      imageBytes: _imageBytes
    );

    if (!mounted) return;
    Navigator.pop(context); // Tutup Loading dialog

    if (isSuccess) {
      // Kembali ke halaman profil dengan sinyal sukses agar data di-refresh[cite: 14]
      Navigator.pop(context, true); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil Berhasil Diperbarui!'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan. Cek koneksi XAMPP!'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFDF1),
        elevation: 0,
        centerTitle: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFFC2410C)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Edit Profile', style: TextStyle(color: Color(0xFFFF9442), fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            _buildAvatarSection(),
            const SizedBox(height: 32),
            _buildFormSection(),
          ],
        ),
      ),
    );
  }

  // UI Bagian Foto Profil (Sesuai saran: mendukung NetworkImage untuk sinkronisasi)[cite: 14]
  Widget _buildAvatarSection() {
    String? currentImageUrl = widget.initialData['image_url'];

    return GestureDetector(
      onTap: _pickImage,
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Container(
            width: 128, height: 128,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFFF9644), width: 4),
            ),
            child: ClipOval(
              child: _imageBytes != null
                  ? Image.memory(_imageBytes!, fit: BoxFit.cover) // Gambar baru dipilih
                  : (currentImageUrl != null && currentImageUrl.isNotEmpty)
                      ? Image.network(
                          "${ApiService.baseUrl}/uploads/$currentImageUrl", // Gambar dari database[cite: 5]
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Image.asset(
                            "assets/images/Dimas oi oi.jpeg", 
                            fit: BoxFit.cover,
                          ),
                        )
                      : Image.asset("assets/images/Dimas oi oi.jpeg", fit: BoxFit.cover), // Gambar default
            ),
          ),
          const CircleAvatar(
            backgroundColor: Color(0xFFFF9644), 
            radius: 18, 
            child: Icon(Icons.camera_alt, color: Colors.white, size: 20)
          ),
        ],
      ),
    );
  }

  // Form Input Admin[cite: 14]
  Widget _buildFormSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white, 
        borderRadius: BorderRadius.circular(32),
        boxShadow: const [BoxShadow(color: Color(0x0A562F00), blurRadius: 30)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLabel('Full Name'),
          _buildTextField(controller: _nameController, hint: 'Full Name'),
          const SizedBox(height: 16),
          _buildLabel('Username'),
          _buildTextField(controller: _usernameController, hint: 'Username'),
          const SizedBox(height: 16),
          _buildLabel('Password'),
          _buildTextField(
            controller: _passwordController, 
            hint: 'Kosongkan jika tidak ingin ganti', 
            isPassword: true, 
            isObscure: _isPasswordHidden, 
            onToggle: () => setState(() => _isPasswordHidden = !_isPasswordHidden)
          ),
          const SizedBox(height: 16),
          _buildLabel('Phone Number'),
          _buildTextField(controller: _phoneController, hint: 'Phone Number', isNumber: true),
          const SizedBox(height: 16),
          _buildLabel('Email'),
          _buildTextField(controller: _emailController, hint: 'Email'),
          const SizedBox(height: 32),
          ElevatedButton(
            onPressed: _saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9442), 
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            ),
            child: const Text('Simpan Perubahan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 8), 
    child: Text(text, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600))
  );
  
  Widget _buildTextField({
    required TextEditingController controller, 
    required String hint, 
    bool isPassword = false, 
    bool isObscure = false, 
    VoidCallback? onToggle, 
    bool isNumber = false
  }) {
    return Container(
      decoration: BoxDecoration(color: const Color(0xFFFFF1EA), borderRadius: BorderRadius.circular(32)),
      child: TextField(
        controller: controller, 
        obscureText: isObscure, 
        keyboardType: isNumber ? TextInputType.phone : TextInputType.text,
        decoration: InputDecoration(
          hintText: hint, 
          border: InputBorder.none, 
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          suffixIcon: isPassword 
              ? IconButton(
                  icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility, color: const Color(0xFFFF9442)), 
                  onPressed: onToggle
                ) 
              : null,
        ),
      ),
    );
  }
}
