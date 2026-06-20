part of 'interstitial_ad_cubit.dart';

enum InterstitialStatus { initial, loading, loaded, showing, failed }

class InterstitialAdState extends Equatable {
  final InterstitialStatus status;
  final String? error;

  const InterstitialAdState({
    this.status = InterstitialStatus.initial,
    this.error,
  });

  InterstitialAdState copyWith({InterstitialStatus? status, String? error}) {
    return InterstitialAdState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}
