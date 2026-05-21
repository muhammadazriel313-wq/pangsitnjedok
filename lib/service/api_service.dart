import 'dart:convert';
import 'dart:typed_data'; 
import 'package:http/http.dart' as http;

class ApiService {
  // 📍 BASE URL (Alamat Server Backend)
  // - Pakai 'http://localhost/pangsit_njedok_api' kalau kamu jalankan di Web atau Simulator iOS.
  // - Pakai 'http://10.0.2.2/pangsit_njedok_api' kalau kamu jalankan di Emulator Android bawaan.
  // - Pakai IP HP/Laptop kamu (misal: 'http://192.168.1.5/pangsit_njedok_api') kalau kamu jalankan di HP asli (koneksikan HP & Laptop ke Wi-Fi yang sama).
  static const String baseUrl = "http://localhost/pangsit_njedok_api"; 

  // ============================================================
  // ⭐ [TAMBAHAN BARU] FUNGSI AUTH & PROFIL CUSTOMER
  // ============================================================
  
  static Future<Map<String, dynamic>> login(String id, String password, String role) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/login.php"),
        body: {"id": id, "password": password, "role": role},
      );
      return response.statusCode == 200 ? json.decode(response.body) : {"status": "error", "message": "Gagal Login"};
    } catch (e) {
      return {"status": "error", "message": "Koneksi Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> register(String name, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/register.php"),
        body: {"name": name, "no_telepon": phone, "password": password},
      );
      return response.statusCode == 200 ? json.decode(response.body) : {"status": "error", "message": "Gagal Daftar"};
    } catch (e) {
      return {"status": "error", "message": "Koneksi Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> getProfile(String id) async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/get_profil.php?id=$id"));
      return response.statusCode == 200 ? json.decode(response.body) : {"status": "error", "message": "Gagal Ambil Data"};
    } catch (e) {
      return {"status": "error", "message": "Koneksi Error: $e"};
    }
  }

  static Future<Map<String, dynamic>> updateProfile(String id, String name, String phone) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/ganti_profil.php"), // Menggunakan ganti_profil.php sesuai file yang ada di backend
        body: {"id": id, "name": name, "no_telepon": phone},
      );
      return response.statusCode == 200 ? json.decode(response.body) : {"status": "error", "message": "Gagal Update"};
    } catch (e) {
      return {"status": "error", "message": "Koneksi Error: $e"};
    }
  }

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
    final endpoints = ['update_status.php', 'update_status_order.php'];
    for (final endpoint in endpoints) {
      try {
        final response = await http.post(
          Uri.parse("$baseUrl/$endpoint"),
          body: {
            "id": id,
            "status": newStatus,
          },
        );

        if (response.statusCode != 200) continue;

        final body = response.body.trim();
        if (body.isEmpty) return true;

        final result = json.decode(body);
        if (result is Map<String, dynamic>) {
          if (result['success'] == true) return true;
          if ((result['status'] ?? '').toString().toLowerCase() == 'success') {
            return true;
          }
        }
      } catch (e) {
        print("Error update status ($endpoint): $e");
      }
    }
    return false;
  }

  static Future<List<dynamic>> getCustomerOrders({
    String? phoneNumber,
    String? customerName,
  }) async {
    final orders = await getOrders();

    final normalizedPhone = (phoneNumber ?? '').trim();
    final normalizedName = (customerName ?? '').trim().toLowerCase();

    if (normalizedPhone.isEmpty && normalizedName.isEmpty) {
      return orders;
    }

    return orders.where((rawOrder) {
      final order = Map<String, dynamic>.from(rawOrder as Map);
      final orderPhone = (order['no_telepon'] ?? '').toString().trim();
      final orderName = (order['customerName'] ?? '').toString().trim().toLowerCase();

      final phoneMatch =
          normalizedPhone.isNotEmpty && orderPhone == normalizedPhone;
      final nameMatch = normalizedName.isNotEmpty && orderName == normalizedName;
      return phoneMatch || nameMatch;
    }).toList();
  }

  static Future<Map<String, dynamic>> acceptOrderAndUpdateStock({
    required String orderId,
    required List<Map<String, dynamic>> items,
  }) async {
    final statusUpdated = await updateOrderStatus(orderId, 'PROCESSING');
    if (!statusUpdated) {
      return {
        'success': false,
        'statusUpdated': false,
        'stockUpdated': false,
      };
    }

    final stockUpdated = await _decreaseStockByItems(items);
    return {
      'success': true,
      'statusUpdated': true,
      'stockUpdated': stockUpdated,
    };
  }

  static Future<bool> _decreaseStockByItems(List<Map<String, dynamic>> items) async {
    if (items.isEmpty) return true;

    try {
      final menus = await getMenus();
      final mutableMenus = menus
          .whereType<Map>()
          .map((menu) => Map<String, dynamic>.from(menu))
          .toList();

      for (final item in items) {
        final title = (item['name'] ?? '').toString().trim();
        final qty = int.tryParse('${item['qty'] ?? 0}') ?? 0;
        if (title.isEmpty || qty <= 0) continue;

        final menuIndex = mutableMenus.indexWhere((menu) {
          final menuTitle = (menu['title'] ?? '').toString().trim();
          return menuTitle.toLowerCase() == title.toLowerCase();
        });

        if (menuIndex < 0) continue;

        final menu = mutableMenus[menuIndex];
        final currentStock = int.tryParse('${menu['stock'] ?? 0}') ?? 0;
        final nextStock = (currentStock - qty).clamp(0, 9999999);

        final updatePayload = <String, String>{
          'id': '${menu['id']}',
          'title': '${menu['title'] ?? ''}',
          'price': '${menu['price'] ?? 0}',
          'stock': '$nextStock',
          'category': '${menu['category'] ?? 'food'}',
        };

        final updated = await updateMenu(updatePayload);
        if (!updated) return false;

        menu['stock'] = nextStock;
      }

      return true;
    } catch (e) {
      print('Error reduce stock: $e');
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
      final response = await http.get(Uri.parse("$baseUrl/profit_admin.php?date=$date"));
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
      return response.statusCode == 200 ? json.decode(response.body) : [];
    } catch (e) {
      return [];
    }
  }

  static Future<bool> deleteCustomer(String id) async {
    try {
      final response = await http.post(Uri.parse("$baseUrl/delete_customer.php"), body: {"id": id});
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
      return response.statusCode == 200 ? json.decode(response.body) : {};
    } catch (e) {
      print("Error Fetch Dashboard: $e");
      return {};
    }
  }

  // FUNGSI MENU CRUD (ADD, UPDATE, DELETE)
  static Future<bool> addMenu(Map<String, dynamic> data, {Uint8List? imageBytes, String? fileName}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/add_menu.php"));
      data.forEach((key, value) => request.fields[key] = value.toString());
      if (imageBytes != null && fileName != null) {
        request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: fileName));
      }
      var response = await request.send();
      return response.statusCode == 200;
    } catch (e) {
      print("Add Menu Error: $e");
      return false;
    }
  }

  static Future<bool> updateMenu(Map<String, String> data, {Uint8List? imageBytes}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/update_menu.php"));
      data.forEach((key, value) => request.fields[key] = value);
      if (imageBytes != null) {
        request.files.add(http.MultipartFile.fromBytes('image', imageBytes, filename: 'menu_${DateTime.now().millisecondsSinceEpoch}.jpg'));
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
      final response = await http.post(Uri.parse("$baseUrl/delete_menu.php"), body: {'id': id});
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
      final response = await http.get(Uri.parse("$baseUrl/get_favorites.php?customer_id=$customerId"));
      return response.statusCode == 200 ? json.decode(response.body) : [];
    } catch (e) {
      print("Error Get Favorites: $e");
      return [];
    }
  } // Batas penutup fungsi getFavorites

  // ============================================================
  // FUNGSI SIMPAN PESANAN (CHECKOUT)
  // ============================================================
  static Future<bool> submitOrder(Map<String, dynamic> orderData) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/simpan_pesanan.php"),
        headers: {
          "Content-Type": "application/json", 
        },
        body: jsonEncode(orderData), 
      );

      print("Response PHP Simpan Pesanan: ${response.body}"); 

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("PHP mengirim balasan kosong!");
          return false;
        }

        final result = jsonDecode(response.body);
        return result['success'] == true;
      }
      return false;
    } catch (e) {
      print("Error saat submitOrder: $e");
      return false;
    }
  } // Batas penutup fungsi submitOrder

  // Tambahkan fungsi ini di dalam class ApiService (sebelum kurung penutup terakhir)
  static Future<bool> toggleFavorite(String customerId, String menuId, String action) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/toggle_favorite.php"),
        body: {
          "customer_id": customerId,
          "menu_id": menuId,
          "action": action
        },
      );
      return response.statusCode == 200;
    } catch (e) {
      print("Error toggleFavorite: $e");
      return false;
    }
  }

} // <--- KURUNG KURAWAL INI HARUS DI PALING BAWAH UNTUK MENUTUP CLASS APISERVICE

