import 'package:flutter/material.dart';

// ✅ Cukup keluar satu tingkat (../) saja
import 'service/api_service.dart';

class HalamanRegister extends StatefulWidget {
  const HalamanRegister({super.key});

  @override
  State<HalamanRegister> createState() => _HalamanRegisterState();
}

class _HalamanRegisterState extends State<HalamanRegister> {
  bool _isPasswordHidden = true;
  bool _isLoading = false;

  // Controller untuk menangkap teks
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi proses daftar
  Future<void> _prosesRegister() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields must be filled!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // ✅ Pastikan fungsi 'register' sudah ada di ApiService kamu ya!
      final response = await ApiService.register(
        _nameController.text,
        _phoneController.text,
        _passwordController.text,
      );

      if (!mounted) return; // Pengaman navigasi
      setState(() => _isLoading = false);

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message']), backgroundColor: Colors.green),
        );
        // Jika sukses, kembali ke halaman Login
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Registration failed.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Connection error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCFAEE), 
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF954A00)),
          onPressed: () => Navigator.pop(context), 
        ),
        title: const Text('Create Account', style: TextStyle(color: Color(0xFF954A00), fontSize: 18, fontWeight: FontWeight.w600)),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity, height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                image: const DecorationImage(image: AssetImage("assets/images/pangsitregister.png"), fit: BoxFit.cover),
                boxShadow: const [BoxShadow(color: Color(0x19000000), blurRadius: 10, offset: Offset(0, 4))],
              ),
            ),
            const SizedBox(height: 32),
            const Text('Sign Up', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Color(0xFF554337))),
            const SizedBox(height: 8),
            const Text('Fill in the details to create an account.', style: TextStyle(fontSize: 14, color: Color(0x99554337))),
            const SizedBox(height: 32),

            _buildTextField(
              hintText: 'Full Name', 
              icon: Icons.person_outline, 
              controller: _nameController,
              keyboardType: TextInputType.name,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              hintText: 'Phone Number', 
              icon: Icons.phone_android_outlined, 
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),

            _buildTextField(
              hintText: 'Password', 
              icon: Icons.lock_outline, 
              isPassword: true,
              controller: _passwordController,
            ),
            const SizedBox(height: 32),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF954A00), foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 4,
              ),
              onPressed: _isLoading ? null : _prosesRegister,
              child: _isLoading 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, required IconData icon, bool isPassword = false, TextInputType? keyboardType, required TextEditingController controller}) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _isPasswordHidden : false,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Color(0x7F554337)),
        prefixIcon: Icon(icon, color: const Color(0xFF554337)),
        suffixIcon: isPassword 
            ? IconButton(
                icon: Icon(_isPasswordHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF554337)),
                onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
              ) 
            : null,
        filled: true,
        fillColor: const Color(0xFFE4E3D7),
        contentPadding: const EdgeInsets.symmetric(vertical: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: const BorderSide(color: Color(0xFF954A00), width: 1.5)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}