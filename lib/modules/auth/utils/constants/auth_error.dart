class AuthError {
  AuthError._();

  static const String invalidAuthResponse =
      'Unexpected response from the server — please try again';
  static const String missingTokens =
      'Login succeeded but no tokens were returned';
  static const String userFetchFailed = 'Could not load your profile';
  static const String registerFailed = 'Registration could not be completed';
  static const String registerEmailFailed = 'Could not start registration';
  static const String verificationCodeAlreadySent =
      'A verification code was already sent. Please check your email.';
  static const String googleInitFailed = 'Failed to initialize Google Sign-In';
  static const String googleAuthFailed = 'Could not sign in with Google';
  static const String appleAuthFailed = 'Could not sign in with Apple';
}
