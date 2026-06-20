import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/modules/mobile_ads/mobile_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

part 'interstitial_ad_state.dart';

class InterstitialAdCubit extends Cubit<InterstitialAdState> {
  InterstitialAdCubit() : super(const InterstitialAdState());

  InterstitialAd? _interstitialAd;
  Timer? _retryTimer;
  int _retryCount = 0;

  static const _retryDelays = [
    Duration(seconds: 5),
    Duration(seconds: 30),
    Duration(seconds: 60),
  ];

  void loadAd() {
    _retryTimer?.cancel();
    emit(state.copyWith(status: InterstitialStatus.loading));

    InterstitialAd.load(
      adUnitId: InterstitialAdHelper.adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _retryCount = 0;
          _interstitialAd = ad;
          _interstitialAd!.setImmersiveMode(true);
          emit(state.copyWith(status: InterstitialStatus.loaded));
        },
        onAdFailedToLoad: (error) {
          emit(
            state.copyWith(
              status: InterstitialStatus.failed,
              error: error.message,
            ),
          );
          _scheduleRetry();
        },
      ),
    );
  }

  void showAd({VoidCallback? onAdClosed}) {
    if (_interstitialAd == null) {
      onAdClosed?.call();
      return;
    }

    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        onAdClosed?.call();
        loadAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        onAdClosed?.call();
        loadAd();
      },
    );

    _interstitialAd!.show();
  }

  void retryLoad() {
    _retryCount = 0;
    loadAd();
  }

  void _scheduleRetry() {
    if (_retryCount >= _retryDelays.length) return;
    final delay = _retryDelays[_retryCount++];
    _retryTimer = Timer(delay, loadAd);
  }

  bool get isAdReady => _interstitialAd != null;

  @override
  Future<void> close() {
    _retryTimer?.cancel();
    _interstitialAd?.dispose();
    return super.close();
  }
}
