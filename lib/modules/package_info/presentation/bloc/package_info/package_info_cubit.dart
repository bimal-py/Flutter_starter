import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/core/di/injection.dart';
import 'package:flutter_starter/modules/package_info/domain/entity/package_info_entity.dart';
import 'package:flutter_starter/modules/package_info/domain/use_case/remote/get_package_info_use_case.dart';

part 'package_info_state.dart';

class PackageInfoCubit extends Cubit<PackageInfoState> {
  PackageInfoCubit() : _useCase = getIt<GetPackageInfoUseCase>(), super(const PackageInfoState());

  final GetPackageInfoUseCase _useCase;

  Future<void> loadPackageInfo() async {
    final entity = await _useCase.execute(const NoParams());
    emit(state.copyWith(packageInfo: entity));
  }
}
