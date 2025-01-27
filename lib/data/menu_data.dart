import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/models/menu_model.dart';
import 'package:energy_app/pages/settings_page.dart';
import 'package:energy_app/report/fetch_report.dart';
import 'package:energy_app/pages/report.dart';
import 'package:flutter/material.dart';

class SideMenuData {
  final menu = <MenuModel>[
    MenuModel(icon: Icons.home, title: 'Dashboard', page: const HomePage()),
    MenuModel(icon: Icons.analytics, title: 'Reports', page: ReportPage()),
    MenuModel(
        icon: Icons.settings, title: 'Settings', page: const SettingsPage()),
    MenuModel(icon: Icons.receipt, title: 'History', page: ReportListPage()),
  ];
}
