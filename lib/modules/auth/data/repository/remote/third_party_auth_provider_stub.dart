import 'package:flutter_starter/core/errors/exceptions.dart';
import 'package:flutter_starter/modules/auth/domain/entity/entity.dart';
import 'package:flutter_starter/modules/auth/domain/repository/remote/third_party_auth_provider.dart';
import 'package:injectable/injectable.dart';

/// Placeholder implementation. Replace with a real implementation that wires
/// `google_sign_in` and `sign_in_with_apple` when you need social login.
/// Annotate the real impl with `@LazySingleton(as: ThirdPartyAuthProvider)`
/// and remove this annotation.
@LazySingleton(as: ThirdPartyAuthProvider)
class ThirdPartyAuthProviderStub implements ThirdPartyAuthProvider {
  @override
  Future<ThirdPartyCredential> retrieveGoogleCredential() async {
    throw const AuthenticationException(
      message:
          'Google sign-in is not configured. Implement ThirdPartyAuthProvider.',
    );
  }

  @override
  Future<ThirdPartyCredential> retrieveAppleCredential() async {
    throw const AuthenticationException(
      message:
          'Apple sign-in is not configured. Implement ThirdPartyAuthProvider.',
    );
  }

  @override
  Future<void> signOut() async {}
}
