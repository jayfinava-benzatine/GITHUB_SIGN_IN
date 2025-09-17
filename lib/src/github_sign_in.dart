import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'github_sign_in_page.dart';
import 'github_sign_in_result.dart';

/// A comprehensive GitHub OAuth authentication service.
///
/// This class handles the complete GitHub OAuth flow including:
/// - User authorization
/// - Access token exchange
/// - User profile data fetching
/// - Email verification
///
/// Supports both mobile and web platforms with customizable UI options.
///
/// Example usage:
/// ```dart
/// final gitHubSignIn = GitHubSignIn(
///   clientId: 'your-client-id',
///   clientSecret: 'your-client-secret',
///   redirectUrl: 'https://yourapp.com/callback',
/// );
///
/// final result = await gitHubSignIn.signIn(context);
/// if (result.status == GitHubSignInResultStatus.ok) {
///   print('User: ${result.userData!['name']}');
///   print('Email: ${result.userData!['email']}');
/// }
/// ```
class GitHubSignIn {
  /// The GitHub OAuth application client ID.
  ///
  /// Obtain this from your GitHub OAuth app settings at:
  /// https://github.com/settings/developers
  final String clientId;
  /// The GitHub OAuth application client secret.
  ///
  /// Keep this secure and never expose it in client-side code.
  /// Obtain this from your GitHub OAuth app settings.
  final String clientSecret;
  /// The redirect URL configured in your GitHub OAuth app.
  ///
  /// This must match exactly with the URL configured in your
  /// GitHub OAuth application settings.
  final String redirectUrl;
  /// The OAuth scopes to request access for.
  ///
  /// Common scopes include:
  /// - `user` - Read user profile data
  /// - `user:email` - Read user email addresses
  /// - `repo` - Access repositories
  /// - `gist` - Access gists
  ///
  /// Default: 'user,gist,user:email'
  final String scope;
  /// The title to display on the sign-in page.
  ///
  /// If empty, no title will be shown.
  final String title;
  /// Whether to center the title on the sign-in page.
  ///
  /// If null, uses the platform default.
  final bool? centerTitle;
  /// Whether to allow new users to sign up during the OAuth flow.
  ///
  /// Default: true
  final bool allowSignUp;
  /// Whether to clear the browser cache before starting the OAuth flow.
  ///
  /// This ensures a fresh sign-in experience but may require
  /// users to re-enter credentials.
  ///
  /// Default: true
  final bool clearCache;
  /// Custom user agent string for the OAuth requests.
  ///
  /// If null, uses the default user agent.
  final String? userAgent;

  final String _githubAuthorizedUrl = 'https://github.com/login/oauth/authorize';
  final String _githubAccessTokenUrl = 'https://github.com/login/oauth/access_token';

  /// Creates a new GitHub OAuth authentication service.
  ///
  /// Required parameters:
  /// - [clientId]: Your GitHub OAuth app client ID
  /// - [clientSecret]: Your GitHub OAuth app client secret
  /// - [redirectUrl]: The callback URL configured in your GitHub app
  ///
  /// Optional parameters:
  /// - [scope]: OAuth scopes to request (default: 'user,gist,user:email')
  /// - [title]: Title for the sign-in page
  /// - [centerTitle]: Whether to center the title
  /// - [allowSignUp]: Allow new user registration (default: true)
  /// - [clearCache]: Clear browser cache before sign-in (default: true)
  /// - [userAgent]: Custom user agent string
  GitHubSignIn({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    this.scope = 'user,gist,user:email',
    this.title = '',
    this.centerTitle,
    this.allowSignUp = true,
    this.clearCache = true,
    this.userAgent,
  });

