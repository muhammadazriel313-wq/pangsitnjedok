import 'package:flutter/material.dart';
// Import screen yang sudah kamu buat sebelumnya
import 'package:aplikasipangsitnjedok/features/apps/customer/profil_customer.dart';
import 'package:aplikasipangsitnjedok/features/apps/customer/edit_profil_customer.dart';
import 'package:aplikasipangsitnjedok/features/apps/customer/order.dart';

class AppRoutes { 
  // Konstanta nama rute
  static const String profile  = '/profile';
  static const String editProfile = '/edit-profile';
  static const String Orders = '/orders';

  // Map semua rute ke widget-nya 
  static Map<String, WidgetBuilder> get routes => { 
    profile:     (_) => const ProfilePage(),
    editProfile: (_) => const EditAccountPage(),
    Orders:      (_) => const MyOrdersPage(),
  }; 
}