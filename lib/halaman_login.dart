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
        const SnackBar(content: Text('Please enter ID and Password!'), backgroundColor: Colors.red),
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
          SnackBar(content: Text(response['message'] ?? 'Login successful!'), backgroundColor: Colors.green),
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
        
        if (!mounted) return;
        
        if (isCustomerSelected) {
          Navigator.pushReplacementNamed(context, '/home_customer');
        } else {
          Navigator.pushReplacementNamed(context, '/dashboard_admin');
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(response['message'] ?? 'Login failed.'), backgroundColor: Colors.red),
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFFDF1),
              Color(0xFFFFE8D6),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                // Modern Image/Logo Container
                Container(
                  width: 150, 
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFFF9442).withValues(alpha: 0.2),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      )
                    ]
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(75),
                    child: Image.asset('assets/images/logopangsitnjedok1.png', fit: BoxFit.cover),
                  ),
                ),
                
                const SizedBox(height: 32),
                const Text(
                  'Welcome Back!', 
                  style: TextStyle(
                    color: Color(0xFF4A2B12), 
                    fontSize: 32, 
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.5,
                  )
                ),
                const SizedBox(height: 8),
                Text(
                  isCustomerSelected ? 'Log in to continue your delicious journey.' : 'Administrator Access', 
                  style: const TextStyle(color: Color(0xFF8B6B52), fontSize: 16, fontWeight: FontWeight.w500), 
                  textAlign: TextAlign.center
                ),
                const SizedBox(height: 36),

                // Elegant Toggle Customer/Admin
                Container(
                  height: 54,
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.white, 
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
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
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: isCustomerSelected ? const Color(0xFFFF9442) : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: isCustomerSelected ? [
                                BoxShadow(
                                  color: const Color(0xFFFF9442).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ] : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Customer', 
                              style: TextStyle(
                                color: isCustomerSelected ? Colors.white : const Color(0xFF8B6B52), 
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )
                            ),
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
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: !isCustomerSelected ? const Color(0xFFFF9442) : Colors.transparent,
                              borderRadius: BorderRadius.circular(26),
                              boxShadow: !isCustomerSelected ? [
                                BoxShadow(
                                  color: const Color(0xFFFF9442).withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 2),
                                )
                              ] : [],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              'Admin', 
                              style: TextStyle(
                                color: !isCustomerSelected ? Colors.white : const Color(0xFF8B6B52), 
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                const SizedBox(height: 40),

                // INPUT Phone Number / Username (Modern Input Field)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  child: TextField(
                    controller: _idController,
                    keyboardType: isCustomerSelected ? TextInputType.phone : TextInputType.text,
                    decoration: InputDecoration(
                      labelText: isCustomerSelected ? 'Phone Number' : 'Username',
                      labelStyle: const TextStyle(color: Color(0xFF8B6B52), fontWeight: FontWeight.w500),
                      hintText: isCustomerSelected ? '+62 812 3456 789' : 'Enter Your Username',
                      hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
                      prefixIcon: Icon(
                        isCustomerSelected ? Icons.phone_iphone_rounded : Icons.person_rounded, 
                        color: const Color(0xFFFF9442),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // INPUT Password (Modern Input Field)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      )
                    ]
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: _isPasswordHidden,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: const TextStyle(color: Color(0xFF8B6B52), fontWeight: FontWeight.w500),
                      hintText: 'Enter password',
                      hintStyle: const TextStyle(color: Color(0xFFD1D5DB)),
                      prefixIcon: const Icon(Icons.lock_rounded, color: Color(0xFFFF9442)),
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordHidden ? Icons.visibility_off_rounded : Icons.visibility_rounded, color: const Color(0xFF8B6B52)),
                        onPressed: () => setState(() => _isPasswordHidden = !_isPasswordHidden),
                      ),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                      filled: true,
                      fillColor: Colors.transparent,
                      contentPadding: const EdgeInsets.symmetric(vertical: 20),
                    ),
                  ),
                ),
                
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Silakan hubungi Admin untuk mereset password Anda.'),
                          backgroundColor: Colors.orange,
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFFFF9442),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 10,
                    shadowColor: const Color(0xFFFF9442).withValues(alpha: 0.5),
                  ),
                  onPressed: _isLoading ? null : _prosesLogin,
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9442), Color(0xFFFF7200)],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      constraints: const BoxConstraints(minWidth: double.infinity, minHeight: 60),
                      child: _isLoading
                          ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                          : const Text('Sign In', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                if (isCustomerSelected) ...[
                  Row(
                    children: [
                      Expanded(child: Divider(color: const Color(0xFF4A2B12).withValues(alpha: 0.1), thickness: 1.5)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16), 
                        child: Text('OR', style: TextStyle(color: const Color(0xFF8B6B52).withValues(alpha: 0.8), fontWeight: FontWeight.bold, fontSize: 14))
                      ),
                      Expanded(child: Divider(color: const Color(0xFF4A2B12).withValues(alpha: 0.1), thickness: 1.5)),
                    ],
                  ),
                  const SizedBox(height: 24),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don’t have an account? ', style: TextStyle(color: Color(0xFF8B6B52), fontSize: 15)),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const HalamanRegister()));
                        },
                        child: const Text('Sign Up', style: TextStyle(color: Color(0xFFFF7200), fontWeight: FontWeight.w900, fontSize: 15)),
                      ),
                    ],
                  ),
                ]
              ],
            ),
          ),
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