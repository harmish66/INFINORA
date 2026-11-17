class PremiumEntitlement {
  final bool isPremium;
  final String? planId;
  final DateTime? expiryDate;
  final String status; // 'active', 'expired', 'free'

  const PremiumEntitlement({
    this.isPremium = false,
    this.planId,
    this.expiryDate,
    this.status = 'free',
  });

  bool get isValid {
    if (!isPremium) return false;
    if (expiryDate == null) return true; // Lifetime
    return expiryDate!.isAfter(DateTime.now());
  }

  Map<String, dynamic> toJson() => {
        'isPremium': isPremium,
        'planId': planId,
        'expiryDate': expiryDate?.toIso8601String(),
        'status': status,
      };

  factory PremiumEntitlement.fromJson(Map<String, dynamic> json) {
    return PremiumEntitlement(
      isPremium: json['isPremium'] as bool? ?? false,
      planId: json['planId'] as String?,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'] as String)
          : null,
      status: json['status'] as String? ?? 'free',
    );
  }
}
