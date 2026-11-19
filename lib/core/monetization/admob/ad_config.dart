import 'dart:io';

class AdConfig {
  static const bool isTestMode = true;
  static bool isAdMobEnabled = true;

  // Granular Placement Toggles (Controllable via Remote Config)
  static bool enableLanguageNativeAd = true;
  static bool enableHomeBannerAd = true;
  static bool enableHomeNativeAd = true;
  static bool enableTemplateNativeAd = true;
  static bool enableTemplateDetailsNativeAd = true;
  static bool enableProjectNativeAd = true;
  static bool enableNavigationInterstitialAd = true;
  static bool enableRewardedAds = true;
  static bool enableAppOpenAds = true;

  // Legacy format shortcuts
  static bool get enableBannerAds => isAdMobEnabled && enableHomeBannerAd;
  static bool get enableInterstitialAds => isAdMobEnabled && enableNavigationInterstitialAd;
  static bool get enableNativeAds =>
      isAdMobEnabled &&
      (enableLanguageNativeAd ||
          enableHomeNativeAd ||
          enableTemplateNativeAd ||
          enableTemplateDetailsNativeAd ||
          enableProjectNativeAd);

  // Official Google AdMob Test Ad Unit IDs
  static const String androidBannerTestId = 'ca-app-pub-3940256099942544/6300978111';
  static const String iosBannerTestId = 'ca-app-pub-3940256099942544/2934735716';

  static const String androidInterstitialTestId = 'ca-app-pub-3940256099942544/1033173712';
  static const String iosInterstitialTestId = 'ca-app-pub-3940256099942544/4411468910';

  static const String androidRewardedTestId = 'ca-app-pub-3940256099942544/5224354917';
  static const String iosRewardedTestId = 'ca-app-pub-3940256099942544/1712485313';

  static const String androidNativeTestId = 'ca-app-pub-3940256099942544/2247696110';
  static const String iosNativeTestId = 'ca-app-pub-3940256099942544/3986624511';

  static const String androidAppOpenTestId = 'ca-app-pub-3940256099942544/9257395921';
  static const String iosAppOpenTestId = 'ca-app-pub-3940256099942544/5662855259';

  // Production Ad Unit IDs (populated when releasing to app stores)
  static String androidBannerProdId = '';
  static String iosBannerProdId = '';
  static String androidInterstitialProdId = '';
  static String iosInterstitialProdId = '';
  static String androidRewardedProdId = '';
  static String iosRewardedProdId = '';
  static String androidNativeProdId = '';
  static String iosNativeProdId = '';
  static String androidAppOpenProdId = '';
  static String iosAppOpenProdId = '';

  static String get bannerAdUnitId {
    if (isTestMode || (Platform.isAndroid ? androidBannerProdId.isEmpty : iosBannerProdId.isEmpty)) {
      return Platform.isAndroid ? androidBannerTestId : iosBannerTestId;
    }
    return Platform.isAndroid ? androidBannerProdId : iosBannerProdId;
  }

  static String get interstitialAdUnitId {
    if (isTestMode || (Platform.isAndroid ? androidInterstitialProdId.isEmpty : iosInterstitialProdId.isEmpty)) {
      return Platform.isAndroid ? androidInterstitialTestId : iosInterstitialTestId;
    }
    return Platform.isAndroid ? androidInterstitialProdId : iosInterstitialProdId;
  }

  static String get rewardedAdUnitId {
    if (isTestMode || (Platform.isAndroid ? androidRewardedProdId.isEmpty : iosRewardedProdId.isEmpty)) {
      return Platform.isAndroid ? androidRewardedTestId : iosRewardedTestId;
    }
    return Platform.isAndroid ? androidRewardedProdId : iosRewardedProdId;
  }

  static String get nativeAdUnitId {
    if (isTestMode || (Platform.isAndroid ? androidNativeProdId.isEmpty : iosNativeProdId.isEmpty)) {
      return Platform.isAndroid ? androidNativeTestId : iosNativeTestId;
    }
    return Platform.isAndroid ? androidNativeProdId : iosNativeProdId;
  }

  static String get appOpenAdUnitId {
    if (isTestMode || (Platform.isAndroid ? androidAppOpenProdId.isEmpty : iosAppOpenProdId.isEmpty)) {
      return Platform.isAndroid ? androidAppOpenTestId : iosAppOpenTestId;
    }
    return Platform.isAndroid ? androidAppOpenProdId : iosAppOpenProdId;
  }

  /// Apply runtime / Remote Config overrides dynamically
  static void applyRemoteConfigOverrides(Map<String, dynamic> remoteValues) {
    if (remoteValues.containsKey('is_admob_enabled')) {
      isAdMobEnabled = remoteValues['is_admob_enabled'] as bool? ?? isAdMobEnabled;
    }
    if (remoteValues.containsKey('enable_language_native_ad')) {
      enableLanguageNativeAd = remoteValues['enable_language_native_ad'] as bool? ?? enableLanguageNativeAd;
    }
    if (remoteValues.containsKey('enable_home_banner_ad')) {
      enableHomeBannerAd = remoteValues['enable_home_banner_ad'] as bool? ?? enableHomeBannerAd;
    }
    if (remoteValues.containsKey('enable_home_native_ad')) {
      enableHomeNativeAd = remoteValues['enable_home_native_ad'] as bool? ?? enableHomeNativeAd;
    }
    if (remoteValues.containsKey('enable_template_native_ad')) {
      enableTemplateNativeAd = remoteValues['enable_template_native_ad'] as bool? ?? enableTemplateNativeAd;
    }
    if (remoteValues.containsKey('enable_template_details_native_ad')) {
      enableTemplateDetailsNativeAd =
          remoteValues['enable_template_details_native_ad'] as bool? ?? enableTemplateDetailsNativeAd;
    }
    if (remoteValues.containsKey('enable_project_native_ad')) {
      enableProjectNativeAd = remoteValues['enable_project_native_ad'] as bool? ?? enableProjectNativeAd;
    }
    if (remoteValues.containsKey('enable_navigation_interstitial_ad')) {
      enableNavigationInterstitialAd =
          remoteValues['enable_navigation_interstitial_ad'] as bool? ?? enableNavigationInterstitialAd;
    }
    if (remoteValues.containsKey('enable_rewarded_ads')) {
      enableRewardedAds = remoteValues['enable_rewarded_ads'] as bool? ?? enableRewardedAds;
    }
    if (remoteValues.containsKey('enable_app_open_ads')) {
      enableAppOpenAds = remoteValues['enable_app_open_ads'] as bool? ?? enableAppOpenAds;
    }
  }

  /// Reset to safe conservative default configuration
  static void resetToDefaults() {
    isAdMobEnabled = true;
    enableLanguageNativeAd = true;
    enableHomeBannerAd = true;
    enableHomeNativeAd = true;
    enableTemplateNativeAd = true;
    enableTemplateDetailsNativeAd = true;
    enableProjectNativeAd = true;
    enableNavigationInterstitialAd = true;
    enableRewardedAds = true;
    enableAppOpenAds = true;
  }
}
