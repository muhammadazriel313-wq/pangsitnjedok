import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/api_service.dart'; // ✅ Using the main ApiService
import 'package:image_picker/image_picker.dart';
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
      userId = prefs.getString('customer_id') ?? "1"; 
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

 void _saveChanges() async {
    setState(() => isLoading = true); 
    try {
      // ✅ DIPERBAIKI: Menambahkan imageBytes: _imageBytes ke dalam parameter
      var response = await ApiService.updateProfile(
        userId, 
        nameController.text, 
        phoneController.text,
        imageBytes: _imageBytes, // <--- Ini yang sebelumnya kurang
      );

      if (response['status'] == 'success') {
        if (mounted) {
          PaintingBinding.instance.imageCache.clear();
          PaintingBinding.instance.imageCache.clearLiveImages();
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated Successfully!")));
          Navigator.pop(context, true);
        }
      } else {
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Failed: ${response['message']}")));
      }
    } catch (e) {
      debugPrint("Error: $e");
    } finally {
      if (mounted) setState(() => isLoading = false); 
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFFFDF1), Color(0xFFFFE8D6)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF954A00)),
                  onPressed: () => Navigator.pop(context, true),
                ),
                title: const Text(
                  'Edit Profile', 
                  style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold, fontSize: 18)
                ),
              ),
              Expanded(
                child: isLoading 
                    ? const Center(child: CircularProgressIndicator(color: Color(0xFFFF9442)))
                    : SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                        child: Column(
                          children: [
                            // Foto Profil dengan Glow Effect
                            Center(
                              child: Stack(
                                clipBehavior: Clip.none,
                                children: [
                        Container(
                          width: 130, height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle, 
                            border: Border.all(color: Colors.white, width: 4),
                            boxShadow: [
                              BoxShadow(color: const Color(0xFFFF9442).withValues(alpha: 0.3), blurRadius: 20, spreadRadius: 4)
                            ],
                          ),
                          child: ClipOval(
                            child: _imageBytes != null
                                ? Image.memory(_imageBytes!, fit: BoxFit.cover)
                                : (existingImageUrl != null && existingImageUrl!.isNotEmpty
                                    ? Image.network(
                                        existingImageUrl!.startsWith('http') 
                                            ? existingImageUrl! 
                                            : "${ApiService.baseUrl}/uploads/$existingImageUrl",
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) => Image.asset('assets/images/user.jpg', fit: BoxFit.cover),
                                      )
                                    : Image.asset('assets/images/user.jpg', fit: BoxFit.cover)),
                          ),
                        ),
                        Positioned(
                          bottom: 4, right: 4, 
                          child: GestureDetector(
                            onTap: _pickImage,
                            child: Container(
                              padding: const EdgeInsets.all(10), 
                              decoration: BoxDecoration(
                                color: const Color(0xFFFF9442), 
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3),
                                boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3))]
                              ), 
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 20)
                            ),
                          )
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Form Container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildTextField("Full Name", nameController, Icons.person_outline),
                        const SizedBox(height: 20),
                        _buildTextField("Phone Number", phoneController, Icons.phone_android_outlined),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Save Button
                  ElevatedButton(
                    onPressed: isLoading ? null : _saveChanges, 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9442),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 4,
                      shadowColor: const Color(0xFFFF9442).withValues(alpha: 0.4),
                    ),
                    child: const Text('Save Changes', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            ), // Expanded
            ], // Column children
          ), // Column
        ), // SafeArea
      ), // Container
    ); // Scaffold
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(color: Color(0xFF554337), fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: const Color(0xFF94A3B8)),
            filled: true,
            fillColor: const Color(0xFFF6F4E8),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: Color(0xFFFF9442), width: 1.5),
            ),
          ),
          style: const TextStyle(color: Color(0xFF1B1C15), fontWeight: FontWeight.w600),
        ),
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