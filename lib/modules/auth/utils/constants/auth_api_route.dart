class AuthApiRoute {
  AuthApiRoute._();

  static const String login = 'auth/login/';
  static const String logout = 'auth/logout/';
  static const String googleLogin = 'auth/oauth/google/';
  static const String appleLogin = 'auth/oauth/apple/';
  static const String refresh = 'auth/token/refresh/';
  static const String registerEmail = 'auth/register/email/';
  static const String register = 'auth/register/';
  static const String forgetPassword = 'auth/password/reset/';
  static const String resetPassword = 'auth/password/change/';

  // Fetch / validate current user; also used as a token-validity check.
  static const String user = 'auth/user/';
}
