import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/foundation.dart';
import '../admob/ad_config.dart';

class FirebaseRemoteConfigService {
  static FirebaseRemoteConfig? _remoteConfig;
  static StreamSubscription<RemoteConfigUpdate>? _subscription;
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  /// Initialize Firebase and Firebase Remote Config safely with offline fallback
  static Future<void> initialize() async {
    try {
      // 1. Initialize Firebase Core
      await Firebase.initializeApp();

      // 2. Obtain Remote Config instance
      final remoteConfig = FirebaseRemoteConfig.instance;
      _remoteConfig = remoteConfig;

      // 3. Set Settings: Fast polling in debug, conservative interval in release
      await remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: kDebugMode ? Duration.zero : const Duration(hours: 1),
        ),
      );

      // 4. Set Defaults from AdConfig
      final defaults = AdConfig.getDefaultRemoteConfigValues();
      await remoteConfig.setDefaults(defaults);

      // 5. Fetch and Activate latest configuration from Firebase
      final updated = await remoteConfig.fetchAndActivate();
      debugPrint('[Firebase Remote Config] Initial fetch success (updated: $updated)');

      // 6. Apply values to in-memory AdConfig
      _applyCurrentConfig();

      // 7. Listen for real-time Remote Config updates
      _subscription?.cancel();
      _subscription = remoteConfig.onConfigUpdated.listen(
        (event) async {
          debugPrint('[Firebase Remote Config] Real-time update received: ${event.updatedKeys}');
          await remoteConfig.activate();
          _applyCurrentConfig();
        },
        onError: (err) {
          debugPrint('[Firebase Remote Config] Real-time stream error: $err');
        },
      );

      _isInitialized = true;
    } catch (e) {
      debugPrint('[Firebase Remote Config] Notice: Firebase initialization bypassed ($e). Using local AdConfig defaults.');
      // Graceful fallback: local AdConfig defaults remain active
    }
  }

  /// Read active keys from Remote Config and update AdConfig
  static void _applyCurrentConfig() {
    final remoteConfig = _remoteConfig;
    if (remoteConfig == null) return;

    final Map<String, dynamic> values = {
      // Master Ad Control
      'is_admob_enabled': remoteConfig.getBool('is_admob_enabled'),
      'is_test_mode': remoteConfig.getBool('is_test_mode'),

      // Live Production Ad Unit IDs
      'android_banner_prod_id': remoteConfig.getString('android_banner_prod_id'),
      'ios_banner_prod_id': remoteConfig.getString('ios_banner_prod_id'),
      'android_interstitial_prod_id': remoteConfig.getString('android_interstitial_prod_id'),
      'ios_interstitial_prod_id': remoteConfig.getString('ios_interstitial_prod_id'),
      'android_rewarded_prod_id': remoteConfig.getString('android_rewarded_prod_id'),
      'ios_rewarded_prod_id': remoteConfig.getString('ios_rewarded_prod_id'),
      'android_native_prod_id': remoteConfig.getString('android_native_prod_id'),
      'ios_native_prod_id': remoteConfig.getString('ios_native_prod_id'),
      'android_app_open_prod_id': remoteConfig.getString('android_app_open_prod_id'),
      'ios_app_open_prod_id': remoteConfig.getString('ios_app_open_prod_id'),

      // Placement Toggles
      'enable_language_native_ad': remoteConfig.getBool('enable_language_native_ad'),
      'enable_home_banner_ad': remoteConfig.getBool('enable_home_banner_ad'),
      'enable_home_native_ad': remoteConfig.getBool('enable_home_native_ad'),
      'enable_template_native_ad': remoteConfig.getBool('enable_template_native_ad'),
      'enable_template_details_native_ad': remoteConfig.getBool('enable_template_details_native_ad'),
      'enable_project_native_ad': remoteConfig.getBool('enable_project_native_ad'),
      'enable_navigation_interstitial_ad': remoteConfig.getBool('enable_navigation_interstitial_ad'),
      'enable_rewarded_ads': remoteConfig.getBool('enable_rewarded_ads'),
      'enable_app_open_ads': remoteConfig.getBool('enable_app_open_ads'),
    };

    AdConfig.applyRemoteConfigOverrides(values);
    debugPrint('[Firebase Remote Config] AdConfig synchronized: isAdMobEnabled=${AdConfig.isAdMobEnabled}, isTestMode=${AdConfig.isTestMode}');
  }

  /// Manually force a fetch and activate
  static Future<bool> forceFetch() async {
    final remoteConfig = _remoteConfig;
    if (remoteConfig == null) return false;
    try {
      final updated = await remoteConfig.fetchAndActivate();
      _applyCurrentConfig();
      return updated;
    } catch (e) {
      debugPrint('[Firebase Remote Config] Force fetch error: $e');
      return false;
    }
  }

  /// Dispose listeners
  static void dispose() {
    _subscription?.cancel();
    _subscription = null;
  }
}
