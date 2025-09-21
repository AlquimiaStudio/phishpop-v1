import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'providers/providers.dart';
import 'screens/screens.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

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
        ChangeNotifierProvider(create: (context) => TextProvider()),
        ChangeNotifierProvider(create: (context) => UrlProvider()),
        ChangeNotifierProvider(create: (context) => QrUrlProvider()),
        ChangeNotifierProvider(create: (context) => AuthProvider()),
        ChangeNotifierProvider(create: (context) => EmailInputProvider()),
        ChangeNotifierProvider(create: (context) => QrProvider()),
      ],
      child: MaterialApp(
        title: 'Phishing App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        home: const LoadingScreen(
          icon: Icons.security,
          title: 'Phishing App',
          subtitle: 'Protecting you from phishing attempts',
          screen: AuthScreen(),
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
              const QrWifiSummaryScreen(qrContent: ''),
        },
      ),
    );
  }
}
