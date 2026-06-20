part of 'rewarded_ad_cubit.dart';

enum RewardedStatus { initial, loading, loaded, failed, showing }

class RewardedAdState extends Equatable {
  final RewardedStatus status;
  final String? error;

  const RewardedAdState({this.status = RewardedStatus.initial, this.error});

  RewardedAdState copyWith({RewardedStatus? status, String? error}) {
    return RewardedAdState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [status, error];
}
