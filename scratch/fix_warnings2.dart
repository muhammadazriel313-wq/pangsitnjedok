import 'dart:io';

void main() {
  // Fix my_favorites.dart unused imports and unnecessary underscores
  final favFile = File('lib/customer/my_favorites.dart');
  if (favFile.existsSync()) {
    var content = favFile.readAsStringSync();
    content = content.replaceAll("import 'profil_customer.dart';", "");
    content = content.replaceAll("import 'dashboard_menu.dart';", "");
    content = content.replaceAll("import 'halaman_menu.dart';", "");
    content = content.replaceAll("import 'order.dart';", "");
    content = content.replaceAll("(_, __, ___)", "(context, error, stackTrace)");
    favFile.writeAsStringSync(content);
  }

  // Fix dashboard_menu.dart unused imports
  final dashFile = File('lib/customer/dashboard_menu.dart');
  if (dashFile.existsSync()) {
    var content = dashFile.readAsStringSync();
    content = content.replaceAll("import 'halaman_menu.dart';", "");
    content = content.replaceAll("import 'profil_customer.dart';", "");
    dashFile.writeAsStringSync(content);
  }

  // Fix profil_customer.dart unused imports
  final profFile = File('lib/customer/profil_customer.dart');
  if (profFile.existsSync()) {
    var content = profFile.readAsStringSync();
    content = content.replaceAll("import 'dashboard_menu.dart';", "");
    content = content.replaceAll("import 'halaman_menu.dart';", "");
    profFile.writeAsStringSync(content);
  }

  // Fix rating_views.dart
  final ratingFile = File('lib/customer/rating_views.dart');
  if (ratingFile.existsSync()) {
    var content = ratingFile.readAsStringSync();
    content = content.replaceAll("(_, __, ___)", "(context, error, stackTrace)");
    ratingFile.writeAsStringSync(content);
  }

  // Fix reviews.dart
  final reviewFile = File('lib/customer/reviews.dart');
  if (reviewFile.existsSync()) {
    var content = reviewFile.readAsStringSync();
    content = content.replaceAll("(_, __, ___)", "(context, error, stackTrace)");
    
    // Fix use_build_context_synchronously
    if (content.contains("ScaffoldMessenger.of(context).showSnackBar(")) {
      content = content.replaceAll("ScaffoldMessenger.of(context).showSnackBar(", 
      "if (!mounted) return; ScaffoldMessenger.of(context).showSnackBar(");
    }
    reviewFile.writeAsStringSync(content);
  }

  // Fix halaman_menu.dart use_build_context_synchronously
  final halMenuFile = File('lib/customer/halaman_menu.dart');
  if (halMenuFile.existsSync()) {
    var content = halMenuFile.readAsStringSync();
    content = content.replaceAll("import 'package:flutter/foundation.dart';", "");
    if (content.contains("ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengubah favorit!')));")) {
      content = content.replaceAll("ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengubah favorit!')));",
      "if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal mengubah favorit!')));");
    }
    halMenuFile.writeAsStringSync(content);
  }

  // Fix edit_profil_customer.dart unnecessary import
  final editProfFile = File('lib/customer/edit_profil_customer.dart');
  if (editProfFile.existsSync()) {
    var content = editProfFile.readAsStringSync();
    content = content.replaceAll("import 'dart:typed_data';", "");
    editProfFile.writeAsStringSync(content);
  }

  // Fix api_service.dart unnecessary import
  final apiServiceFile = File('lib/service/api_service.dart');
  if (apiServiceFile.existsSync()) {
    var content = apiServiceFile.readAsStringSync();
    content = content.replaceAll("import 'dart:typed_data';", "");
    apiServiceFile.writeAsStringSync(content);
  }
}
