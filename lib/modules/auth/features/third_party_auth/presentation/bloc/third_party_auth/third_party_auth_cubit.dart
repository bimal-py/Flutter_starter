import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/core/utils/enums/app_loading_state.dart';
import 'package:flutter_starter/modules/auth/domain/use_case/use_case.dart';

part 'third_party_auth_state.dart';

class ThirdPartyAuthCubit extends Cubit<ThirdPartyAuthState> {
  ThirdPartyAuthCubit() : super(const ThirdPartyAuthState());

  final LoginWithGoogleUseCase _googleUseCase = getIt<LoginWithGoogleUseCase>();
  final LoginWithAppleUseCase _appleUseCase = getIt<LoginWithAppleUseCase>();

  Future<void> loginWithGoogle() =>
      _run(() async => _googleUseCase.execute(const NoParams()));

  Future<void> loginWithApple() =>
      _run(() async => _appleUseCase.execute(const NoParams()));

  Future<void> _run(Future<void> Function() action) async {
    emit(state.copyWith(appLoadingState: AppLoadingState.loading, error: null));
    try {
      await action();
      emit(state.copyWith(appLoadingState: AppLoadingState.success));
    } catch (e) {
      emit(
        state.copyWith(
          appLoadingState: AppLoadingState.failure,
          error: AppErrorHandler.getErrorMessage(e),
        ),
      );
    }
  }
}
