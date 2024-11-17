import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/pages/settings_page.dart';
import 'package:energy_app/provider/report_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create:(context)=> ReportDataProvider(),
      child: const MyApp(),
    ),
  ); // Call MyApp constructor to create an instance
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
    
  }
}
