import 'package:flutter/foundation.dart';

enum AdEventType {
  adRequest,
  adLoaded,
  adFailed,
  adImpression,
  adClicked,
  rewardedAdStarted,
  rewardedAdCompleted,
  rewardedAdRewardGranted,
  interstitialAdShown,
  subscriptionStarted,
  subscriptionExpired,
}

class AdAnalyticsTracker {
  static final List<Map<String, dynamic>> _eventHistory = [];

  static int get impressionCount =>
      _eventHistory.where((e) => e['event'] == AdEventType.adImpression.name).length;

  static int get requestCount =>
      _eventHistory.where((e) => e['event'] == AdEventType.adRequest.name).length;

  static int get rewardedCompletedCount =>
      _eventHistory.where((e) => e['event'] == AdEventType.rewardedAdCompleted.name).length;

  static void track({
    required AdEventType type,
    required String adFormat,
    String? placement,
    String? errorMessage,
    Map<String, dynamic>? extra,
  }) {
    final entry = {
      'event': type.name,
      'format': adFormat,
      'placement': placement ?? 'default',
      'timestamp': DateTime.now().toIso8601String(),
      'error': ?errorMessage,
      if (extra != null) ...extra,
    };

    _eventHistory.add(entry);
    if (_eventHistory.length > 500) {
      _eventHistory.removeAt(0);
    }

    if (kDebugMode) {
      debugPrint('[AdAnalytics] ${type.name} ($adFormat at $placement)');
    }
  }

  static List<Map<String, dynamic>> getRecentEvents([int limit = 50]) {
    return _eventHistory.reversed.take(limit).toList();
  }
}
