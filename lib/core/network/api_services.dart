import 'dart:convert'; 
import 'package:http/http.dart' as http; 
 
class ApiService { 
  static const String _baseUrl = 'http://localhost/pangsit_njedok_API'; 
  static Future<Map<String, dynamic>> updateProfile(String id, String name, String phone) async {
  try {
    var url = Uri.parse("http://localhost/pangsit_njedok_API/ganti_profil.php");
    
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
  static Future<Map<String, dynamic>> getProfil(String id) async {
  // Ganti URL dengan alamat file PHP kamu
  // Jika pakai emulator Android, gunakan 10.0.2.2 sebagai ganti localhost
  final response = await http.get(Uri.parse("http://localhost/pangsit_njedok_API/get_profil.php?id=$id"));

  if (response.statusCode == 200) {
    return jsonDecode(response.body);
  } else {
    return {"status": "error"};
  }
}
}