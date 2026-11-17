import 'package:shared_preferences/shared_preferences.dart';

class AdFrequencyManager {
  static const String _keyLastInterstitialTime = 'ad_last_interstitial_timestamp';
  static const String _keyLastFullScreenTime = 'ad_last_fullscreen_timestamp';
  static const String _keyDailyInterstitialCount = 'ad_daily_interstitial_count';
  static const String _keyDailyDate = 'ad_daily_tracking_date';

  static const int minMinutesBetweenInterstitials = 5;
  static const int maxDailyInterstitials = 5;
  static const int minSecondsBetweenFullScreenAds = 60;

  static late SharedPreferences _prefs;

  static void initialize(SharedPreferences prefs) {
    _prefs = prefs;
    _checkAndResetDailyCounts();
  }

  static void _checkAndResetDailyCounts() {
    final today = DateTime.now().toIso8601String().split('T').first;
    final storedDate = _prefs.getString(_keyDailyDate);

    if (storedDate != today) {
      _prefs.setString(_keyDailyDate, today);
      _prefs.setInt(_keyDailyInterstitialCount, 0);
    }
  }

  static bool canShowInterstitial() {
    _checkAndResetDailyCounts();

    final dailyCount = _prefs.getInt(_keyDailyInterstitialCount) ?? 0;
    if (dailyCount >= maxDailyInterstitials) {
      return false;
    }

    final lastInterTime = _prefs.getInt(_keyLastInterstitialTime);
    if (lastInterTime != null) {
      final elapsed = DateTime.now().millisecondsSinceEpoch - lastInterTime;
      if (elapsed < minMinutesBetweenInterstitials * 60 * 1000) {
        return false;
      }
    }

    final lastFullTime = _prefs.getInt(_keyLastFullScreenTime);
    if (lastFullTime != null) {
      final elapsed = DateTime.now().millisecondsSinceEpoch - lastFullTime;
      if (elapsed < minSecondsBetweenFullScreenAds * 1000) {
        return false;
      }
    }

    return true;
  }

  static void recordInterstitialShown() {
    final now = DateTime.now().millisecondsSinceEpoch;
    final currentCount = _prefs.getInt(_keyDailyInterstitialCount) ?? 0;

    _prefs.setInt(_keyLastInterstitialTime, now);
    _prefs.setInt(_keyLastFullScreenTime, now);
    _prefs.setInt(_keyDailyInterstitialCount, currentCount + 1);
  }

  static void recordFullScreenAdShown() {
    final now = DateTime.now().millisecondsSinceEpoch;
    _prefs.setInt(_keyLastFullScreenTime, now);
  }
}
