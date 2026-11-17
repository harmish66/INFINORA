import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../subscriptions/subscription_service.dart';
import 'ad_config.dart';
import 'ad_events.dart';
import 'ad_frequency_manager.dart';
import 'interstitial_ad_manager.dart';

class NavigationAdController {
  static int _browsingInteractionsCount = 0;
  static const int minInteractionsBeforeAd = 3;
  static bool _isCreativeWorkflowActive = false;

  /// Mark when user enters or exits drawing/canvas/editing/import/export/recovery
  static void setCreativeWorkflowActive(bool active) {
    _isCreativeWorkflowActive = active;
  }

  static bool get isCreativeWorkflowActive => _isCreativeWorkflowActive;

  /// Call whenever a meaningful browsing action occurs (filtering, searching, switching tabs)
  static void recordBrowsingInteraction() {
    _browsingInteractionsCount++;
  }

  /// Allowed discovery & browsing destination routes
  static const Set<String> _allowedDiscoveryRoutes = {
    '/home',
    '/templates',
    '/projects',
  };

  /// Disallowed routes where interstitial ads must NEVER interrupt
  static const Set<String> _restrictedCreativeRoutes = {
    '/canvas',
    '/onboarding',
    '/splash',
    '/settings',
    '/premium',
    '/export',
  };

  /// Check whether navigation to the destination route is eligible for an interstitial ad
  static bool isEligibleForNavigationAd({
    required String destinationRoute,
    required bool isAdFree,
  }) {
    // 1. Pro subscribers never see ads
    if (isAdFree) return false;

    // 2. Global and placement toggles
    if (!AdConfig.isAdMobEnabled || !AdConfig.enableNavigationInterstitialAd) {
      return false;
    }

    // 3. Must not be inside an active creative workflow
    if (_isCreativeWorkflowActive) return false;

    // 4. Check route restrictions
    if (_restrictedCreativeRoutes.contains(destinationRoute)) return false;
    if (!_allowedDiscoveryRoutes.contains(destinationRoute)) return false;

    // 5. Must have completed minimum browsing interactions
    if (_browsingInteractionsCount < minInteractionsBeforeAd) return false;

    // 6. Strict frequency capping (5-min minimum, max 5 daily, 60s full-screen cooldown)
    if (!AdFrequencyManager.canShowInterstitial()) return false;

    // 7. Check if ad is preloaded and ready
    return InterstitialAdManager.isAdAvailable;
  }

  /// Execute navigation with zero-delay fallback
  static void handleNavigationWithAd({
    required BuildContext context,
    required String destinationRoute,
    required VoidCallback onNavigate,
    required WidgetRef ref,
  }) {
    final isAdFree = ref.read(isAdFreeUserProvider);

    if (!isEligibleForNavigationAd(
      destinationRoute: destinationRoute,
      isAdFree: isAdFree,
    )) {
      // Immediate navigation with zero delay
      onNavigate();
      return;
    }

    // Reset interaction counter once eligible
    _browsingInteractionsCount = 0;

    AdAnalyticsTracker.track(
      type: AdEventType.adRequest,
      adFormat: 'interstitial',
      placement: 'navigation_$destinationRoute',
    );

    InterstitialAdManager.showInterstitialAd(
      context: context,
      placement: 'navigation_$destinationRoute',
      onAdDismissed: () {
        onNavigate();
      },
      onAdFailedToShow: () {
        // Immediate fallback
        onNavigate();
      },
    );
  }
}
