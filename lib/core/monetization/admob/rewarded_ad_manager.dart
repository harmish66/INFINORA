import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';
import 'ad_events.dart';
import 'ad_frequency_manager.dart';

class RewardedAdManager {
  static RewardedAd? _rewardedAd;
  static bool _isLoading = false;

  static void preloadRewardedAd() {
    if (!AdConfig.enableRewardedAds || _isLoading || _rewardedAd != null) {
      return;
    }

    _isLoading = true;
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
          _isLoading = false;
          AdAnalyticsTracker.track(
            type: AdEventType.adLoaded,
            adFormat: 'rewarded',
            placement: 'preload',
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdMob Rewarded] Failed to preload: ${error.message}');
          _rewardedAd = null;
          _isLoading = false;
          AdAnalyticsTracker.track(
            type: AdEventType.adFailed,
            adFormat: 'rewarded',
            placement: 'preload',
            errorMessage: error.message,
          );
        },
      ),
    );
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
    _rewardedAd?.dispose();
    _rewardedAd = null;
    _isLoading = false;
  }
}
