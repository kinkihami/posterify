import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:phone_email_auth/phone_email_auth.dart';
import 'package:posterify/provider/logged.dart';
import 'package:posterify/view%20model/common_view_model.dart';
import 'package:posterify/view/Nav_pages/bottomnavigationbar.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  PhoneEmail.initializeApp(clientId: '14296691169630841257');
  final savedThemeMode = await AdaptiveTheme.getThemeMode();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_)=>CommonViewModel()),
      ChangeNotifierProvider(create: (_)=>Logged()),
      ChangeNotifierProvider(create: (_)=>Expiry())
    ],
    child: MyApp(savedThemeMode: savedThemeMode),
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.savedThemeMode});

  final AdaptiveThemeMode? savedThemeMode;

  @override
  Widget build(BuildContext context) {
    return AdaptiveTheme(
      light: ThemeData.light(),
      dark: ThemeData.dark(),
      initial: savedThemeMode ?? AdaptiveThemeMode.light,
      builder: (theme, darkTheme) {
        final isDarkMode = theme.brightness == Brightness.dark;

        SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: !isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : ThemeData.dark().scaffoldBackgroundColor,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          systemNavigationBarColor: !isDarkMode
              ? Theme.of(context).scaffoldBackgroundColor
              : ThemeData.dark().scaffoldBackgroundColor,
          systemNavigationBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
        ));

        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Adaptive Theme Demo',
          theme: theme,
          darkTheme: darkTheme,
          home: const Bottomnavigationbar(),
        );
      },
    );
  }
  
}

