import 'package:flutter_starter/modules/auth/domain/entity/entity.dart';

// Obtains a credential from the platform SDK; the auth repo redeems it for our tokens.
abstract class ThirdPartyAuthProvider {
  Future<ThirdPartyCredential> retrieveGoogleCredential();
  Future<ThirdPartyCredential> retrieveAppleCredential();
  Future<void> signOut();
}
