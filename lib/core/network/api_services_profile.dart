import 'dart:convert'; 
import 'package:flutter/foundation.dart'; // Wajib ditambahkan untuk menggunakan Uint8List
import 'package:http/http.dart' as http; 
 
class ApiService { 
  static const String _baseUrl = "http://localhost/pangsit_njedok_api"; 
  
  // ✅ Menambahkan parameter {Uint8List? imageBytes} di sini
  static Future<Map<String, dynamic>> updateProfile(String id, String name, String phone, {Uint8List? imageBytes}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$_baseUrl/ganti_profil.php"));
      
      // Mengirim data teks
      request.fields['id'] = id;
      request.fields['name'] = name;
      request.fields['no_telepon'] = phone;

      // ✅ Mengirim file gambar jika ada gambar yang dipilih
      if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes(
          'image', 
          imageBytes, 
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
        ));
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

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