import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:energy_app/pages/ThemeProvider.dart';
import '../widgets/menu.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    setState(() {
      appVersion = '1.0.0'; // Example version
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: themeProvider.isDarkMode
          ? const Color.fromARGB(255, 21, 17, 37)
          : Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: themeProvider.isDarkMode
            ? const Color.fromARGB(255, 21, 17, 37)
            : Colors.white,
        foregroundColor: themeProvider.isDarkMode ? Colors.white : Colors.black,
        leading: IconButton(
          icon: Icon(
            Icons.menu,
            color: themeProvider.isDarkMode ? Colors.white : Colors.black,
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
                title: themeProvider.isDarkMode ? 'Dark Mode' : 'Light Mode',
                value: themeProvider.isDarkMode,
                onChanged: themeProvider.toggleTheme,
              ),
              const SizedBox(height: 20),
              _buildSwitchTile(
                title: 'Push Notifications',
                value: isPushNotificationEnabled,
                onChanged: (value) => setState(() {
                  isPushNotificationEnabled = value;
                }),
              ),
              const SizedBox(height: 20),
              _buildSwitchTile(
                title: 'Notification Sound',
                value: isSoundEnabled,
                onChanged: (value) => setState(() {
                  isSoundEnabled = value;
                }),
              ),
              const SizedBox(height: 20),
              _buildSwitchTile(
                title: 'Notification Vibration',
                value: isVibrationEnabled,
                onChanged: (value) => setState(() {
                  isVibrationEnabled = value;
                }),
              ),
              const SizedBox(height: 20),
              _buildAboutSection(themeProvider.isDarkMode),
              const SizedBox(height: 20),
              _buildAppVersion(themeProvider.isDarkMode),
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
            color: Provider.of<ThemeProvider>(context).isDarkMode
                ? Colors.white
                : Colors.black,
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

  Widget _buildAboutSection(bool isDarkMode) {
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

  Widget _buildAppVersion(bool isDarkMode) {
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
