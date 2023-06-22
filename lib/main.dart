import 'package:client/screens/screen.dart';
import 'package:client/themes/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Client App',
        initialRoute: 'home',
        theme: AppTheme.darkTheme,
        routes: {
          'home': (context) => const HomeScreen(),
          'save': (context) => const SaveScreen(),
        });
  }
}
