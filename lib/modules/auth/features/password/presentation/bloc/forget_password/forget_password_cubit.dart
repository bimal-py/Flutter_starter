import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/modules/auth/domain/use_case/use_case.dart';

part 'forget_password_state.dart';

class ForgetPasswordCubit extends Cubit<ForgetPasswordState> {
  ForgetPasswordCubit() : super(const ForgetPasswordInitial());

  final ForgetPasswordUseCase _forgetPasswordUseCase =
      getIt<ForgetPasswordUseCase>();

  Future<void> forgetPasswordSubmitted({required String email}) async {
    emit(const ForgetPasswordLoading());
    try {
      await _forgetPasswordUseCase.execute(email);
      emit(const ForgetPasswordSuccess());
    } catch (e) {
      emit(ForgetPasswordError(error: AppErrorHandler.getErrorMessage(e)));
    }
  }
}
