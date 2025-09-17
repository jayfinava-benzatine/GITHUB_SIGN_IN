/// The result of a GitHub OAuth sign-in attempt.
///
/// Contains the authentication status, access token, user data, and any error
/// messages.
/// Use the [status] field to determine if the sign-in was successful.
///
/// Example usage:
/// ```dart
/// final result = await gitHubSignIn.signIn(context);
/// if (result.status == GitHubSignInResultStatus.ok) {
///   print('Access token: ${result.token}');
///   print('User name: ${result.userData!['name']}');
/// }
/// ```
class GitHubSignInResult {
  /// The OAuth access token obtained from GitHub.
  ///
  /// This token can be used to make authenticated API requests to GitHub.
  /// Only available when [status] is [GitHubSignInResultStatus.ok].
  final String? token;
  /// The status of the sign-in attempt.
  ///
  /// Possible values:
  /// - [GitHubSignInResultStatus.ok]: Sign-in successful
  /// - [GitHubSignInResultStatus.cancelled]: User cancelled the flow
  /// - [GitHubSignInResultStatus.failed]: Sign-in failed with an error
  final GitHubSignInResultStatus status;
  /// Error message describing what went wrong.
  ///
  /// Only populated when [status] is [GitHubSignInResultStatus.failed]
  /// or [GitHubSignInResultStatus.cancelled].
  final String errorMessage;
  /// Complete user profile data fetched from GitHub.
  ///
  /// Contains user information including:
  /// - `login`: GitHub username
  /// - `name`: Display name
  /// - `email`: Primary verified email address
  /// - `avatar_url`: Profile picture URL
  /// - `bio`: User biography
  /// - `company`: Company name
  /// - `location`: User location
  /// - `public_repos`: Number of public repositories
  /// - `followers`: Number of followers
  /// - `following`: Number of users following
  /// - And many more GitHub profile fields
  ///
  /// Only available when [status] is [GitHubSignInResultStatus.ok].
  /// May be null if token was obtained but user data fetch failed.
  final Map<String, dynamic>? userData;

  /// Creates a new GitHub sign-in result.
  ///
  /// Parameters:
  /// - [status]: The result status
  /// - [token]: OAuth access token (optional)
  /// - [errorMessage]: Error description (optional)
  /// - [userData]: User profile data (optional)
  GitHubSignInResult(
    this.status, {
    this.token,
    this.errorMessage = '',
    this.userData,
  });
}

/// The status of a GitHub sign-in attempt.
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
