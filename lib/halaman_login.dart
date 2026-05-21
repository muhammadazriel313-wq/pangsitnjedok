import 'package:flutter/material.dart';
import 'halaman_register.dart'; 
import 'service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HalamanLogin extends StatefulWidget {
  const HalamanLogin({super.key});

  @override
  State<HalamanLogin> createState() => _HalamanLoginState();
}

class _HalamanLoginState extends State<HalamanLogin> {
  bool isCustomerSelected = true;
  bool _isPasswordHidden = true;
  bool _isLoading = false; 

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _prosesLogin() async {
    if (_idController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Harap isi ID dan Password!'), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Memanggil fungsi login dari ApiService
      final response = await ApiService.login(
        _idController.text,
        _passwordController.text,
        isCustomerSelected ? 'customer' : 'admin', 
      );
      if (!mounted) return; 
      setState(() => _isLoading = false);

      if (response['status'] == 'success') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Login sukses!'), backgroundColor: Colors.green),
        );
        
        // 💾 Simpan session (data login) ke memori HP biar tidak usah hardcode ID "1" lagi
        final prefs = await SharedPreferences.getInstance();
        final userData = response['data'];
        if (userData != null) {
          if (isCustomerSelected) {
            await prefs.setString('customer_id', userData['id'].toString());
            await prefs.setString('customer_name', userData['name'].toString());
            await prefs.setString('customer_phone', _idController.text);
          } else {
            await prefs.setString('admin_id', userData['id'].toString());
            await prefs.setString('admin_name', userData['name'].toString());
          }
        }
        
        if (isCustomerSelected) {
          Navigator.pushReplacementNamed(context, '/home_customer');
        } else {
          Navigator.pushReplacementNamed(context, '/dashboard_admin');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Login gagal.'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
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
            const Text('Pangsit Njedok', style: TextStyle(color: Color(0xFF562F00), fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            
            Container(
              width: 180, 
              height: 180,
              alignment: Alignment.center,
              child: Image.asset('assets/images/logopangsitnjedok1.png'),
            ),
            
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
                          _idController.clear();
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
                          _idController.clear();
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

            // INPUT Phone Number / Username
            Align(
              alignment: Alignment.centerLeft, 
              child: Text(
                isCustomerSelected ? 'Phone Number' : 'Username', 
                style: const TextStyle(color: Color(0xCC562F00), fontWeight: FontWeight.w500)
              )
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _idController,
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

            // INPUT Password
            const Align(alignment: Alignment.centerLeft, child: Text('Password', style: TextStyle(color: Color(0xCC562F00), fontWeight: FontWeight.w500))),
            const SizedBox(height: 8),
            TextField(
              controller: _passwordController,
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

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9644), foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 56), 
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
              ),
              onPressed: _isLoading ? null : _prosesLogin,
              child: _isLoading
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text('Login', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 24),

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
    _idController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
