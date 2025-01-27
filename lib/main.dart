import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/provider/report_data_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:energy_app/provider/ThemeProvider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://lofjpbnbmctceszsclzp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxvZmpwYm5ibWN0Y2VzenNjbHpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQwODA5OTUsImV4cCI6MjA0OTY1Njk5NX0.KIXj0gMLkY7wwTkh1iHwRP-k4mvvnvjsHfVChVY7Fbo',
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => ReportDataProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(), // Add ThemeProvider
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness:
            themeProvider.isDarkMode ? Brightness.dark : Brightness.light,
        primaryColor: themeProvider.isDarkMode
            ? const Color.fromARGB(255, 21, 17, 37)
            : Colors.white,
      ),
      home: const HomePage(),
    );
  }
}
