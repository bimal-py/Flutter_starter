import 'package:flutter/foundation.dart';

/// Single source of truth for whether ads should be shown anywhere in the app.
///
/// It is deliberately shaped so any future "no ads" source — a temporary
/// rewarded window, a premium **in-app subscription**, a lifetime unlock —
/// plugs into [adsRemoved] and every ad in the app obeys, with no other change.
///
/// A [ChangeNotifier] so ad widgets rebuild the instant visibility changes.
class AdsController extends ChangeNotifier {
  AdsController._();

  static final AdsController instance = AdsController._();

  /// Master kill-switch for all non-forced ads (remote config / debug toggle /
  /// emergency off). Defaults to on.
  bool _enabled = true;
  bool get enabled => _enabled;
  set enabled(bool value) {
    if (_enabled == value) return;
    _enabled = value;
    notifyListeners();
  }

  /// **Extension point.** Returns true when the user currently holds any "no
  /// ads" entitlement. Add sources here (e.g.
  /// `if (SubscriptionController.instance.isPremium) return true;`) and the
  /// whole app honours it. Remember to `notifyListeners()` from the source.
  bool get adsRemoved => false;

  /// Whether a normal (revenue / house) ad should render right now.
  ///
  /// [forceShow] bypasses BOTH the master switch and entitlements — for ads
  /// that must keep working regardless of ad-free state (rewarded gates that
  /// unlock features). A subscription must NOT silence those.
  bool shouldShow({bool forceShow = false}) {
    if (forceShow) return true;
    return _enabled && !adsRemoved;
  }
}
