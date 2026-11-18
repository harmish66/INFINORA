import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import '../../constants/app_colors.dart';
import '../subscriptions/subscription_service.dart';
import 'ad_config.dart';
import 'ad_events.dart';

/// Core Real Google Mobile Ads Native Ad Widget with NativeTemplateStyle
class RealNativeAdWidget extends ConsumerStatefulWidget {
  final String placement;
  final TemplateType templateType;
  final double? height;
  final Widget? fallbackWidget;

  const RealNativeAdWidget({
    super.key,
    required this.placement,
    this.templateType = TemplateType.small,
    this.height,
    this.fallbackWidget,
  });

  @override
  ConsumerState<RealNativeAdWidget> createState() => _RealNativeAdWidgetState();
}

class _RealNativeAdWidgetState extends ConsumerState<RealNativeAdWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;
  bool _hasFailed = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNativeAd();
    });
  }

  void _loadNativeAd() {
    final isAdFree = ref.read(isAdFreeUserProvider);
    if (isAdFree || !AdConfig.isAdMobEnabled) {
      return;
    }

    final isPlacementEnabled = switch (widget.placement) {
      'language_selection_bottom' => AdConfig.enableLanguageNativeAd,
      'template_details_bottom' => AdConfig.enableTemplateDetailsNativeAd,
      'project_list_feed' || 'home_project_grid' => AdConfig.enableProjectNativeAd,
      'template_feed' || 'templates_grid' || 'template_section' => AdConfig.enableTemplateNativeAd,
      _ => AdConfig.enableNativeAds,
    };

    if (!isPlacementEnabled) {
      return;
    }

    AdAnalyticsTracker.track(
      type: AdEventType.adRequest,
      adFormat: 'native',
      placement: widget.placement,
    );

    final isDark = Theme.of(context).brightness == Brightness.dark;

    try {
      _nativeAd = NativeAd(
        adUnitId: AdConfig.nativeAdUnitId,
        request: const AdRequest(),
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            if (!mounted) {
              ad.dispose();
              return;
            }
            setState(() {
              _isLoaded = true;
              _hasFailed = false;
            });
            AdAnalyticsTracker.track(
              type: AdEventType.adLoaded,
              adFormat: 'native',
              placement: widget.placement,
            );
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('[AdMob Native] Failed to load at ${widget.placement}: ${error.message}');
            ad.dispose();
            _nativeAd = null;
            if (!mounted) return;
            setState(() {
              _isLoaded = false;
              _hasFailed = true;
            });
            AdAnalyticsTracker.track(
              type: AdEventType.adFailed,
              adFormat: 'native',
              placement: widget.placement,
              errorMessage: error.message,
            );
          },
          onAdClicked: (ad) {
            AdAnalyticsTracker.track(
              type: AdEventType.adClicked,
              adFormat: 'native',
              placement: widget.placement,
            );
          },
          onAdImpression: (ad) {
            AdAnalyticsTracker.track(
              type: AdEventType.adImpression,
              adFormat: 'native',
              placement: widget.placement,
            );
          },
        ),
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: widget.templateType,
          mainBackgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          cornerRadius: 12.0,
          callToActionTextStyle: NativeTemplateTextStyle(
            textColor: Colors.white,
            backgroundColor: const Color(0xFF0284C7),
            style: NativeTemplateFontStyle.bold,
            size: 13.0,
          ),
          primaryTextStyle: NativeTemplateTextStyle(
            textColor: isDark ? Colors.white : const Color(0xFF0F172A),
            style: NativeTemplateFontStyle.bold,
            size: 13.5,
          ),
          secondaryTextStyle: NativeTemplateTextStyle(
            textColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            style: NativeTemplateFontStyle.normal,
            size: 11.5,
          ),
          tertiaryTextStyle: NativeTemplateTextStyle(
            textColor: isDark ? const Color(0xFF64748B) : const Color(0xFF94A3B8),
            style: NativeTemplateFontStyle.normal,
            size: 10.5,
          ),
        ),
      );

      _nativeAd!.load();
    } catch (e) {
      debugPrint('[AdMob Native] Exception creating native ad: $e');
      _hasFailed = true;
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdFree = ref.watch(isAdFreeUserProvider);
    if (isAdFree || !AdConfig.isAdMobEnabled) {
      return const SizedBox.shrink();
    }

    if (_isLoaded && _nativeAd != null) {
      final double targetHeight = widget.height ??
          (widget.templateType == TemplateType.small ? 96.0 : 330.0);
      return Container(
        height: targetHeight,
        margin: const EdgeInsets.symmetric(vertical: 6),
        alignment: Alignment.center,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: AdWidget(ad: _nativeAd!),
        ),
      );
    }

    if (_hasFailed) {
      return widget.fallbackWidget ?? const SizedBox.shrink();
    }

    return widget.fallbackWidget ?? const SizedBox.shrink();
  }
}

