// lib/main.dart

import 'package:flutter/material.dart';
import 'global_state.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const BoursePremiumApp());
}

class BoursePremiumApp extends StatefulWidget {
  const BoursePremiumApp({super.key});

  // مێسۆدێک بۆ نوێکردنەوەی فۆنت لە سەرانسەری ئەپەکەدا بە شێوەیەکی خێرا
  static void rebuild(BuildContext context) {
    _BoursePremiumAppState? state = context.findAncestorStateOfType<_BoursePremiumAppState>();
    state?.rebuild();
  }

  @override
  State<BoursePremiumApp> createState() => _BoursePremiumAppState();
}

class _BoursePremiumAppState extends State<BoursePremiumApp> {
  void rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'بۆرسەی عێراق پێشکەوتوو',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF0B121F),
        primaryColor: const Color(0xFF131C2E),
      ),
      builder: (context, child) {
        // گۆڕینی قەبارەی سەرجەم تێکستەکان لە جیهاندا بەگوێرەی هەڵبژاردەی کڕیار
        return MediaQuery(
        
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.linear(fontScaleMultiplierGlobal),
          ),
          child: child!,
        );
      },
      home: const MainNavigationScreen(),
    );
  }
}