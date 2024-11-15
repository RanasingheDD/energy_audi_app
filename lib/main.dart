import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/pages/report_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp()); // Call MyApp constructor to create an instance
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(body: ReportPage()),
    );
  }
}
