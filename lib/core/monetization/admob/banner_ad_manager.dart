import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../subscriptions/subscription_service.dart';
import 'ad_config.dart';
import 'ad_events.dart';

/// Centralized Preloaded Banner Ad Pool for instant banner display
class BannerAdPreloadPool {
  static BannerAd? _preloadedBanner;
  static bool _isLoading = false;
  static int _retryAttempt = 0;
  static Timer? _retryTimer;

  static bool get isAvailable => _preloadedBanner != null;

  static void preloadBanner({AdSize adSize = AdSize.banner}) {
    if (!AdConfig.isAdMobEnabled || !AdConfig.enableBannerAds) return;
    if (_preloadedBanner != null || _isLoading) return;

    _isLoading = true;
    _retryTimer?.cancel();

    AdAnalyticsTracker.track(
      type: AdEventType.adRequest,
      adFormat: 'banner',
      placement: 'preload_pool_banner',
    );

    BannerAd? ad;
    ad = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (loadedAd) {
          _isLoading = false;
          _retryAttempt = 0;
          _preloadedBanner = loadedAd as BannerAd;
          debugPrint('[BannerAdPreloadPool] Preloaded banner ad ready.');
          AdAnalyticsTracker.track(
            type: AdEventType.adLoaded,
            adFormat: 'banner',
            placement: 'preload_pool_banner',
          );
        },
        onAdFailedToLoad: (failedAd, error) {
          debugPrint('[BannerAdPreloadPool] Failed to preload banner: ${error.message}');
          _isLoading = false;
          failedAd.dispose();
          _scheduleRetry();
        },
      ),
    );
    ad.load();
  }

  static void _scheduleRetry() {
    _retryTimer?.cancel();
    _retryAttempt++;
    final delaySeconds = math.min(math.pow(2, _retryAttempt).toInt() * 2, 60);
    _retryTimer = Timer(Duration(seconds: delaySeconds), () {
      preloadBanner();
    });
  }

  static BannerAd? claimBanner() {
    if (_preloadedBanner != null) {
      final ad = _preloadedBanner;
      _preloadedBanner = null;
      Future.microtask(() => preloadBanner());
      return ad;
    }
    preloadBanner();
    return null;
  }

  static void disposeAll() {
    _retryTimer?.cancel();
    _preloadedBanner?.dispose();
    _preloadedBanner = null;
    _isLoading = false;
    _retryAttempt = 0;
  }
}

class AdmobBannerWidget extends ConsumerStatefulWidget {
  final String placement;
  final AdSize adSize;

  const AdmobBannerWidget({
    super.key,
    this.placement = 'home_bottom',
    this.adSize = AdSize.banner,
  });

  @override
  ConsumerState<AdmobBannerWidget> createState() => _AdmobBannerWidgetState();
}

class _AdmobBannerWidgetState extends ConsumerState<AdmobBannerWidget> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    final isAdFree = ref.read(isAdFreeUserProvider);
    if (!isAdFree && AdConfig.enableBannerAds && widget.adSize == AdSize.banner) {
      final preloaded = BannerAdPreloadPool.claimBanner();
      if (preloaded != null) {
        _bannerAd = preloaded;
        _isLoaded = true;
        AdAnalyticsTracker.track(
          type: AdEventType.adLoaded,
          adFormat: 'banner',
          placement: '${widget.placement}_preloaded',
        );
        return;
      }
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadBanner();
    });
  }

  void _loadBanner() {
    final isAdFree = ref.read(isAdFreeUserProvider);
    if (isAdFree || !AdConfig.enableBannerAds) {
      return;
    }

    AdAnalyticsTracker.track(
      type: AdEventType.adRequest,
      adFormat: 'banner',
      placement: widget.placement,
    );

    _bannerAd = BannerAd(
      adUnitId: AdConfig.bannerAdUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (!mounted) {
            ad.dispose();
            return;
          }
          setState(() {
            _isLoaded = true;
          });
          AdAnalyticsTracker.track(
            type: AdEventType.adLoaded,
            adFormat: 'banner',
            placement: widget.placement,
          );
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('[AdMob Banner] Failed to load at ${widget.placement}: ${error.message}');
          ad.dispose();
          if (mounted) {
            setState(() {
              _isLoaded = false;
              _bannerAd = null;
            });
          }
          AdAnalyticsTracker.track(
            type: AdEventType.adFailed,
            adFormat: 'banner',
            placement: widget.placement,
            errorMessage: error.message,
          );
        },
        onAdImpression: (ad) {
          AdAnalyticsTracker.track(
            type: AdEventType.adImpression,
            adFormat: 'banner',
            placement: widget.placement,
          );
        },
        onAdClicked: (ad) {
          AdAnalyticsTracker.track(
            type: AdEventType.adClicked,
            adFormat: 'banner',
            placement: widget.placement,
          );
        },
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdFree = ref.watch(isAdFreeUserProvider);
    if (isAdFree || !AdConfig.enableBannerAds) {
      return const SizedBox.shrink();
    }

    if (!_isLoaded || _bannerAd == null) {
      return const SizedBox.shrink();
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        border: Border(
          top: BorderSide(
            color: isDark ? const Color(0xFF1E293B) : const Color(0xFFE2E8F0),
            width: 0.8,
          ),
        ),
      ),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
