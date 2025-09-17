# GitHub Sign In

[![pub package](https://img.shields.io/pub/v/github_sign_in.svg)](https://pub.dev/packages/github_sign_in)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

A comprehensive Flutter package for GitHub OAuth authentication with automatic user data fetching. Supports both mobile and web platforms with a clean, easy-to-use API.

## ✨ Features

- 🔐 **Complete OAuth Flow**: Handles the entire GitHub OAuth authentication process
- 👤 **User Data Fetching**: Automatically retrieves user profile information and verified email
- 📱 **Cross-Platform**: Works on iOS, Android, and Web
- 🎨 **Customizable UI**: Configurable sign-in page with custom titles and styling
- 🔒 **Secure**: Follows OAuth 2.0 best practices
- 📊 **Rich User Info**: Access to profile data, repositories, followers, and more
- ⚡ **Easy Integration**: Simple API with comprehensive error handling

## 📋 Requirements

- Flutter 3.0.0+
- Dart 3.0.0+

## 🚀 Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  github_sign_in: ^1.0.0
```

Then run:

```bash
flutter pub get
```

## 🔧 Setup

### 1. Create a GitHub OAuth App

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Click "New OAuth App"
3. Fill in your application details:
   - **Application name**: Your app name
   - **Homepage URL**: Your app's homepage
   - **Authorization callback URL**: Your redirect URL (e.g., `https://yourapp.com/auth/callback`)
4. Note down your `Client ID` and `Client Secret`

### 2. Configure Platform-Specific Settings

#### iOS Configuration

Add the following to your `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLName</key>
        <string>github-oauth</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>your-custom-scheme</string>
        </array>
    </dict>
</array>
```

#### Android Configuration

Add the following to your `android/app/src/main/AndroidManifest.xml`:

```xml
<activity
    android:name="com.example.github_sign_in.CallbackActivity"
    android:exported="true">
    <intent-filter>
        <action android:name="android.intent.action.VIEW" />
        <category android:name="android.intent.category.DEFAULT" />
        <category android:name="android.intent.category.BROWSABLE" />
        <data android:scheme="your-custom-scheme" />
    </intent-filter>
</activity>
```

## 📖 Usage

### Basic Implementation

```dart
import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: GitHubSignInDemo(),
    );
  }
}

class GitHubSignInDemo extends StatefulWidget {
  @override
  _GitHubSignInDemoState createState() => _GitHubSignInDemoState();
}

class _GitHubSignInDemoState extends State<GitHubSignInDemo> {
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
    clientId: 'your-github-client-id',
    clientSecret: 'your-github-client-secret',
    redirectUrl: 'https://yourapp.com/auth/callback',
  );

  void _signInWithGitHub() async {
    final result = await gitHubSignIn.signIn(context);
    
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        print('✅ Sign in successful!');
        print('🔑 Access Token: ${result.token}');
        
        if (result.userData != null) {
          final user = result.userData!;
          print('👤 User: ${user['name']} (@${user['login']})');
          print('📧 Email: ${user['email']}');
          print('🏢 Company: ${user['company']}');
          print('📍 Location: ${user['location']}');
          print('📊 Public Repos: ${user['public_repos']}');
          print('👥 Followers: ${user['followers']}');
        }
        break;
        
      case GitHubSignInResultStatus.cancelled:
        print('❌ Sign in cancelled');
        break;
        
      case GitHubSignInResultStatus.failed:
        print('❌ Sign in failed: ${result.errorMessage}');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('GitHub Sign In Demo')),
      body: Center(
        child: ElevatedButton(
          onPressed: _signInWithGitHub,
          child: Text('Sign in with GitHub'),
        ),
      ),
    );
  }
}
```

### Advanced Configuration

```dart
final GitHubSignIn gitHubSignIn = GitHubSignIn(
  clientId: 'your-client-id',
  clientSecret: 'your-client-secret',
  redirectUrl: 'https://yourapp.com/callback',
  scope: 'user,repo,gist', // Custom scopes
  title: 'Connect to GitHub', // Custom page title
  centerTitle: true, // Center the title
  allowSignUp: true, // Allow new user registration
  clearCache: true, // Clear browser cache
  userAgent: 'MyApp/1.0', // Custom user agent
);
```

### Custom Sign-In Page

```dart
final result = await gitHubSignIn.signIn(
  context,
  appBar: AppBar(
    title: Text('Custom GitHub Sign In'),
    backgroundColor: Colors.black,
    foregroundColor: Colors.white,
  ),
);
```

## 📊 Available User Data

After successful authentication, the `userData` field contains:

| Field | Type | Description |
|-------|------|-------------|
| `login` | String | GitHub username |
| `id` | int | User ID |
| `name` | String | Display name |
| `email` | String | Primary verified email |
| `avatar_url` | String | Profile picture URL |
| `bio` | String | User biography |
| `company` | String | Company name |
| `location` | String | User location |
| `blog` | String | Website/blog URL |
| `public_repos` | int | Number of public repositories |
| `public_gists` | int | Number of public gists |
| `followers` | int | Number of followers |
| `following` | int | Number of users following |
| `created_at` | String | Account creation date |
| `updated_at` | String | Last profile update |

## 🔐 Scopes

Configure the required permissions by setting the `scope` parameter:

- `user` - Read user profile data
- `user:email` - Read user email addresses
- `repo` - Access repositories
- `gist` - Access gists
- `read:org` - Read organization membership

Example:
```dart
GitHubSignIn(
  // ... other parameters
  scope: 'user,user:email,repo',
)
```

## 🎨 Customization

### Sign-In Page Customization

```dart
GitHubSignIn(
  // ... other parameters
  title: 'Connect Your GitHub Account',
  centerTitle: false,
  allowSignUp: true,
  clearCache: true,
  userAgent: 'MyApp/1.0.0',
)
```

### Custom AppBar

```dart
await gitHubSignIn.signIn(
  context,
  appBar: AppBar(
    title: Text('GitHub Authentication'),
    backgroundColor: Color(0xFF24292e), // GitHub dark color
    elevation: 0,
  ),
);
```

## 🔍 Error Handling

The package provides comprehensive error handling:

```dart
final result = await gitHubSignIn.signIn(context);

switch (result.status) {
  case GitHubSignInResultStatus.ok:
    // Handle successful sign-in
    if (result.userData == null) {
      // Token obtained but user data fetch failed
      print('Warning: Could not fetch user data');
    }
    break;
    
  case GitHubSignInResultStatus.cancelled:
    // User cancelled the sign-in process
    showSnackBar('Sign-in cancelled');
    break;
    
  case GitHubSignInResultStatus.failed:
    // Sign-in failed with error
    showErrorDialog('Sign-in failed: ${result.errorMessage}');
    break;
}
```

## 🌐 Web Support

The package fully supports Flutter Web. The OAuth flow will open in the same browser window and automatically handle the callback.

## 🧪 Testing

Run the example app to test the integration:

```bash
cd example
flutter run
```

## 📝 Example

Check out the [example](example/) directory for a complete implementation showing:

- Basic sign-in flow
- User data display
- Error handling
- Custom UI elements

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request. For major changes, please open an issue first to discuss what you would like to change.

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🐛 Issues

If you encounter any issues, please file them on the [GitHub Issues](https://github.com/jayfinava-benzatine/GITHUB_SIGN_IN/issues) page.

## 📚 Additional Resources

- [GitHub OAuth Documentation](https://docs.github.com/en/developers/apps/building-oauth-apps)
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Packages](https://pub.dev)
