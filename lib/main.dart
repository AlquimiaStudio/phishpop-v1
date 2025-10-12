import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import 'providers/providers.dart';
import 'screens/screens.dart';
import 'theme/theme.dart';
import 'services/services.dart';
import 'widgets/widgets.dart';

void main() async {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await dotenv.load(fileName: ".env");
      await Firebase.initializeApp();

      FlutterError.onError =
          FirebaseCrashlytics.instance.recordFlutterFatalError;

      PlatformDispatcher.instance.onError = (error, stack) {
        FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
        return true;
      };

      await RevenueCatService().initialize();

      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);

      runApp(const PhishingApp());
    },
    (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    },
  );
}

class PhishingApp extends StatelessWidget {
  const PhishingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => AppAuthProvider()),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => QrProvider()),
        ChangeNotifierProvider(create: (context) => QrUrlProvider()),
        ChangeNotifierProvider(create: (context) => QrWifiProvider()),
        ChangeNotifierProvider(create: (context) => SharedContentProvider()),
        ChangeNotifierProvider(create: (context) => StatsProvider()),
        ChangeNotifierProvider(create: (context) => TextProvider()),
        ChangeNotifierProvider(create: (context) => UrlProvider()),
      ],
      child: const PhishingAppContent(),
    );
  }
}

class PhishingAppContent extends StatefulWidget {
  const PhishingAppContent({super.key});

  @override
  State<PhishingAppContent> createState() => PhishingAppContentState();
}

class PhishingAppContentState extends State<PhishingAppContent> {
  StreamSubscription? intentTextStreamSubscription;

  @override
  void initState() {
    super.initState();
    initShareHandler();
  }

  @override
  void dispose() {
    intentTextStreamSubscription?.cancel();
    super.dispose();
  }

  void initShareHandler() async {
    final sharedContentProvider = Provider.of<SharedContentProvider>(
      context,
      listen: false,
    );

    intentTextStreamSubscription = ReceiveSharingIntent.instance
        .getMediaStream()
        .listen(
          (List<SharedMediaFile> value) {
            if (value.isNotEmpty) {
              final media = value.first;

              final sharedText =
                  media.type == SharedMediaType.text ||
                      media.type == SharedMediaType.url
                  ? media.path
                  : (media.message ?? media.path);
              if (sharedText.isNotEmpty) {
                sharedContentProvider.setSharedContent(sharedText);
              }
            }
          },
          onError: (err) {
            if (mounted) {
              GlobalSnackBar.showError(
                context,
                'Error receiving shared content',
              );
            }
          },
        );

    ReceiveSharingIntent.instance.getInitialMedia().then((
      List<SharedMediaFile> value,
    ) {
      if (value.isNotEmpty) {
        final media = value.first;

        final sharedText =
            media.type == SharedMediaType.text ||
                media.type == SharedMediaType.url
            ? media.path
            : (media.message ?? media.path);
        if (sharedText.isNotEmpty) {
          sharedContentProvider.setSharedContent(sharedText);
          ReceiveSharingIntent.instance.reset();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Phishing App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
      routes: {
        '/history': (context) => const HistoryScreen(),
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
        '/onboarding-2': (context) => const OnboardingScreen2(),
        '/onboarding-1': (context) => const OnboardingScreen1(),
      },
    );
  }
}
