class AuthStorageKeys {
  AuthStorageKeys._();

  static const String boxName = 'auth_box';

  static const String loggedInUserKey = '${boxName}_logged_in_user';
  static const String authSessionKey = '${boxName}_session';

  // Secure-storage entries, namespaced under the box name.
  static const String accessTokenKey = '${boxName}_access_token';
  static const String refreshTokenKey = '${boxName}_refresh_token';
}
