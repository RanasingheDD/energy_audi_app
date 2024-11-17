import 'package:energy_app/widgets/menu.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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

  void _getAppVersion() async {
    // Simulating fetching the app version
    setState(() {
      appVersion = '1.0.0'; // Example version
    });
  }

  void _toggleTheme(bool value) {
    setState(() {
      isDarkMode = value;
    });
    // Save the theme preference using a state management solution or SharedPreferences
  }

  void _togglePushNotification(bool value) {
    setState(() {
      isPushNotificationEnabled = value;
    });
  }

  void _toggleSound(bool value) {
    setState(() {
      isSoundEnabled = value;
    });
  }

  void _toggleVibration(bool value) {
    setState(() {
      isVibrationEnabled = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 21, 17, 37)
            : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: isDarkMode
            ? const Color.fromARGB(255, 21, 17, 37)
            : Colors.white,
        foregroundColor: isDarkMode ? Colors.white : Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: isDarkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: Drawer(
        child: SideMenuWidget(
          currentIndex: 2, 
          onMenuSelect: (index) {
          
            print('Selected menu index: $index');
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSwitchTile(
                title: isDarkMode ? 'Dark Mode' : "Light Mode",
                value: isDarkMode,
                onChanged: _toggleTheme,
              ),
              const SizedBox(height: 20),
              _buildSwitchTile(
                title: 'Push Notifications',
                value: isPushNotificationEnabled,
                onChanged: _togglePushNotification,
              ),
              const SizedBox(height: 20),
              _buildSwitchTile(
                title: 'Notification Sound',
                value: isSoundEnabled,
                onChanged: _toggleSound,
              ),
              const SizedBox(height: 20),
              _buildSwitchTile(
                title: 'Notification Vibration',
                value: isVibrationEnabled,
                onChanged: _toggleVibration,
              ),
              const SizedBox(height: 20),
              _buildAboutSection(),
              const SizedBox(height: 20),
              _buildAppVersion(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        Switch(
          value: value,
          onChanged: onChanged,
          activeColor: Colors.white,
          activeTrackColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildAboutSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About Us',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'We are a team passionate about creating amazing apps for our users.',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildAppVersion() {
    return Row(
      children: [
        Text(
          'App Version: ',
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
        Text(
          appVersion.isEmpty ? 'Loading...' : appVersion,
          style: TextStyle(
            color: isDarkMode ? Colors.white : Colors.black,
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
