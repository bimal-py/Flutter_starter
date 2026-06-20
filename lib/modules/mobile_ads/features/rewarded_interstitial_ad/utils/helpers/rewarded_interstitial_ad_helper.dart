import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedInterstitialAdHelper {
  static String get adUnitId {
    if (Platform.isAndroid) {
      return kDebugMode
          ? EnvHelper.get('DEV_ANDROID_REWARDED_INTERSTITIAL_AD_UNIT_ID')
          : EnvHelper.get('PROD_ANDROID_REWARDED_INTERSTITIAL_AD_UNIT_ID');
    } else if (Platform.isIOS) {
      return kDebugMode
          ? EnvHelper.get('DEV_IOS_REWARDED_INTERSTITIAL_AD_UNIT_ID')
          : EnvHelper.get('PROD_IOS_REWARDED_INTERSTITIAL_AD_UNIT_ID');
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static void loadRewardedInterstitialAd({
    required Function(RewardedInterstitialAd ad) onLoaded,
    required Function(String error) onFailed,
  }) {
    RewardedInterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedInterstitialAdLoadCallback: RewardedInterstitialAdLoadCallback(
        onAdLoaded: (ad) => onLoaded(ad),
        onAdFailedToLoad: (error) => onFailed(error.message),
      ),
    );
  }
}
