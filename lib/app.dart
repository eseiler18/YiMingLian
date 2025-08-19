import 'package:flutter/material.dart';
import 'screens/menu_screen.dart';
import 'screens/fast_mode_screen.dart';
import 'screens/choice_character_mode_screen.dart';
import 'screens/choice_pinyin_mode_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Apprentissage Chinois',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Color(0xFF141A22)), // texte global
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            foregroundColor: const Color(0xFF141A22),      // texte des boutons
            backgroundColor: const Color(0xAEEE2449),      // fond des boutons
          ),
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/fast': (context) => const FastModeScreen(),
        '/choiceCharacter': (context) => const ChoiceModeCharacter(),
        '/choicePinyin': (context) => const ChoiceModePinyin(),
      },
    );
  }
}
