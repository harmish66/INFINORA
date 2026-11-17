import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/app_providers.dart';
import 'premium_entitlement.dart';

class SubscriptionNotifier extends Notifier<PremiumEntitlement> {
  static const _storageKey = 'infinora_premium_entitlement_v1';

  @override
  PremiumEntitlement build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        final entitlement = PremiumEntitlement.fromJson(map);
        // Verify expiry
        if (entitlement.isValid) {
          return entitlement;
        } else {
          return const PremiumEntitlement(isPremium: false, status: 'expired');
        }
      } catch (_) {
        return const PremiumEntitlement(isPremium: false, status: 'free');
      }
    }
    return const PremiumEntitlement(isPremium: false, status: 'free');
  }

  Future<void> activateSubscription({
    required String planId,
    Duration duration = const Duration(days: 365),
  }) async {
    final prefs = ref.read(sharedPreferencesProvider);
    final entitlement = PremiumEntitlement(
      isPremium: true,
      planId: planId,
      expiryDate: DateTime.now().add(duration),
      status: 'active',
    );
    await prefs.setString(_storageKey, jsonEncode(entitlement.toJson()));
    state = entitlement;
  }

  Future<void> revokeSubscription() async {
    final prefs = ref.read(sharedPreferencesProvider);
    const entitlement = PremiumEntitlement(
      isPremium: false,
      status: 'expired',
    );
    await prefs.setString(_storageKey, jsonEncode(entitlement.toJson()));
    state = entitlement;
  }

  bool get isAdFree => state.isValid;
}

final subscriptionProvider =
    NotifierProvider<SubscriptionNotifier, PremiumEntitlement>(() {
  return SubscriptionNotifier();
});

final isAdFreeUserProvider = Provider<bool>((ref) {
  final entitlement = ref.watch(subscriptionProvider);
  return entitlement.isValid;
});
