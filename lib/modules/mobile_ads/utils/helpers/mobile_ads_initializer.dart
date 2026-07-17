import 'dart:async';
import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// One-time Mobile Ads SDK bootstrap, run once the app is foregrounded.
///
/// Privacy consent is gathered *before* the SDK initialises so the very first
/// ad request already respects the user's choice:
///   1. UMP consent form (GDPR/EU) via the bundled User Messaging Platform.
///      With an "IDFA explainer" message published in AdMob, this step also
///      shows the iOS ATT prompt for you.
///   2. iOS App Tracking Transparency — explicit fallback that shows the ATT
///      prompt if UMP didn't (e.g. no IDFA explainer for the locale). Gates
///      IDFA access for personalised ads. No-op on Android.
///
/// `app_tracking_transparency` is imported *only* here so the ATT dependency
/// stays sealed inside the ads module.
class MobileAdsInitializer {
  MobileAdsInitializer._();
  static final MobileAdsInitializer instance = MobileAdsInitializer._();

  bool _initialized = false;

  /// Safe to call repeatedly; all failures are swallowed so the app still runs
  /// with no ads. Call this *after the first frame* — the UMP form and the ATT
  /// prompt only appear while the app is foregrounded/active.
  Future<void> init() async {
    if (_initialized) return;
    try {
      await _gatherConsent();
      await _requestTrackingAuthorization();
      await MobileAds.instance.initialize();
      _initialized = true;
    } catch (_) {
      // Non-fatal — the app functions without ads.
    }
  }

  /// Requests a UMP consent-info update and shows the consent form if required
  /// (EU/GDPR users). Always completes — on any error we proceed with whatever
  /// consent state is already on record rather than blocking ads.
  Future<void> _gatherConsent() {
    final completer = Completer<void>();
    ConsentInformation.instance.requestConsentInfoUpdate(
      ConsentRequestParameters(),
      () => ConsentForm.loadAndShowConsentFormIfRequired((_) {
        if (!completer.isCompleted) completer.complete();
      }),
      (FormError _) {
        if (!completer.isCompleted) completer.complete();
      },
    );
    return completer.future;
  }

  /// Shows the iOS ATT prompt once (only while status is "not determined").
  /// The brief delay is the plugin's own guidance — the prompt is silently
  /// dropped if requested before the app is fully active. No-op off iOS and
  /// on iOS versions without ATT.
  Future<void> _requestTrackingAuthorization() async {
    if (!Platform.isIOS) return;
    try {
      final status = await AppTrackingTransparency.trackingAuthorizationStatus;
      if (status == TrackingStatus.notDetermined) {
        await Future<void>.delayed(const Duration(milliseconds: 200));
        await AppTrackingTransparency.requestTrackingAuthorization();
      }
    } catch (_) {
      // ATT unavailable — proceed with non-personalised ads.
    }
  }
}
