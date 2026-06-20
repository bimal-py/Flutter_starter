import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/core/utils/enums/app_loading_state.dart';
import 'package:flutter_starter/modules/auth/domain/use_case/use_case.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(const LoginState()) {
    on<LoginWithEmailPasswordSubmitted>(_onSubmitted);
  }

  final LoginWithEmailPasswordUseCase _loginUseCase =
      getIt<LoginWithEmailPasswordUseCase>();

  Future<void> _onSubmitted(
    LoginWithEmailPasswordSubmitted event,
    Emitter<LoginState> emit,
  ) async {
    emit(state.copyWith(appLoadingState: AppLoadingState.loading, error: null));
    try {
      await _loginUseCase.execute(
        LoginWithEmailPasswordParams(
          email: event.email,
          password: event.password,
        ),
      );
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
