import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  // Alamat URL disesuaikan dengan folder di htdocs kamu
  static const String baseUrl = "http://localhost/pangsit_njedok_api";

  // ============================================================
  // 1. FUNGSI DASHBOARD (Mengambil Ringkasan Data)
  // ============================================================
  static Future<Map<String, dynamic>> getDashboardData() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/dashboard.php"));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal mengambil data Dashboard. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Tidak bisa terhubung ke server XAMPP: $e');
    }
  }

  // ============================================================
  // 2. FUNGSI GET SEMUA MENU
  // ============================================================
  static Future<List<dynamic>> getMenus() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/menu_management.php"));
      
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal mengambil data Menu. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal memuat daftar menu: $e');
    }
  }

  // ============================================================
  // FUNGSI ORDER ADMIN
  // ============================================================
  static Future<List<dynamic>> getOrders() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/order_admin.php"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Gagal memuat pesanan. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Kesalahan koneksi: $e');
    }
  }

  static Future<bool> updateOrderStatus(String id, String newStatus) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/update_status.php"),
        body: {
          "id": id,
          "status": newStatus,
        },
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      print("Error update status: $e");
      return false;
    }
  }

  // ============================================================
  // FUNGSI PROFIL ADMIN
  // ============================================================
  static Future<Map<String, dynamic>?> getAdminProfil() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/profil_admin.php"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      return null;
    } catch (e) {
      print("Error Profil: $e");
      return null;
    }
  }

 static Future<bool> updateAdminProfil(Map<String, String> data, {Uint8List? imageBytes}) async {
  try {
    // Gunakan MultipartRequest untuk upload file
    var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/update_profil.php"));

    // Masukkan data teks
    data.forEach((key, value) {
      request.fields[key] = value;
    });

    // Masukkan file foto profil jika ada
    if (imageBytes != null) {
      request.files.add(http.MultipartFile.fromBytes(
        'image', 
        imageBytes, 
        filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
      ));
    }

    var response = await request.send();
    return response.statusCode == 200;
  } catch (e) {
    print("Error Update Profil: $e");
    return false;
  }
}

  // ============================================================
  // FUNGSI profit ADMIN
  // ============================================================
  static Future<Map<String, dynamic>> getprofitData(String date) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/profit_admin.php?date=$date"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
      throw Exception('Gagal memuat data');
    } catch (e) {
      return {
        "total_revenue": "Rp 0",
        "net_profit": "Rp 0",
        "chart_data": [0.1, 0.1, 0.1, 0.1, 0.1, 0.1, 0.1],
        "best_selling": []
      };
    }
  }

  // MANAGE CUSTOMER
  
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