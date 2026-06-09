part of 'device_info_cubit.dart';

class DeviceInfoState extends Equatable {
  const DeviceInfoState({this.deviceInfo});

  final DeviceInfoEntity? deviceInfo;

  DeviceInfoState copyWith({DeviceInfoEntity? deviceInfo}) =>
      DeviceInfoState(deviceInfo: deviceInfo ?? this.deviceInfo);

  @override
  List<Object?> get props => [deviceInfo];
}
