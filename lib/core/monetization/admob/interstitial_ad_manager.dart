import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';
import 'ad_events.dart';
import 'ad_frequency_manager.dart';

class InterstitialAdManager {
  static InterstitialAd? _interstitialAd;
  static bool _isLoading = false;

  static bool get isAdAvailable => _interstitialAd != null;

  static void preloadInterstitial() {
    if (!AdConfig.enableInterstitialAds || _isLoading || _interstitialAd != null) {
      return;
    }

    _isLoading = true;
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
          _isLoading = false;
          AdAnalyticsTracker.track(
            type: AdEventType.adLoaded,
            adFormat: 'interstitial',
            placement: 'preload',
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdMob Interstitial] Failed to preload: ${error.message}');
          _interstitialAd = null;
          _isLoading = false;
          AdAnalyticsTracker.track(
            type: AdEventType.adFailed,
            adFormat: 'interstitial',
            placement: 'preload',
            errorMessage: error.message,
          );
        },
      ),
    );
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
    _interstitialAd?.dispose();
    _interstitialAd = null;
    _isLoading = false;
  }
}
