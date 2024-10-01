import 'dart:developer';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:posterify/constants/constants.dart';

class ScreenSettings extends StatefulWidget {
  const ScreenSettings({super.key});

  @override
  State<ScreenSettings> createState() => _ScreenSettingsState();
}

class _ScreenSettingsState extends State<ScreenSettings> {
  bool isNotify = false;
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    _loadThemeMode();
  }

  void _loadThemeMode() async {
    final mode = await AdaptiveTheme.getThemeMode();
    setState(() {
      isDarkMode = mode == AdaptiveThemeMode.dark;
    });
  }

  void _setThemeMode(bool isDark) {
    if (isDark) {
      AdaptiveTheme.of(context).setDark();
    } else {
      AdaptiveTheme.of(context).setLight();
    }
    setState(() {
      isDarkMode = isDark;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.arrow_back_ios,
            )),
        title: Text(
          'Settings',
          style: headingBlackStyle,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
            ListTile(
              title: const Text('Notification'),
              trailing: Switch.adaptive(
                trackOutlineColor: WidgetStateColor.transparent,
                activeTrackColor: black,
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
                value: isNotify,
                onChanged: (bool value) {
                  setState(() {
                    isNotify = value;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('Dark Mode'),
              trailing: Switch.adaptive(
                trackOutlineColor: WidgetStateColor.transparent,
                activeTrackColor: black,
                activeColor: Colors.white,
                inactiveThumbColor: Colors.white,
                value: isDarkMode,
                onChanged: (bool isOn) {
                  _setThemeMode(isOn);
                },
              ),
            ),
            const ListTile(
              title: Text('Privacy Policy'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            const ListTile(
              title: Text('Contact Us'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
            ListTile(
              onTap: () {
                final joinDate = DateTime.now();
                var formattedJoinDate =
                    "${joinDate.day}-${joinDate.month}-${joinDate.year}";
                log(formattedJoinDate);
    
                final expiryDate = DateTime(
                    joinDate.year + ((joinDate.month + 6) ~/ 12),
                    (joinDate.month + 6) % 12 == 0
                        ? 12
                        : (joinDate.month + 6) % 12,
                    joinDate.day);
                var formattedExpiryDate =
                    "${expiryDate.day}-${expiryDate.month}-${expiryDate.year}";
                log(formattedExpiryDate);
              },
              title: Text('About Us'),
              trailing: Icon(Icons.arrow_forward_ios_rounded),
            ),
          ],
        ),
      ),
    );
  }
}
