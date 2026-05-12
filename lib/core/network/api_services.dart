import 'dart:convert'; 
import 'package:http/http.dart' as http; 
 
class ApiService { 
  // Ubah localhost menjadi 10.0.2.2 untuk emulator Android
  static const String _baseUrl = 'http://10.0.2.2/pangsit_njedok_API'; 
  
  static Future<Map<String, dynamic>> updateProfile(String id, String name, String phone) async {
    try {
      // Gunakan _baseUrl agar lebih rapi dan mudah diubah
      var url = Uri.parse("$_baseUrl/ganti_profil.php");
      
      var response = await http.post(url, body: {
        "id": id,
        "name": name,
        "no_telepon": phone,
      });

      return jsonDecode(response.body);
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  // ===================== 
  // GET PROFILE
  // ===================== 
  static Future<Map<String, dynamic>> getProfile(String id) async {
    try {
      // Gunakan _baseUrl di sini juga
      final response = await http.get(Uri.parse("$_baseUrl/get_profil.php?id=$id"));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Gagal terhubung ke server"};
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }
}