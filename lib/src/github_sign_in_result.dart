class GitHubSignInResult {
  final String? token;
  final GitHubSignInResultStatus status;
  final String errorMessage;
  final Map<String, dynamic>? userData;

  GitHubSignInResult(
    this.status, {
    this.token,
    this.errorMessage = "",
    this.userData,
  });
}

enum GitHubSignInResultStatus {
  /// The login was successful.
  ok,

  /// The user cancelled the login flow, usually by closing the
  /// login dialog.
  cancelled,

  /// The login completed with an error and the user couldn't log
  /// in for some reason.
  failed,
}
