/// A comprehensive Flutter package for GitHub OAuth authentication.
///
/// This library provides a simple and secure way to implement GitHub OAuth
/// authentication in Flutter applications. It handles the complete OAuth flow
/// and automatically fetches user profile data.
///
/// ## Features
///
/// - Complete GitHub OAuth 2.0 flow
/// - Automatic user data fetching
/// - Cross-platform support (iOS, Android, Web)
/// - Customizable UI
/// - Comprehensive error handling
/// - Secure token management
///
/// ## Quick Start
///
/// ```dart
/// import 'package:github_sign_in/github_sign_in.dart';
///
/// final gitHubSignIn = GitHubSignIn(
///   clientId: 'your-client-id',
///   clientSecret: 'your-client-secret',
///   redirectUrl: 'https://yourapp.com/callback',
/// );
///
/// final result = await gitHubSignIn.signIn(context);
/// if (result.status == GitHubSignInResultStatus.ok) {
///   print('Welcome ${result.userData!['name']}!');
/// }
/// ```
///
/// ## Main Classes
///
/// - [GitHubSignIn]: The main authentication service
/// - [GitHubSignInResult]: Contains the authentication result
/// - [GitHubSignInResultStatus]: Enum for result status
library github_oauth_signin;

export 'src/github_sign_in.dart';
export 'src/github_sign_in_result.dart';
