import 'package:flutter/material.dart';

class EditAccountPage extends StatelessWidget {
  const EditAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF954A00)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Profile', style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  // Di dalam Column -> Center -> Stack
                  Stack(
                    children: [
                      Container(
                        width: 120, 
                        height: 120,
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFFFF9644), width: 4),
                        image: const DecorationImage(
                        image: AssetImage('assets/images/nipis.jpeg'), 
                        fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0, 
                          right: 0, 
                          child: editCircleIcon(
                          onTap: () {
                            // Tambahkan logika ganti foto di sini
                            print("Tombol ganti foto ditekan!");
          
                            // Contoh: Menampilkan Bottom Sheet untuk pilih Galeri/Kamera
                            showModalBottomSheet(
                          context: context,
                          builder: (context) => Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Ambil dari Kamera'),
                          onTap: () => Navigator.pop(context),
                            ),
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Pilih dari Galeri'),
                          onTap: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
                  const SizedBox(height: 16),
                  const Text('Bocil Windut', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const Text('Premium Member', style: TextStyle(color: Color(0xFF554337), fontStyle: FontStyle.italic)),
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
                  _buildTextField("Full Name", "Bocil Windut"),
                  const SizedBox(height: 20),
                  _buildTextField("Email Address", "bocilreplay@email.com"),
                  const SizedBox(height: 20),
                  _buildTextField("Phone Number", "+62 812-3456-7890"),
                ],
              ),
            ),
            
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(color: const Color(0xFFF6E8D8), borderRadius: BorderRadius.circular(20)),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_user_outlined, size: 16, color: Color(0xFF633909)),
                  SizedBox(width: 8),
                  Text('ACCOUNT VERIFIED', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF633909))),
                ],
              ),
            ),

            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                content: const Text('Profil berhasil di ganti!'),
                backgroundColor: const Color(0xFF954A00),
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9644),
                minimumSize: const Size(double.infinity, 60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                elevation: 5, shadowColor: const Color(0xFFFF9644),
              ),
              child: const Text('Save Changes', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF6C3400))),
            ),
            
            const SizedBox(height: 20),
            const Text.rich(TextSpan(children: [
              TextSpan(text: 'Having trouble? ', style: TextStyle(color: Colors.grey)),
              TextSpan(text: 'Contact Support', style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold)),
            ])),
            const SizedBox(height: 100),
          ],
        ),
      ),
      bottomNavigationBar: buildBottomNavbar(context, true),
      floatingActionButton: buildFAB(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildTextField(String label, String initialValue) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF554337), fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: initialValue,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFE4E3D7),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
      ],
    );
  }
}

// --- GLOBAL REUSABLE WIDGETS ---
// Digunakan di kedua file
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

Widget buildBottomNavbar(BuildContext context, bool isProfileActive) {
  return BottomAppBar(
    height: 70, color: Colors.white,
    shape: const CircularNotchedRectangle(),
    notchMargin: 8,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        navbarItem(Icons.home_outlined, 'Home', false),
        navbarItem(Icons.restaurant_menu, 'Menu', false),
        const SizedBox(width: 40),
        navbarItem(Icons.receipt_long_outlined, 'Orders', false),
        navbarItem(Icons.person, 'Profile', isProfileActive),
      ],
    ),
  );
}

Widget navbarItem(IconData icon, String label, bool isActive) {
  return Column(mainAxisSize: MainAxisSize.min, children: [
    Icon(icon, color: isActive ? const Color(0xFFFF9442) : Colors.grey),
    Text(label, style: TextStyle(fontSize: 10, color: isActive ? const Color(0xFFFF9442) : Colors.grey)),
  ]);
}

Widget buildFAB() {
  return FloatingActionButton(
    onPressed: () {},
    backgroundColor: const Color(0xFFFF9442),
    shape: const CircleBorder(),
    child: const Badge(label: Text('3'), child: Icon(Icons.shopping_cart_outlined, color: Colors.white)),
  );
}