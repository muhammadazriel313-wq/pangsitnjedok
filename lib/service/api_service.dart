import 'dart:convert';
import 'dart:typed_data'; // Tambahan wajib untuk baca bytes gambar
import 'package:http/http.dart' as http;

class ApiService {
  // Alamat URL disesuaikan dengan folder di htdocs kamu
  // Gunakan 10.0.2.2 untuk emulator Android atau localhost untuk iOS/Web
  static const String baseUrl = "http://localhost/pangsit_njedok_api"; 

  // ============================================================
  // 1. FUNGSI PROFIL CUSTOMER (BARU GABUNGAN)
  // ============================================================
  
  static Future<Map<String, dynamic>> getProfile(String id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_profil.php?id=$id"));

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        return {"status": "error", "message": "Gagal terhubung ke server"};
      }
    } catch (e) {
      return {"status": "error", "message": e.toString()};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(String id, String name, String phone) async {
    try {
      var url = Uri.parse("$baseUrl/ganti_profil.php");
      
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

  // ============================================================
  // 2. FUNGSI DASHBOARD (Mengambil Ringkasan Data)
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
  // 3. FUNGSI GET SEMUA MENU
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
  // 4. FUNGSI ORDER ADMIN
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
  // 5. FUNGSI PROFIL ADMIN
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
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/update_profil.php"));

      data.forEach((key, value) {
        request.fields[key] = value;
      });

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
  // 6. FUNGSI PROFIT ADMIN
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

  // ============================================================
  // 7. MANAGE CUSTOMER
  // ============================================================
  static Future<List<dynamic>> getCustomers() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/manage_customer.php'));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      return [];
    }
  }

  static Future<bool> deleteCustomer(String id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delete_customer.php"),
        body: {"id": id}, 
      );

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        return result['success'] == true; 
      }
      return false;
    } catch (e) {
      print("Koneksi Error: $e");
      return false;
    }
  }

  static Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/dashboard_stastic.php"));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {};
      }
    } catch (e) {
      print("Error Fetch Dashboard: $e");
      return {};
    }
  }

  // ============================================================
  // 8. FUNGSI MENU CRUD (ADD, UPDATE, DELETE)
  // ============================================================

  static Future<bool> addMenu(Map<String, dynamic> data, {Uint8List? imageBytes, String? fileName}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/add_menu.php"));

      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      if (imageBytes != null && fileName != null) {
        var multipartFile = http.MultipartFile.fromBytes(
          'image', 
          imageBytes, 
          filename: fileName,
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      var responseData = await response.stream.bytesToString();
      
      if (response.statusCode == 200) {
        final result = json.decode(responseData);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      print("Add Menu Error: $e");
      return false;
    }
  }

  static Future<bool> updateMenu(Map<String, String> data, {Uint8List? imageBytes}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/update_menu.php"));

      data.forEach((key, value) {
        request.fields[key] = value;
      });

      if (imageBytes != null) {
        var multipartFile = http.MultipartFile.fromBytes(
          'image', 
          imageBytes, 
          filename: 'menu_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print("Update Menu Error: $e");
      return false;
    }
  }

  static Future<bool> deleteMenu(String id) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/delete_menu.php"),
        body: {'id': id}, 
      );
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ============================================================
  // 9. FUNGSI GET FAVORIT
  // ============================================================
  static Future<List<dynamic>> getFavorites(int customerId) async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/get_favorites.php?customer_id=$customerId"),
      );
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return [];
      }
    } catch (e) {
      print("Error Get Favorites: $e");
      return [];
    }
  }
}