import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/core/di/injection.dart';
import 'package:flutter_starter/modules/device_info/domain/entity/device_info_entity.dart';
import 'package:flutter_starter/modules/device_info/domain/use_case/remote/get_device_info_use_case.dart';

part 'device_info_state.dart';

class DeviceInfoCubit extends Cubit<DeviceInfoState> {
  DeviceInfoCubit() : _useCase = getIt<GetDeviceInfoUseCase>(), super(const DeviceInfoState());

  final GetDeviceInfoUseCase _useCase;

  Future<void> loadDeviceInfo() async {
    final entity = await _useCase.execute(const NoParams());
    emit(state.copyWith(deviceInfo: entity));
  }
}
