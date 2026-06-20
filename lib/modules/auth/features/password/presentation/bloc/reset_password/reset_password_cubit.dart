import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_starter/core/core.dart';
import 'package:flutter_starter/core/errors/exceptions.dart';
import 'package:flutter_starter/modules/auth/domain/use_case/use_case.dart';

part 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  ResetPasswordCubit() : super(const ResetPasswordInitial());

  final ResetPasswordUseCase _resetPasswordUseCase =
      getIt<ResetPasswordUseCase>();

  Future<void> resetPasswordSubmitted({
    required String oldPassword,
    required String newPassword,
  }) async {
    emit(const ResetPasswordLoading());
    try {
      if (oldPassword == newPassword) {
        throw const ParseException(
          message: 'New password cannot be the same as the old password',
        );
      }
      await _resetPasswordUseCase.execute(
        ResetPasswordParams(
          oldPassword: oldPassword,
          newPassword: newPassword,
        ),
      );
      emit(const ResetPasswordSuccess());
    } catch (e) {
      emit(ResetPasswordError(error: AppErrorHandler.getErrorMessage(e)));
    }
  }
}
