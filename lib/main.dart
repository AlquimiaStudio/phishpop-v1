import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

import 'providers/providers.dart';
import 'screens/screens.dart';
import 'screens/main/splash_screen.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(const PhishingApp());
}

class PhishingApp extends StatelessWidget {
  const PhishingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => QrProvider()),
        ChangeNotifierProvider(create: (context) => QrUrlProvider()),
        ChangeNotifierProvider(create: (context) => QrWifiProvider()),
        ChangeNotifierProvider(create: (context) => StatsProvider()),
        ChangeNotifierProvider(create: (context) => TextProvider()),
        ChangeNotifierProvider(create: (context) => UrlProvider()),
      ],
      child: MaterialApp(
        title: 'Phishing App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: Consumer<AuthProvider>(
          builder: (context, authProvider, child) {
            if (authProvider.isLoading) {
              return const SplashScreen();
            }

            if (authProvider.isAuthenticated) {
              return const HomeScreen(initialIndex: 0);
            } else {
              return const AuthScreen();
            }
          },
        ),
        routes: {
          '/history': (context) => const HistoryScreen(),
          '/home': (context) => const HomeScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/stats': (context) => const StatsScreen(),
          '/auth': (context) => const AuthScreen(),
          '/text-summary': (context) =>
              const TextSummaryScreen(textToAnalyze: ''),
          '/url-summary': (context) => const UrlSummaryScreen(urlToAnalyze: ''),
          '/qr-url-summary': (context) =>
              const QrUrlSummaryScreen(urlToAnalyze: ''),
          '/qr-wifi-summary': (context) =>
              const QrWifiSummaryScreen(wifiContent: ''),
        },
      ),
    );
  }
}
