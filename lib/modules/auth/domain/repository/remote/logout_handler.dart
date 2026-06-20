abstract class LogoutHandler {
  // Always clears local session, even if remote calls fail.
  // wasStillAuthenticated=false skips the server call (session already invalid).
  Future<void> logout({bool wasStillAuthenticated = true});
}
