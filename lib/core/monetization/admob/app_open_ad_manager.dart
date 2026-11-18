import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';
import 'ad_events.dart';

class AppOpenAdManager {
  static AppOpenAd? _appOpenAd;
  static bool _isLoading = false;
  static DateTime? _lastShownTime;
  static DateTime? _loadedTime;
  static int _retryAttempt = 0;
  static Timer? _retryTimer;

  static bool get isAdAvailable {
    if (_appOpenAd == null) return false;
    if (_loadedTime != null &&
        DateTime.now().difference(_loadedTime!).inHours >= 4) {
      debugPrint('[AdMob AppOpen] Cached ad expired. Disposing and reloading.');
      _appOpenAd?.dispose();
      _appOpenAd = null;
      _loadedTime = null;
      loadAppOpenAd();
      return false;
    }
    return true;
  }

  static void loadAppOpenAd() {
    if (!AdConfig.isAdMobEnabled || !AdConfig.enableAppOpenAds) {
      return;
    }
    if (_isLoading || isAdAvailable) {
      return;
    }

    _isLoading = true;
    _retryTimer?.cancel();

    AdAnalyticsTracker.track(
      type: AdEventType.adRequest,
      adFormat: 'app_open',
      placement: 'startup',
    );

    AppOpenAd.load(
      adUnitId: AdConfig.appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _loadedTime = DateTime.now();
          _isLoading = false;
          _retryAttempt = 0;
          debugPrint('[AdMob AppOpen] Preload successful and ready.');
          AdAnalyticsTracker.track(
            type: AdEventType.adLoaded,
            adFormat: 'app_open',
            placement: 'startup',
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdMob AppOpen] Failed to load: ${error.message}');
          _appOpenAd = null;
          _loadedTime = null;
          _isLoading = false;
          AdAnalyticsTracker.track(
            type: AdEventType.adFailed,
            adFormat: 'app_open',
            placement: 'startup',
            errorMessage: error.message,
          );
          _scheduleRetry();
        },
      ),
    );
  }

  static void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryAttempt++;
    final delaySeconds = math.min(math.pow(2, _retryAttempt).toInt() * 2, 60);
    _retryTimer = Timer(Duration(seconds: delaySeconds), () {
      loadAppOpenAd();
    });
  }

  static void showAppOpenAdIfAvailable({
    required bool isAdFree,
    required bool isEditingActiveProject,
  }) {
    if (isAdFree || !AdConfig.enableAppOpenAds || isEditingActiveProject) {
      return;
    }

    if (_lastShownTime != null) {
      final hoursSinceLast = DateTime.now().difference(_lastShownTime!).inHours;
      if (hoursSinceLast < 4) {
        return; // Respect 4-hour session gap
      }
    }

    if (!isAdAvailable) {
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _lastShownTime = DateTime.now();
        AdAnalyticsTracker.track(
          type: AdEventType.adImpression,
          adFormat: 'app_open',
          placement: 'resume',
        );
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _appOpenAd = null;
        _loadedTime = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdMob AppOpen] Failed to show: ${error.message}');
        ad.dispose();
        _appOpenAd = null;
        _loadedTime = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }

  static void dispose() {
    _retryTimer?.cancel();
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _loadedTime = null;
    _isLoading = false;
    _retryAttempt = 0;
  }
}
