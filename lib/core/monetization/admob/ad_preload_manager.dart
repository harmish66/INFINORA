import 'package:flutter/material.dart';
import 'ad_config.dart';
import 'app_open_ad_manager.dart';
import 'banner_ad_manager.dart';
import 'interstitial_ad_manager.dart';
import 'native_ad_manager.dart';
import 'navigation_ad_controller.dart';
import 'rewarded_ad_manager.dart';

/// Centralized Orchestrator for Preloading All Ad Formats Across the Entire Application
class AdPreloadManager {
  static AppLifecycleListener? _lifecycleListener;
  static bool _isInitialized = false;

  /// Warm up and preload all eligible ad formats across the entire application
  static void preloadAll({bool isAdFree = false}) {
    if (isAdFree || !AdConfig.isAdMobEnabled) {
      disposeAll();
      return;
    }

    // 1. Full-screen ads
    InterstitialAdManager.preloadInterstitial();
    RewardedAdManager.preloadRewardedAd();
    AppOpenAdManager.loadAppOpenAd();

    // 2. Feed and content pools
    NativeAdPreloadPool.preloadSmall();
    BannerAdPreloadPool.preloadBanner();

    debugPrint('[AdPreloadManager] All ad format preloads initiated across application.');
  }

  /// Initialize lifecycle monitoring to manage AppOpen ad display and app pause/resume
  static void initialize({bool isAdFree = false}) {
    if (_isInitialized) return;
    _isInitialized = true;

    preloadAll(isAdFree: isAdFree);

    _lifecycleListener = AppLifecycleListener(
      onResume: () {
        debugPrint('[AdPreloadManager] App resumed. Checking AppOpen ad availability.');
        AppOpenAdManager.showAppOpenAdIfAvailable(
          isAdFree: isAdFree,
          isEditingActiveProject: NavigationAdController.isCreativeWorkflowActive,
        );
        // Refresh any expired or consumed ads
        preloadAll(isAdFree: isAdFree);
      },
    );
  }

  /// Clean up all ad pools, cancel all retry timers, and dispose lifecycle listeners
  static void disposeAll() {
    _lifecycleListener?.dispose();
    _lifecycleListener = null;
    _isInitialized = false;
    InterstitialAdManager.dispose();
    RewardedAdManager.dispose();
    AppOpenAdManager.dispose();
    NativeAdPreloadPool.disposeAll();
    BannerAdPreloadPool.disposeAll();
  }
}
