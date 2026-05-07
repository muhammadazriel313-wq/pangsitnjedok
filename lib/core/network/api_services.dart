class ApiServices {
  // Gunakan IP ini agar emulator Android bisa akses XAMPP di laptop
  static const String baseUrl = "http://10.0.2.2/pangsit_api";

  // Fungsi untuk mengambil daftar favorit
  Future<List<dynamic>> getFavorites(int customerId) async {
    final response = await http.get(
      Uri.parse("$baseUrl/get_favorites.php?customer_id=$customerId"),
    );
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      return [];
    }
  }
}