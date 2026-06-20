import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeTemplateAdWidget extends StatelessWidget {
  final NativeAd nativeAd;

  const NativeTemplateAdWidget({super.key, required this.nativeAd});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 100),
      child: AdWidget(ad: nativeAd),
    );
  }
}
