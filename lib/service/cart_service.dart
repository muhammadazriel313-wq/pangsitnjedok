import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CartItem {
  final String title;
  final String subtitle;
  final int price;
  int qty;

  CartItem({
    required this.title,
    required this.subtitle,
    required this.price,
    required this.qty,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'price': price,
        'qty': qty,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) {
    final parsedPrice = int.tryParse('${json['price'] ?? 0}') ?? 0;
    final parsedQty = int.tryParse('${json['qty'] ?? 0}') ?? 0;
    return CartItem(
      title: json['title']?.toString() ?? 'Menu',
      subtitle: json['subtitle']?.toString() ?? '-',
      price: parsedPrice,
      qty: parsedQty < 0 ? 0 : parsedQty,
    );
  }

  CartItem copy() {
    return CartItem(title: title, subtitle: subtitle, price: price, qty: qty);
  }
}

class CartService {
  static const String storageKey = 'customer_cart_items_v2';

  static final List<CartItem> _defaultCartItems = [];

  static Future<List<CartItem>> getCartItems() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(storageKey);
    if (raw == null || raw.isEmpty) {
      return _defaultCartItems.map((item) => item.copy()).toList();
    }
    try {
      final decoded = jsonDecode(raw);
      if (decoded is List) {
        return decoded
            .whereType<Map>()
            .map((item) => CartItem.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    } catch (e) {
      debugPrint("Error load cart: $e");
    }
    return _defaultCartItems.map((item) => item.copy()).toList();
  }

  static Future<void> addToCart(String title, int price, String category) async {
    final items = await getCartItems();
    final index = items.indexWhere((item) => item.title.toLowerCase() == title.toLowerCase());
    if (index >= 0) {
      items[index].qty++;
    } else {
      items.add(CartItem(
        title: title,
        subtitle: category.isNotEmpty ? category : '-',
        price: price,
        qty: 1,
      ));
    }
    await saveCartItems(items);
  }

  static Future<void> saveCartItems(List<CartItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final payload = items.map((item) => item.toJson()).toList();
    await prefs.setString(storageKey, jsonEncode(payload));
  }

  static Future<int> getCartCount() async {
    final items = await getCartItems();
    return items.fold<int>(0, (sum, item) => sum + item.qty);
  }
}
