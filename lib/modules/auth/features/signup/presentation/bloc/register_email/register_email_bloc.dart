import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/core/utils/enums/app_loading_state.dart';
import 'package:flutter_starter/modules/auth/domain/use_case/use_case.dart';

part 'register_email_event.dart';
part 'register_email_state.dart';

class RegisterEmailBloc extends Bloc<RegisterEmailEvent, RegisterEmailState> {
  RegisterEmailBloc() : super(const RegisterEmailState()) {
    on<RegisterEmailSubmitted>(_onSubmitted);
    on<RegisterEmailTermsToggled>(_onTermsToggled);
  }

  final RegisterEmailUseCase _registerEmailUseCase =
      getIt<RegisterEmailUseCase>();

  void _onTermsToggled(
    RegisterEmailTermsToggled event,
    Emitter<RegisterEmailState> emit,
  ) => emit(state.copyWith(isAcceptedTerms: event.accepted));

  Future<void> _onSubmitted(
    RegisterEmailSubmitted event,
    Emitter<RegisterEmailState> emit,
  ) async {
    emit(state.copyWith(appLoadingState: AppLoadingState.loading, error: null));
    try {
      await _registerEmailUseCase.execute(event.email);
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
