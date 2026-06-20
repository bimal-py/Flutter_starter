part of 'native_template_ad_cubit.dart';

class NativeTemplateAdState extends Equatable {
  final AppLoadingState appLoadingState;
  final NativeAd? nativeAd;
  final String? error;

  const NativeTemplateAdState({
    this.appLoadingState = AppLoadingState.initial,
    this.nativeAd,
    this.error,
  });

  NativeTemplateAdState copyWith({
    AppLoadingState? appLoadingState,
    NativeAd? nativeAd,
    String? error,
  }) {
    return NativeTemplateAdState(
      appLoadingState: appLoadingState ?? this.appLoadingState,
      nativeAd: nativeAd ?? this.nativeAd,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [appLoadingState, nativeAd, error];
}
