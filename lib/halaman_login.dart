import 'package:flutter/material.dart';
import 'halaman_register.dart';
import 'customer/halaman_utama.dart';
import 'admin/dashboard_admin.dart';
import '../../../core/network/api_services.dart'; // Import ApiService di sini

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  bool isCustomerSelected = true;
  bool _isPasswordHidden = true;
  bool _isLoading = false; // Menambah state untuk loading

  // Controller untuk menangkap inputan user
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Fungsi proses login
  Future<void> _prosesLogin() async {
    // Validasi kosong
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi ID dan Password!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true); // Mulai animasi loading

    // Memanggil API login
final response = await ApiService.login(
  _idController.text,
  _passwordController.text,
  isCustomerSelected ? 'customer' : 'admin', // <--- UBAH JADI SEPERTI INI
);
    setState(() => _isLoading = false); // Hentikan animasi loading

    // Percabangan hasil login
    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message']), backgroundColor: Colors.green),
      );
      
      // Navigasi dipisah antara Customer dan Admin
      if (isCustomerSelected) {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const HalamanUtama()),
        );
      } else {
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) => const DashboardAdmin()),
        );
      }
    } else {
      // Menampilkan pesan error jika gagal (salah password/id)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Login gagal.'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFDF1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF562F00)),
          onPressed: () => Navigator.pop(context), 
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          children: [
            const Text('Pangsit Njedog', style: TextStyle(color: Color(0xFF562F00), fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            // --- BAGIAN LOGO ---
            Container(
              width: 180, 
              height: 180,
              alignment: Alignment.center,
              child: Image.asset('assets/images/logopangsitnjedok.png'),
            ),
            // -------------------
            
            const SizedBox(height: 32),
            const Text('Welcome Back!', style: TextStyle(color: Color(0xFF562F00), fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(
              isCustomerSelected ? 'Delicious dumplings are just a tap away.' : 'Administrator', 
              style: const TextStyle(color: Color(0xB2562F00), fontSize: 16), 
              textAlign: TextAlign.center
            ),
            const SizedBox(height: 32),

            // Toggle Customer/Admin
            Container(
              height: 48,
              decoration: BoxDecoration(color: const Color(0x19FF9644), borderRadius: BorderRadius.circular(24)),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isCustomerSelected = true;
                          _idController.clear(); // Bersihkan input saat ganti tab
                          _passwordController.clear();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: isCustomerSelected ? const Color(0xFFFF9644) : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text('Customer', style: TextStyle(color: isCustomerSelected ? Colors.white : const Color(0xFF562F00), fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          isCustomerSelected = false;
                          _idController.clear(); // Bersihkan input saat ganti tab
                          _passwordController.clear();
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: !isCustomerSelected ? const Color(0xFFFF9644) : Colors.transparent,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        alignment: Alignment.center,
                        child: Text('Admin', style: TextStyle(color: !isCustomerSelected ? Colors.white : const Color(0xFF562F00), fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),
            Align(
              alignment: Alignment.centerLeft, 
              child: Text(
                isCustomerSelected ? 'Login as Customer' : 'Login as Admin', 
                style: const TextStyle(color: Color(0xFF562F00), fontSize: 18, fontWeight: FontWeight.bold)
              )
            ),
            const SizedBox(height: 16),

            // INPUT PERTAMA (Phone Number / Username)
            Align(
              alignment: Alignment.centerLeft, 
              child: Text(
                isCustomerSelected ? 'Phone Number' : 'Username', 
                style: const TextStyle(color: Color(0xCC562F00), fontWeight: FontWeight.w500)
              )
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _idController, // Memasang Controller
              keyboardType: isCustomerSelected ? TextInputType.phone : TextInputType.text,
              decoration: InputDecoration(
                hintText: isCustomerSelected ? '+62 812 3456 789' : 'Enter Your Username',
                hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                prefixIcon: Icon(
                  isCustomerSelected ? Icons.phone_android : Icons.person_outline, 
                  color: const Color(0xFF6B7280)
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0x33FF9644))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF9644), width: 2)),
              ),
            ),
            const SizedBox(height: 16),

            // INPUT KEDUA (Password)
            const Align(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(color: Color(0xCC562F00), fontWeight: FontWeight.w500))),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController, // Memasang Controller
              obscureText: _isPasswordHidden,
              decoration: InputDecoration(
                hintText: isCustomerSelected ? 'Enter password' : 'Create a Password',
                hintStyle: const TextStyle(color: Color(0xFF6B7280)),
                prefixIcon: const Icon(Icons.lock_outline, color: Color(0xFF6B7280)),
                suffixIcon: IconButton(
                  icon: Icon(_isPasswordHidden ? Icons.visibility_off_outlined : Icons.visibility_outlined, color: const Color(0xFF554337)),
                  onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                ),
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0x33FF9644))),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFFFF9644), width: 2)),
              ),
            ),
            const SizedBox(height: 32),

            // TOMBOL LOGIN
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9644), foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _isLoading ? null : _prosesLogin, // Mencegah double-click saat loading
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),

            // Bagian Sign Up yang hanya muncul jika memilih Customer
            if (isCustomerSelected) ...[
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFFFCE99))),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 12), child: Text('OR', style: TextStyle(color: Color(0x66562F00), fontWeight: FontWeight.bold, fontSize: 12))),
                  Expanded(child: Divider(color: Color(0xFFFFCE99))),
                ],
              ),
              const SizedBox(height: 24),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don’t have an account? ', style: TextStyle(color: Color(0xFF554337))),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanRegister()));
                    },
                    child: const Text('Sign Up', style: TextStyle(color: Color(0xFF954A00), fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ]
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Bersihkan memory controller saat halaman ditutup
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}