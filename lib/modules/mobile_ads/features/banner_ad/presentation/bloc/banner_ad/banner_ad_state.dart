part of 'banner_ad_cubit.dart';

class BannerAdState extends Equatable {
  final AppLoadingState loadingState;
  final BannerAd? bannerAd;
  final double bannerHeight;
  final String? error;

  const BannerAdState({
    this.loadingState = AppLoadingState.initial,
    this.bannerAd,
    this.error,
    this.bannerHeight = 60,
  });

  @override
  List<Object?> get props => [loadingState, bannerAd, error, bannerHeight];

  BannerAdState copyWith({
    AppLoadingState? loadingState,
    BannerAd? bannerAd,
    String? error,
    double? bannerHeight,
  }) {
    return BannerAdState(
      loadingState: loadingState ?? this.loadingState,
      bannerAd: bannerAd ?? this.bannerAd,
      error: error ?? this.error,
      bannerHeight: bannerHeight ?? this.bannerHeight,
    );
  }
}
