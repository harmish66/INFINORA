import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';
import 'ad_events.dart';
import 'ad_frequency_manager.dart';

class RewardedAdManager {
  static RewardedAd? _rewardedAd;
  static bool _isLoading = false;
  static DateTime? _loadedTime;
  static int _retryAttempt = 0;
  static Timer? _retryTimer;

  static bool get isAdAvailable {
    if (_rewardedAd == null) return false;
    if (_loadedTime != null &&
        DateTime.now().difference(_loadedTime!).inHours >= 4) {
      debugPrint('[AdMob Rewarded] Cached ad expired. Disposing and reloading.');
      _rewardedAd?.dispose();
      _rewardedAd = null;
      _loadedTime = null;
      preloadRewardedAd();
      return false;
    }
    return true;
  }

  static void preloadRewardedAd() {
    if (!AdConfig.isAdMobEnabled || !AdConfig.enableRewardedAds) {
      return;
    }
    if (_isLoading || isAdAvailable) {
      return;
    }

    _isLoading = true;
    _retryTimer?.cancel();

    AdAnalyticsTracker.track(
      type: AdEventType.adRequest,
      adFormat: 'rewarded',
      placement: 'preload',
    );

    RewardedAd.load(
      adUnitId: AdConfig.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          _loadedTime = DateTime.now();
          _isLoading = false;
          _retryAttempt = 0;
          debugPrint('[AdMob Rewarded] Preload successful and ready.');
          AdAnalyticsTracker.track(
            type: AdEventType.adLoaded,
            adFormat: 'rewarded',
            placement: 'preload',
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdMob Rewarded] Failed to preload: ${error.message}');
          _rewardedAd = null;
          _loadedTime = null;
          _isLoading = false;
          AdAnalyticsTracker.track(
            type: AdEventType.adFailed,
            adFormat: 'rewarded',
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
      preloadRewardedAd();
    });
  }

  static Future<void> showRewardedAdWithConsent({
    required BuildContext context,
    required String rewardTitle,
    required String rewardDescription,
    required VoidCallback onRewardGranted,
    VoidCallback? onFailedOrDeclined,
  }) async {
    // 1. Explicit user consent dialog explaining the benefit
    final shouldWatch = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFD97706).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.workspace_premium_rounded, color: Color(0xFFD97706), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                rewardTitle,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16),
              ),
            ),
          ],
        ),
        content: Text(
          '$rewardDescription\n\nWould you like to watch a short sponsored message to unlock this feature for your current session?',
          style: const TextStyle(fontSize: 13, height: 1.45),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Not Now'),
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.play_circle_outline_rounded, size: 18),
            label: const Text('Watch Message'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0284C7),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              elevation: 0,
            ),
            onPressed: () => Navigator.pop(ctx, true),
          ),
        ],
      ),
    );

    if (shouldWatch != true) {
      onFailedOrDeclined?.call();
      return;
    }

    // 2. Verify ad readiness
    if (_rewardedAd == null) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Message is loading. Unlocking reward directly for this session.'),
            duration: Duration(seconds: 3),
          ),
        );
      }
      preloadRewardedAd();
      onRewardGranted();
      return;
    }

    bool userEarnedReward = false;

    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        AdFrequencyManager.recordFullScreenAdShown();
        AdAnalyticsTracker.track(
          type: AdEventType.rewardedAdStarted,
          adFormat: 'rewarded',
          placement: rewardTitle,
        );
      },
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        preloadRewardedAd();
        if (userEarnedReward) {
          onRewardGranted();
        } else {
          onFailedOrDeclined?.call();
        }
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('[AdMob Rewarded] Failed to show: ${error.message}');
        ad.dispose();
        _rewardedAd = null;
        preloadRewardedAd();
        AdAnalyticsTracker.track(
          type: AdEventType.adFailed,
          adFormat: 'rewarded',
          placement: rewardTitle,
          errorMessage: error.message,
        );
        onFailedOrDeclined?.call();
      },
    );

    await _rewardedAd!.show(
      onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        userEarnedReward = true;
        AdAnalyticsTracker.track(
          type: AdEventType.rewardedAdRewardGranted,
          adFormat: 'rewarded',
          placement: rewardTitle,
          extra: {'amount': reward.amount, 'type': reward.type},
        );
      },
    );
  }

  static void dispose() {
    _retryTimer?.cancel();
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _loadedTime = null;
    _isLoading = false;
    _retryAttempt = 0;
  }
}
