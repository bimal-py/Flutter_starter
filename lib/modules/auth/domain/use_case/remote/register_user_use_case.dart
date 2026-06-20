import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_starter/common/common.dart';
import 'package:flutter_starter/modules/auth/domain/repository/remote/auth_repository.dart';
import 'package:injectable/injectable.dart';

@injectable
class RegisterUserUseCase extends UseCase<void, RegisterUserParams> {
  RegisterUserUseCase(this._repository);

  final AuthRepository _repository;

  @override
  FutureOr<void> execute(RegisterUserParams params) => _repository.registerUser(
    email: params.email,
    password: params.password,
    code: params.code,
  );
}

class RegisterUserParams extends Equatable {
  const RegisterUserParams({
    required this.email,
    required this.password,
    required this.code,
  });

  final String email;
  final String password;
  final String code;

  @override
  List<Object?> get props => [email, password, code];
}
