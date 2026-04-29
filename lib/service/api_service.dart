import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Alamat URL disesuaikan dengan folder di htdocs kamu
  static const String baseUrl = "http://localhost/pangsit_njedog_api"; 

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
  // 2. FUNGSI MENU (Mengambil Semua Daftar Menu)
  // ============================================================
  static Future<List<dynamic>> getMenus() async {
    try {
      // Memanggil file menu_management.php sesuai permintaanmu
      final response = await http.get(Uri.parse("$baseUrl/menu_management.php"));
      
      if (response.statusCode == 200) {
        // Karena menu_management.php mengirim [ {data}, {data} ], kita return List
        return json.decode(response.body);
      } else {
        throw Exception('Gagal mengambil data Menu. Status: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Gagal memuat daftar menu: $e');
    }
  }

//edit menu
static Future<bool> updateMenu(Map<String, String> data) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/update_menu.php"),
      body: data,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['success'] == true;
    }
    return false;
  } catch (e) {
    print("Error Update Menu: $e");
    return false;
  }
}

// order admin
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

//edit profil admin
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

// edit profile
static Future<bool> updateAdminProfil(Map<String, String> data) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/update_status.php"), // Ganti ke update_profil.php di XAMPP kamu
      body: data,
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['success'] == true;
    }
    return false;
  } catch (e) {
    print("Error Update Profil: $e");
    return false;
  }
}

//Profit admin
static Future<Map<String, dynamic>> getProfitData(String date) async {
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

// Manage Customer
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
// delete customer
static Future<bool> deleteCustomer(String id) async {
  try {
    final response = await http.post(
      Uri.parse("$baseUrl/delete_customer.php"),
      body: {"id": id}, // Mengirimkan ID pelanggan yang mau dihapus
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      return result['success'] == true; // Harus mengembalikan bool
    }
    return false;
  } catch (e) {
    print("Koneksi Error: $e");
    return false;
  }
}
  // Tips: Nanti kalau mau buat fitur Tambah Menu atau Hapus Menu, 
  // kamu tinggal tambah fungsinya di bawah sini dengan http.post
}