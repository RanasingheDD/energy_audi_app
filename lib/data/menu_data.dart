
import 'package:energy_app/models/menu_model.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard'),
    MenuModel(icon: Icons.analytics, title: 'Reports'),
    MenuModel(icon: Icons.settings, title: 'Settings'),
  ];
}
