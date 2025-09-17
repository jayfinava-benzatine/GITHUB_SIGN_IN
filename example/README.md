# GitHub Sign In Example

This example demonstrates how to use the `github_sign_in` package to implement GitHub OAuth authentication in a Flutter application.

## Features Demonstrated

- ✅ Basic GitHub OAuth authentication
- ✅ User data fetching and display
- ✅ Error handling for different scenarios
- ✅ Custom UI with user information dialog
- ✅ Comprehensive logging for debugging

## Setup Instructions

### 1. Create a GitHub OAuth App

1. Go to [GitHub Developer Settings](https://github.com/settings/developers)
2. Click "New OAuth App"
3. Fill in your application details:
   - **Application name**: GitHub Sign In Example
   - **Homepage URL**: `http://localhost`
   - **Authorization callback URL**: `https://l2t-flutter.firebaseapp.com/__/auth/handler`

### 2. Update Configuration

Replace the placeholder values in `lib/main.dart`:

```dart
final GitHubSignIn gitHubSignIn = GitHubSignIn(
  clientId: 'your-actual-client-id',        // Replace with your Client ID
  clientSecret: 'your-actual-client-secret', // Replace with your Client Secret
  redirectUrl: 'your-actual-redirect-url',   // Replace with your redirect URL
);
```

### 3. Run the Example

```bash
flutter pub get
flutter run
```

## What This Example Shows

### Authentication Flow
1. **Sign In Button**: Tap to start the GitHub OAuth flow
2. **GitHub Authorization**: Redirects to GitHub for user consent
3. **Token Exchange**: Automatically exchanges code for access token
4. **User Data Fetch**: Retrieves user profile and email information
5. **Result Display**: Shows user information in a dialog

### User Data Available

The example displays the following user information:
- **Name**: User's display name
- **Username**: GitHub username (@username)
- **Email**: Primary verified email address
- **Avatar**: Profile picture
- **Bio**: User biography
- **Company**: Company information
- **Location**: User location
- **Public Repositories**: Number of public repos
- **Followers**: Follower count
- **Following**: Following count

### Error Handling

The example demonstrates proper error handling for:
- **User Cancellation**: When user cancels the OAuth flow
- **Authentication Failure**: When OAuth fails
- **Network Issues**: When API requests fail
- **Missing Data**: When user data cannot be fetched

## Code Structure

```
lib/
├── main.dart           # Main application entry point
└── ...

Key Components:
- GitHubSignIn setup with configuration
- Sign-in button and flow initiation
- Result handling with switch statement
- User info dialog with formatted display
- Error handling and logging
```

## Customization Options

The example shows various customization options:

```dart
GitHubSignIn(
  clientId: 'your-client-id',
  clientSecret: 'your-client-secret',
  redirectUrl: 'your-redirect-url',
  scope: 'user,user:email',           // Custom scopes
  title: 'GitHub Connection',         // Custom title
  centerTitle: false,                 // Title alignment
  allowSignUp: true,                  // Allow registration
  clearCache: true,                   // Clear browser cache
);
```

## Testing

1. **Successful Sign-In**: Use valid GitHub credentials
2. **Cancellation**: Close the browser/webview during OAuth
3. **Network Issues**: Test with poor connectivity
4. **Invalid Credentials**: Test with wrong client ID/secret

## Troubleshooting

### Common Issues

1. **"Invalid client_id"**: Check your GitHub OAuth app client ID
2. **"Redirect URI mismatch"**: Ensure redirect URL matches GitHub app settings
3. **"User data not fetched"**: Check if user has verified email address
4. **Web platform issues**: Ensure proper CORS configuration

### Debug Output

The example provides comprehensive console output:
```
✅ GitHub Sign In Successful!
🔑 Access Token: ghp_xxxxxxxxxxxx
👤 User Data:
   - Name: John Doe
   - Email: john@example.com
   - Username: johndoe
   - Avatar: https://avatars.githubusercontent.com/...
   - Bio: Software Developer
   - Public Repos: 25
   - Followers: 100
   - Following: 50
```

## Next Steps

After running this example:
1. Integrate the package into your own app
2. Customize the UI to match your design
3. Store the access token securely
4. Use the token for GitHub API calls
5. Implement proper session management

## Resources

- [GitHub OAuth Documentation](https://docs.github.com/en/developers/apps/building-oauth-apps)
- [GitHub Sign In Package](https://pub.dev/packages/github_sign_in)
- [Flutter Documentation](https://flutter.dev/docs)
