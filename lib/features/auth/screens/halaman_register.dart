import 'package:flutter/material.dart';

class HalamanRegister extends StatefulWidget {
  const HalamanRegister({super.key});

  @override
  State<HalamanRegister> createState() => _HalamanRegisterState();
}

class _HalamanRegisterState extends State<HalamanRegister> {
  bool _isPasswordHidden = true;

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
              ),
              child: Stack(
                children: [
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
                        gradient: LinearGradient(begin: Alignment.bottomCenter, end: Alignment.topCenter, colors: [Colors.black.withOpacity(0.8), Colors.transparent]),
                      ),
                    ),
                  ),
                  const Positioned(
                    bottom: 20, left: 20,
                    child: Text('Join the Culinary\nJourney Today', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800, height: 1.2)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            const Text('Full Name', style: TextStyle(color: Color(0xFF554337), fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildTextField(hintText: 'Enter your full name', icon: Icons.person_outline),
            const SizedBox(height: 16),

            const Text('Phone Number', style: TextStyle(color: Color(0xFF554337), fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildTextField(hintText: '+62 812 3456 7890', icon: Icons.phone_outlined, keyboardType: TextInputType.phone),
            const SizedBox(height: 16),

            const Text('Password', style: TextStyle(color: Color(0xFF554337), fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            _buildTextField(hintText: 'Create a password', icon: Icons.lock_outline, isPassword: true),
            const SizedBox(height: 40),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9644), foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 4,
              ),
              onPressed: () {},
              child: const Text('Register', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({required String hintText, required IconData icon, bool isPassword = false, TextInputType? keyboardType}) {
    return TextField(
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
      ),
    );
  }
}