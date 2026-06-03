import 'package:flutter/material.dart';
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
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialData['name']);
    _usernameController = TextEditingController(text: widget.initialData['username']);
    _phoneController = TextEditingController(text: widget.initialData['phone']);
    _emailController = TextEditingController(text: widget.initialData['email']);
  }

  Future<void> _saveProfile() async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442))),
    );

    Map<String, String> updatedData = {
      'name': _nameController.text,
      'username': _usernameController.text,
      'phone': _phoneController.text,
      'email': _emailController.text,
    };
    
    bool isSuccess = await ApiService.updateAdminProfil(
      updatedData
    );

    if (!mounted) return;
    Navigator.pop(context); // Tutup Loading dialog

    if (isSuccess) {
      Navigator.pop(context, true); 
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile Updated Successfully!'), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to save. Check XAMPP connection!'), backgroundColor: Colors.red),
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
            const SizedBox(height: 16),
            const Icon(Icons.account_circle, size: 100, color: Colors.grey),
            const SizedBox(height: 32),
            _buildFormSection(),
          ],
        ),
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
            child: const Text('Save Changes', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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
