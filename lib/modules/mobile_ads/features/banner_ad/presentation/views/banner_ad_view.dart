import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/modules/mobile_ads/mobile_ads.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class BannerAdView extends StatelessWidget {
  const BannerAdView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BannerAdCubit()..loadAd(),
      child: BlocBuilder<BannerAdCubit, BannerAdState>(
        builder: (context, state) {
          if (state.loadingState == AppLoadingState.success &&
              state.bannerAd != null) {
            return BannerAdWidget(bannerAd: state.bannerAd!);
          }
          return SizedBox(height: AdSize.banner.height.toDouble());
        },
      ),
    );
  }
}
