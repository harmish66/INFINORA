import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'ad_config.dart';
import 'ad_events.dart';

class AdmobService {
  static bool _isInitialized = false;

  static bool get isInitialized => _isInitialized;

  static Future<InitializationStatus?> initialize() async {
    if (!AdConfig.isAdMobEnabled) {
      debugPrint('[AdMob] Ads globally disabled via configuration.');
      return null;
    }

    try {
      // Configure test devices and child-directed settings
      final configuration = RequestConfiguration(
        testDeviceIds: kDebugMode ? ['TEST_EMULATOR_DEVICE_ID'] : [],
        maxAdContentRating: MaxAdContentRating.g,
      );
      await MobileAds.instance.updateRequestConfiguration(configuration);

      final status = await MobileAds.instance.initialize();
      _isInitialized = true;
      debugPrint('[AdMob] Google Mobile Ads initialized successfully.');
      return status;
    } catch (e) {
      debugPrint('[AdMob] Initialization warning: $e');
      AdAnalyticsTracker.track(
        type: AdEventType.adFailed,
        adFormat: 'core_service',
        errorMessage: e.toString(),
      );
      return null;
    }
  }

  static Future<void> requestConsentInfoUpdate() async {
    // Official User Messaging Platform (UMP) consent helper hook
    try {
      final params = ConsentRequestParameters();
      ConsentInformation.instance.requestConsentInfoUpdate(
        params,
        () async {
          if (await ConsentInformation.instance.isConsentFormAvailable()) {
            _loadAndShowConsentForm();
          }
        },
        (FormError error) {
          debugPrint('[AdMob UMP] Consent info update error: ${error.message}');
        },
      );
    } catch (e) {
      debugPrint('[AdMob UMP] Error requesting consent: $e');
    }
  }

  static void _loadAndShowConsentForm() {
    ConsentForm.loadConsentForm(
      (ConsentForm consentForm) async {
        final status = await ConsentInformation.instance.getConsentStatus();
        if (status == ConsentStatus.required) {
          consentForm.show((FormError? error) {
            if (error != null) {
              debugPrint('[AdMob UMP] Form presentation error: ${error.message}');
            }
          });
        }
      },
      (FormError formError) {
        debugPrint('[AdMob UMP] Failed to load consent form: ${formError.message}');
      },
    );
  }
}
