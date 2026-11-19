import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'core/monetization/admob/ad_frequency_manager.dart';
import 'core/monetization/admob/ad_preload_manager.dart';
import 'core/monetization/admob/admob_service.dart';
import 'core/monetization/remote_config/firebase_remote_config_service.dart';
import 'core/providers/app_providers.dart';
import 'core/routing/app_router.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();

  // Initialize Firebase Remote Config for live ads keys & toggles
  await FirebaseRemoteConfigService.initialize();

  // Initialize monetization frequency manager & AdMob SDK
  AdFrequencyManager.initialize(prefs);
  await AdmobService.initialize();
  AdPreloadManager.initialize();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
      child: const InfinoraApp(),
    ),
  );
}

class InfinoraApp extends ConsumerWidget {
  const InfinoraApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'Infinora - Infinite Canvas',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeMode,
      locale: locale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      routerConfig: appRouter,
    );
  }
}
