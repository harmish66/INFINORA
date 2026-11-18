import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';
import 'ad_events.dart';
import 'ad_frequency_manager.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;
  static DateTime? _loadedTime;
  static int _retryAttempt = 0;
  static Timer? _retryTimer;

  static bool get isAdAvailable {
    if (_interstitialAd == null) return false;
    if (_loadedTime != null &&
        DateTime.now().difference(_loadedTime!).inHours >= 4) {
      debugPrint('[AdMob Interstitial] Cached ad expired. Disposing and reloading.');
      _interstitialAd?.dispose();
      _interstitialAd = null;
      _loadedTime = null;
      preloadInterstitial();
      return false;
    }
    return true;
  }

  static void preloadInterstitial() {
    if (!AdConfig.isAdMobEnabled || !AdConfig.enableInterstitialAds) {
      return;
    }
    if (_isLoading || isAdAvailable) {
      return;
    }

    _isLoading = true;
    _retryTimer?.cancel();

    AdAnalyticsTracker.track(
      type: AdEventType.adRequest,
      adFormat: 'interstitial',
      placement: 'preload',
    );

    InterstitialAd.load(
      adUnitId: AdConfig.interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _loadedTime = DateTime.now();
          _isLoading = false;
          _retryAttempt = 0;
          debugPrint('[AdMob Interstitial] Preload successful and ready.');
          AdAnalyticsTracker.track(
            type: AdEventType.adLoaded,
            adFormat: 'interstitial',
            placement: 'preload',
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdMob Interstitial] Failed to preload: ${error.message}');
          _interstitialAd = null;
          _loadedTime = null;
          _isLoading = false;
          AdAnalyticsTracker.track(
            type: AdEventType.adFailed,
            adFormat: 'interstitial',
            placement: 'preload',
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
      preloadInterstitial();
    });
  }

  static void showInterstitialAd({
    required BuildContext context,
    required String placement,
    required VoidCallback onAdDismissed,
    VoidCallback? onAdFailedToShow,
  }) {
    if (!isAdAvailable) {
      if (onAdFailedToShow != null) {
        onAdFailedToShow();
      } else {
        onAdDismissed();
      }
      preloadInterstitial();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        AdFrequencyManager.recordInterstitialShown();
        AdAnalyticsTracker.track(
          type: AdEventType.interstitialAdShown,
          adFormat: 'interstitial',
          placement: placement,
        );
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onAdDismissed();
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdMob Interstitial] Failed to show: ${error.message}');
        ad.dispose();
        _interstitialAd = null;
        AdAnalyticsTracker.track(
          type: AdEventType.adFailed,
          adFormat: 'interstitial',
          placement: placement,
          errorMessage: error.message,
        );
        if (onAdFailedToShow != null) {
          onAdFailedToShow();
        } else {
          onAdDismissed();
        }
        preloadInterstitial();
      },
      onAdImpression: (ad) {
        AdAnalyticsTracker.track(
          type: AdEventType.adImpression,
          adFormat: 'interstitial',
          placement: placement,
        );
      },
      onAdClicked: (ad) {
        AdAnalyticsTracker.track(
          type: AdEventType.adClicked,
          adFormat: 'interstitial',
          placement: placement,
        );
      },
    );

    _interstitialAd!.show();
  }

  static void showInterstitial({
    required bool isAdFree,
    required String placement,
    required VoidCallback onDismissed,
  }) {
    if (isAdFree || !AdConfig.enableInterstitialAds) {
      onDismissed();
      return;
    }

    if (!AdFrequencyManager.canShowInterstitial()) {
      debugPrint('[AdMob Interstitial] Cooldown or frequency limit active at $placement.');
      onDismissed();
      return;
    }

    if (_interstitialAd == null) {
      debugPrint('[AdMob Interstitial] Ad not ready yet at $placement.');
      onDismissed();
      preloadInterstitial();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        AdFrequencyManager.recordInterstitialShown();
        AdAnalyticsTracker.track(
          type: AdEventType.interstitialAdShown,
          adFormat: 'interstitial',
          placement: placement,
        );
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onDismissed();
        preloadInterstitial();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdMob Interstitial] Failed to show: ${error.message}');
        ad.dispose();
        _interstitialAd = null;
        AdAnalyticsTracker.track(
          type: AdEventType.adFailed,
          adFormat: 'interstitial',
          placement: placement,
          errorMessage: error.message,
        );
        onDismissed();
        preloadInterstitial();
      },
      onAdImpression: (ad) {
        AdAnalyticsTracker.track(
          type: AdEventType.adImpression,
          adFormat: 'interstitial',
          placement: placement,
        );
      },
      onAdClicked: (ad) {
        AdAnalyticsTracker.track(
          type: AdEventType.adClicked,
          adFormat: 'interstitial',
          placement: placement,
        );
      },
    );

    _interstitialAd!.show();
  }

  static void dispose() {
    _retryTimer?.cancel();
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _loadedTime = null;
    _isLoading = false;
    _retryAttempt = 0;
  }
}
