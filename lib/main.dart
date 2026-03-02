import 'package:flutter/material.dart';
import 'package:oneradar/wrapper.dart';
import 'package:provider/provider.dart';
import 'theme/theme_provider.dart';
import 'pages/onboarding_page.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final tp = context.watch<ThemeProvider>();
    return MaterialApp(
      title: 'My App',
      debugShowCheckedModeBanner: false,
      theme: tp.lightTheme,
      darkTheme: tp.darkTheme,
      themeMode: tp.themeMode,
      home: const Wrapper(),
      
    );
  }
}