  /// Initiates the GitHub OAuth sign-in flow.
  ///
  /// This method handles the complete authentication process:
  /// 1. Opens the GitHub authorization page
  /// 2. Exchanges the authorization code for an access token
  /// 3. Fetches the user's profile data and verified email
  ///
  /// Parameters:
  /// - [context]: The build context for navigation
  /// - [appBar]: Optional custom app bar for the sign-in page
  ///
  /// Returns a [GitHubSignInResult] containing:
  /// - [status]: The result status (ok, cancelled, or failed)
  /// - [token]: The OAuth access token (if successful)
  /// - [userData]: Complete user profile data (if successful)
  /// - [errorMessage]: Error details (if failed)
  ///
  /// Example:
  /// ```dart
  /// final result = await gitHubSignIn.signIn(context);
  /// switch (result.status) {
  ///   case GitHubSignInResultStatus.ok:
  ///     print('Welcome ${result.userData!['name']}!');
  ///     break;
  ///   case GitHubSignInResultStatus.cancelled:
  ///     print('Sign-in cancelled');
  ///     break;
  ///   case GitHubSignInResultStatus.failed:
  ///     print('Error: ${result.errorMessage}');
  ///     break;
  /// }
  /// ```
  Future<GitHubSignInResult> signIn(BuildContext context, {AppBar? appBar}) async {
    // let's authorize
    var authorizedResult;

    if (kIsWeb) {
      authorizedResult = await launchUrl(
        Uri.parse(_generateAuthorizedUrl()),
        webOnlyWindowName: '_self',
      );
      //push data into authorized result somehow
    } else {
      authorizedResult = await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => GitHubSignInPage(
            url: _generateAuthorizedUrl(),
            redirectUrl: redirectUrl,
            userAgent: userAgent,
            clearCache: clearCache,
            title: title,
            centerTitle: centerTitle,
            appBar: appBar,
          ),
        ),
      );
    }

    if (authorizedResult == null || authorizedResult.toString().contains('access_denied')) {
      return GitHubSignInResult(
        GitHubSignInResultStatus.cancelled,
        errorMessage: 'Sign In attempt has been cancelled.',
      );
    } else if (authorizedResult is Exception) {
      return GitHubSignInResult(
        GitHubSignInResultStatus.failed,
        errorMessage: authorizedResult.toString(),
      );
    }

    // exchange for access token
    String code = authorizedResult;
    var response = await http.post(
      Uri.parse(_githubAccessTokenUrl),
      headers: {'Accept': 'application/json'},
      body: {'client_id': clientId, 'client_secret': clientSecret, 'code': code},
    );

    GitHubSignInResult result;
    if (response.statusCode == 200) {
      var body = json.decode(utf8.decode(response.bodyBytes));
      String? accessToken = body["access_token"];

      if (accessToken != null) {
        // Fetch user data from GitHub API
        Map<String, dynamic>? userData = await _fetchUserDataFromGitHub(accessToken);

        result = GitHubSignInResult(
          GitHubSignInResultStatus.ok,
          token: accessToken,
          userData: userData,
        );
      } else {
        result = GitHubSignInResult(
          GitHubSignInResultStatus.failed,
          errorMessage: 'Access token not found in response',
        );
      }
    } else {
      result = GitHubSignInResult(
        GitHubSignInResultStatus.failed,
        errorMessage: 'Unable to obtain token. Received: ${response.statusCode}',
      );
    }

    return result;
  }

  String _generateAuthorizedUrl() => 
    '$_githubAuthorizedUrl?'
    'client_id=$clientId'
    '&redirect_uri=$redirectUrl'
    '&scope=$scope'
    '&allow_signup=$allowSignUp';

  /// Uses the access token to fetch the authenticated user's data from the GitHub API.
  Future<Map<String, dynamic>?> _fetchUserDataFromGitHub(String accessToken) async {
    const String userApiUrl = 'https://api.github.com/user';
    const String emailsApiUrl = 'https://api.github.com/user/emails';

    final Map<String, String> headers = {
      'Authorization': 'Bearer $accessToken',
      'Accept': 'application/json',
    };

    try {
      // Fetch user data
      final userResponse = await http.get(
        Uri.parse(userApiUrl),
        headers: headers,
      );

      if (userResponse.statusCode != 200) {
        // Failed to fetch user data
        debugPrint('❌ Failed to fetch user data: ${userResponse.statusCode}');
        return null;
      }

      final userData = json.decode(utf8.decode(userResponse.bodyBytes)) as Map<String, dynamic>;

      // Fetch user emails
      final emailsResponse = await http.get(
        Uri.parse(emailsApiUrl),
        headers: headers,
      );

      if (emailsResponse.statusCode != 200) {
        // Failed to fetch user emails
        debugPrint('❌ Failed to fetch user emails: ${emailsResponse.statusCode}');
        return null;
      }

      final emailsData = json.decode(utf8.decode(emailsResponse.bodyBytes)) as List<dynamic>;

      // Find primary verified email
      String? primaryEmail;
      for (final email in emailsData) {
        if (email is Map<String, dynamic> && email['primary'] == true && email['verified'] == true) {
          primaryEmail = email['email'] as String?;
          break;
        }
      }

      if (primaryEmail == null) {
        // No primary verified email found
        debugPrint('❌ No primary verified email found');
        return null;
      }

      // Add primary email to user data
      userData['email'] = primaryEmail;

      return userData;
    } on Exception catch (e) {
      // HTTP Request failed
      debugPrint('❌ HTTP Request failed: $e');
      return null;
    }
  }
}
