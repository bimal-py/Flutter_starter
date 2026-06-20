import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/core/utils/enums/app_loading_state.dart';
import 'package:flutter_starter/modules/auth/domain/use_case/use_case.dart';

part 'signup_event.dart';
part 'signup_state.dart';

class SignupBloc extends Bloc<SignupEvent, SignupState> {
  SignupBloc() : super(const SignupState()) {
    on<SignupSubmitted>(_onSubmitted);
  }

  final RegisterUserUseCase _registerUserUseCase = getIt<RegisterUserUseCase>();

  Future<void> _onSubmitted(
    SignupSubmitted event,
    Emitter<SignupState> emit,
  ) async {
    emit(state.copyWith(appLoadingState: AppLoadingState.loading, error: null));
    try {
      await _registerUserUseCase.execute(
        RegisterUserParams(
          email: event.email,
          password: event.password,
          code: event.code,
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
