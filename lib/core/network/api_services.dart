import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class ApiService {
  // Alamat URL disesuaikan dengan folder di htdocs kamu
  static const String baseUrl = "http://localhost/pangsit_api"; 

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

  
  // FUNGSI MENU CRUD (ADD, UPDATE, DELETE)

  // 1. ADD MENU (VERSI BARU YANG BISA UPLOAD FOTO)
  static Future<bool> addMenu(Map<String, dynamic> data, {Uint8List? imageBytes, String? fileName}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/add_menu.php"));

      // Masukkan data teks
      data.forEach((key, value) {
        request.fields[key] = value.toString();
      });

      // Masukkan file foto (jika user memilih foto)
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

  // 2. UPDATE MENU
  static Future<bool> updateMenu(Map<String, String> data, {Uint8List? imageBytes}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/update_menu.php"));

      // Masukkan data teks (id, title, price, dll)
      data.forEach((key, value) {
        request.fields[key] = value;
      });

      // Masukkan file foto (jika admin memilih foto baru di galeri)
      if (imageBytes != null) {
        var multipartFile = http.MultipartFile.fromBytes(
          'image', 
          imageBytes, 
          filename: 'menu_${DateTime.now().millisecondsSinceEpoch}.jpg',
        );
        request.files.add(multipartFile);
      }

      var response = await request.send();
      
      // Cek apakah berhasil
      if (response.statusCode == 200) {
        return true;
      }
      return false;
    } catch (e) {
      print("Update Menu Error: $e");
      return false;
    }
  }

  // 3. DELETE MENU
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
  // FUNGSI LOGIN
  // ============================================================
  static Future<Map<String, dynamic>> login(String identifier, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {
          "identifier": identifier,
          "password": password,
          "role": role, // 'admin' atau 'customer'
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return {"status": "error", "message": "Gagal terhubung ke server HTTP ${response.statusCode}"};
      }
    } catch (e) {
      return {"status": "error", "message": "Tidak dapat terhubung ke server: $e"};
    }
  }

  // ============================================================
  // FUNGSI REGISTRASI CUSTOMER (Baru Ditambahkan)
  // ============================================================
  static Future<Map<String, dynamic>> register(String name, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register.php'),
        body: {
          'name': name,
          'phone': phone,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body); 
      } else {
        return {'status': 'error', 'message': 'Gagal terhubung ke server database'};
      }
    } catch (e) {
      return {'status': 'error', 'message': 'Terjadi kesalahan sistem: $e'};
    }
  }
}