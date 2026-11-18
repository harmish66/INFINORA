import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:infinora/core/monetization/admob/ad_config.dart';
import 'package:infinora/core/monetization/admob/ad_events.dart';
import 'package:infinora/core/monetization/admob/ad_frequency_manager.dart';
import 'package:infinora/core/monetization/admob/ad_preload_manager.dart';
import 'package:infinora/core/monetization/admob/banner_ad_manager.dart';
import 'package:infinora/core/monetization/admob/native_ad_manager.dart';
import 'package:infinora/core/monetization/admob/navigation_ad_controller.dart';
import 'package:infinora/core/monetization/subscriptions/premium_entitlement.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Monetization AdConfig Tests', () {
    test('Default test ad unit IDs are configured and non-empty', () {
      expect(AdConfig.bannerAdUnitId, isNotEmpty);
      expect(AdConfig.interstitialAdUnitId, isNotEmpty);
      expect(AdConfig.rewardedAdUnitId, isNotEmpty);
      expect(AdConfig.nativeAdUnitId, isNotEmpty);
      expect(AdConfig.appOpenAdUnitId, isNotEmpty);
    });

    test('Ad formats are toggled appropriately', () {
      expect(AdConfig.isAdMobEnabled, isTrue);
      expect(AdConfig.enableBannerAds, isTrue);
      expect(AdConfig.enableNativeAds, isTrue);
      expect(AdConfig.enableRewardedAds, isTrue);
      expect(AdConfig.enableInterstitialAds, isTrue);
    });
  });

  group('AdFrequencyManager Tests', () {
    late SharedPreferences prefs;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      AdFrequencyManager.initialize(prefs);
    });

    test('Initially allows first interstitial ad display', () {
      expect(AdFrequencyManager.canShowInterstitial(), isTrue);
    });

    test('Records interstitial show and blocks rapid subsequent calls within cooldown', () {
      expect(AdFrequencyManager.canShowInterstitial(), isTrue);
      AdFrequencyManager.recordInterstitialShown();

      // Immediately checking again must return false due to minimum 5-minute interval
      expect(AdFrequencyManager.canShowInterstitial(), isFalse);
    });

    test('Enforces maximum daily interstitial limit', () {
      for (int i = 0; i < AdFrequencyManager.maxDailyInterstitials; i++) {
        AdFrequencyManager.recordInterstitialShown();
      }
      expect(AdFrequencyManager.canShowInterstitial(), isFalse);
    });
  });

  group('PremiumEntitlement Tests', () {
    test('Default entitlement is free and isValid is false', () {
      const free = PremiumEntitlement();
      expect(free.isValid, isFalse);
      expect(free.status, 'free');
    });

    test('Active entitlement is valid until expired', () {
      final active = PremiumEntitlement(
        isPremium: true,
        planId: 'pro_annual',
        status: 'active',
        expiryDate: DateTime.now().add(const Duration(days: 30)),
      );
      expect(active.isValid, isTrue);

      final expired = PremiumEntitlement(
        isPremium: true,
        planId: 'pro_monthly',
        status: 'expired',
        expiryDate: DateTime.now().subtract(const Duration(days: 1)),
      );
      expect(expired.isValid, isFalse);
    });

    test('Lifetime premium has null expiry and isValid is true', () {
      const lifetime = PremiumEntitlement(
        isPremium: true,
        planId: 'pro_lifetime',
        status: 'active',
      );
      expect(lifetime.isValid, isTrue);
    });
  });

  group('AdAnalyticsTracker Tests', () {
    test('Logs ad events and retrieves recent events', () {
      AdAnalyticsTracker.track(
        type: AdEventType.adRequest,
        adFormat: 'banner',
        placement: 'home_bottom',
      );
      AdAnalyticsTracker.track(
        type: AdEventType.adImpression,
        adFormat: 'banner',
        placement: 'home_bottom',
      );

      final recent = AdAnalyticsTracker.getRecentEvents(5);
      expect(recent, isNotEmpty);
      expect(AdAnalyticsTracker.requestCount, greaterThanOrEqualTo(1));
      expect(AdAnalyticsTracker.impressionCount, greaterThanOrEqualTo(1));
    });
  });

  group('AdPreloadManager & Ad Pools Tests', () {
    test('AdPreloadManager disposeAll clears pools without throwing', () {
      AdPreloadManager.disposeAll();
      expect(NativeAdPreloadPool.hasSmallAd, isFalse);
      expect(BannerAdPreloadPool.isAvailable, isFalse);
    });

    test('PreloadAll with isAdFree true clears any active cached ads', () {
      AdPreloadManager.preloadAll(isAdFree: true);
      expect(NativeAdPreloadPool.hasSmallAd, isFalse);
      expect(BannerAdPreloadPool.isAvailable, isFalse);
    });

    test('Creative workflow state blocks navigation interstitial ads', () {
      NavigationAdController.setCreativeWorkflowActive(true);
      expect(NavigationAdController.isCreativeWorkflowActive, isTrue);

      final eligible = NavigationAdController.isEligibleForNavigationAd(
        destinationRoute: '/home',
        isAdFree: false,
      );
      expect(eligible, isFalse);

      NavigationAdController.setCreativeWorkflowActive(false);
      expect(NavigationAdController.isCreativeWorkflowActive, isFalse);
    });

    test('NativeAdPreloadPool and BannerAdPreloadPool claim returns null on empty pool safely', () {
      final claimedNative = NativeAdPreloadPool.claimSmall();
      expect(claimedNative, isNull);

      final claimedBanner = BannerAdPreloadPool.claimBanner();
      expect(claimedBanner, isNull);
    });
  });
}
