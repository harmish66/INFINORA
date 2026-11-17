import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';
import 'ad_events.dart';

class AppOpenAdManager {
  static AppOpenAd? _appOpenAd;
  static bool _isLoading = false;
  static DateTime? _lastShownTime;

  static void loadAppOpenAd() {
    if (!AdConfig.enableAppOpenAds || _isLoading || _appOpenAd != null) {
      return;
    }

    _isLoading = true;
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
          _isLoading = false;
          AdAnalyticsTracker.track(
            type: AdEventType.adLoaded,
            adFormat: 'app_open',
            placement: 'startup',
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdMob AppOpen] Failed to load: ${error.message}');
          _appOpenAd = null;
          _isLoading = false;
          AdAnalyticsTracker.track(
            type: AdEventType.adFailed,
            adFormat: 'app_open',
            placement: 'startup',
            errorMessage: error.message,
          );
        },
      ),
    );
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

    if (_appOpenAd == null) {
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
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdMob AppOpen] Failed to show: ${error.message}');
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }
}
