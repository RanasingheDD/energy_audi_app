import 'package:energy_app/pages/home_page.dart';
import 'package:energy_app/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class _SettingsPageState extends State<SettingsPage> {
  bool isDarkMode = true;
  bool isPushNotificationEnabled = true;
  bool isSoundEnabled = true;
  bool isVibrationEnabled = true;
  String appVersion = '';

  @override
  void initState() {
    super.initState();
    _getAppVersion();
  }

  // Method to fetch app version using package_info
  void _getAppVersion() async {
  //  PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
  //    appVersion = packageInfo.version; // Set the app version
    });
  }

  // Toggle dark/light mode
  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    // Save theme preference here (SharedPreferences, Provider, etc.)
  }

  // Toggle push notification
  void _togglePushNotification(bool value) {
    setState(() {
      isPushNotificationEnabled = value;
    });
    // Handle enabling/disabling push notifications here
  }

  // Toggle notification sound
  void _toggleSound(bool value) {
    setState(() {
      isSoundEnabled = value;
    });
    // Handle sound preference here
  }

  // Toggle vibration
  void _toggleVibration(bool value) {
    setState(() {
      isVibrationEnabled = value;
    });
    // Handle vibration preference here
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: isDarkMode
          ? ThemeData.dark().copyWith(
              scaffoldBackgroundColor: const Color.fromARGB(255, 21, 17, 37),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color.fromARGB(255, 21, 17, 37),
              ),
            )
          : ThemeData.light().copyWith(
              scaffoldBackgroundColor: Colors.white,
              appBarTheme: const AppBarTheme(
                  backgroundColor: Colors.white,
                  titleTextStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
            ),
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: TextStyle(
              color: isDarkMode ? Colors.white : Colors.black,
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor:
              isDarkMode ? const Color.fromARGB(255, 21, 17, 37) : Colors.white,
          centerTitle: true,
          leading: IconButton(
            icon: Icon(
              Icons.menu,
              color: isDarkMode ? Colors.white : Colors.black,
              size: 25,
            ),
            onPressed: () =>
              Scaffold.of(context).openDrawer(),
          ),
        ),
         drawer: SideMenuWidget(currentIndex: 2,),
         body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Dark/Light Theme Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Switch(
                    value: isDarkMode,
                    onChanged: _toggleTheme,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Push Notification Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Push Notifications',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Switch(
                    value: isPushNotificationEnabled,
                    onChanged: _togglePushNotification,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Sound Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notification Sound',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Switch(
                    value: isSoundEnabled,
                    onChanged: _toggleSound,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Vibration Toggle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Notification Vibration',
                    style: TextStyle(
                      color: isDarkMode ? Colors.white : Colors.black,
                      fontSize: 16,
                    ),
                  ),
                  Switch(
                    value: isVibrationEnabled,
                    onChanged: _toggleVibration,
                    activeColor: Colors.white,
                    activeTrackColor: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // About Us Section
              Text(
                'About Us',
                style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Text(
                'We are a team passionate about creating amazing apps for our users.',
                style: TextStyle(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 20),

              // App Version
              Row(
                children: [
                  Text(
                    'App Version: ',
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16),
                  ),
                  Text(
                    appVersion.isEmpty ? 'Loading...' : appVersion,
                    style: TextStyle(
                        color: isDarkMode ? Colors.white : Colors.black,
                        fontSize: 16),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