/// Reusable Native Card Widget for Template Grid
class NativeAdCardWidget extends ConsumerStatefulWidget {
  final String placement;

  const NativeAdCardWidget({
    super.key,
    this.placement = 'template_feed',
  });

  @override
  ConsumerState<NativeAdCardWidget> createState() => _NativeAdCardWidgetState();
}

class _NativeAdCardWidgetState extends ConsumerState<NativeAdCardWidget> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadNativeAd();
    });
  }

  void _loadNativeAd() {
    final isAdFree = ref.read(isAdFreeUserProvider);
    if (isAdFree || !AdConfig.isAdMobEnabled || !AdConfig.enableTemplateNativeAd) {
      return;
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    try {
      _nativeAd = NativeAd(
        adUnitId: AdConfig.nativeAdUnitId,
        request: const AdRequest(),
        listener: NativeAdListener(
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
              adFormat: 'native',
              placement: widget.placement,
            );
          },
          onAdFailedToLoad: (ad, error) {
            ad.dispose();
            _nativeAd = null;
            if (!mounted) return;
            setState(() {
              _isLoaded = false;
            });
          },
        ),
        nativeTemplateStyle: NativeTemplateStyle(
          templateType: TemplateType.medium,
          mainBackgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
          cornerRadius: 12.0,
          callToActionTextStyle: NativeTemplateTextStyle(
            textColor: Colors.white,
            backgroundColor: const Color(0xFF0284C7),
            style: NativeTemplateFontStyle.bold,
            size: 12.0,
          ),
          primaryTextStyle: NativeTemplateTextStyle(
            textColor: isDark ? Colors.white : const Color(0xFF0F172A),
            style: NativeTemplateFontStyle.bold,
            size: 13.0,
          ),
          secondaryTextStyle: NativeTemplateTextStyle(
            textColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
            style: NativeTemplateFontStyle.normal,
            size: 11.0,
          ),
        ),
      );

      _nativeAd!.load();
    } catch (e) {
      debugPrint('[AdMob Native] Error loading card ad: $e');
    }
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    _nativeAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isAdFree = ref.watch(isAdFreeUserProvider);
    if (isAdFree || !AdConfig.isAdMobEnabled || !AdConfig.enableTemplateNativeAd) {
      return const SizedBox.shrink();
    }

    if (_isLoaded && _nativeAd != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: AdWidget(ad: _nativeAd!),
      );
    }

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.campaign_rounded,
                          size: 32,
                          color: const Color(0xFF0284C7).withValues(alpha: 0.8),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Creative Partner',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white70 : const Color(0xFF334155),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 10, color: Colors.white),
                        SizedBox(width: 4),
                        Text(
                          'Ad',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Creative Cloud & Hardware',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  'Explore professional stylus accessories and digital drawing monitors.',
                  style: TextStyle(
                    fontSize: 10,
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                    height: 1.3,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: OutlinedButton(
                    onPressed: () {
                      AdAnalyticsTracker.track(
                        type: AdEventType.adClicked,
                        adFormat: 'native',
                        placement: widget.placement,
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Learn More', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Reusable Native Advertisement Widget for Language Selection Screen Bottom
class NativeLanguageBottomAdWidget extends StatelessWidget {
  const NativeLanguageBottomAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const RealNativeAdWidget(
      placement: 'language_selection_bottom',
      templateType: TemplateType.small,
      height: 96,
    );
  }
}

/// Reusable Native Advertisement Widget for Template Details Screen
class NativeTemplateDetailsAdWidget extends StatelessWidget {
  const NativeTemplateDetailsAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const RealNativeAdWidget(
      placement: 'template_details_bottom',
      templateType: TemplateType.medium,
      height: 330,
    );
  }
}

/// Reusable Native Advertisement Widget for Project List Feed
class NativeProjectListAdWidget extends StatelessWidget {
  const NativeProjectListAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const RealNativeAdWidget(
      placement: 'project_list_feed',
      templateType: TemplateType.small,
      height: 96,
    );
  }
}

/// Reusable Native Advertisement Widget for Template Library Sections
class NativeTemplateSectionAdWidget extends StatelessWidget {
  const NativeTemplateSectionAdWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const RealNativeAdWidget(
      placement: 'template_section',
      templateType: TemplateType.small,
      height: 96,
    );
  }
}
