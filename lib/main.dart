import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'providers/book_provider.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => BookProvider())],
      child: MaterialApp(
        title: 'كتب الدكتور سالم الثقفي',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xFF1E3A8A), // Navy blue
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF1E3A8A),
            foregroundColor: Colors.white,
          ),
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF1E3A8A),
            secondary: Color(0xFF64748B), // Gray
          ),
        ),
        locale: const Locale('ar', ''), // Arabic locale for RTL
        supportedLocales: const [
          Locale('ar', ''), // Arabic
          Locale('en', ''), // English
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: const SplashScreen(),
      ),
    );
  }
}
