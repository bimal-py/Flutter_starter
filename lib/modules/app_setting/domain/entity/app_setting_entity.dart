import 'package:equatable/equatable.dart';

class AppSettingEntity extends Equatable {
  const AppSettingEntity({this.showOnboardingAtAppOpen = true});

  final bool showOnboardingAtAppOpen;

  @override
  List<Object?> get props => [showOnboardingAtAppOpen];
}
