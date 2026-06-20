import 'package:flutter_starter/modules/user/user.dart';

abstract class AuthRepository {
  Future<void> loginWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Optional two-step registration: ship a verification code to [email].
  Future<void> registerEmail({required String email});

  /// Finalise registration. Pass an empty [code] when the backend doesn't
  /// require email verification.
  Future<void> registerUser({
    required String email,
    required String password,
    required String code,
  });

  Future<void> forgetPassword({required String email});

  Future<void> resetPassword({
    required String oldPassword,
    required String newPassword,
  });

  Future<void> loginWithGoogle();
  Future<void> loginWithApple();

  Future<UserEntity?> getLoggedInUser();

  Stream<UserEntity?> watchUser();

  // wasStillAuthenticated=false skips the server call (session already invalid).
  Future<void> logout({bool wasStillAuthenticated = true});
}
