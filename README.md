# dart-github-sign-in
Sign In With GitHub

## Requirements

- Flutter 3.0.0+
- Dart 3.0.0+

## Getting Started

Add package dependency

```yaml
github_sign_in: ^0.0.6
```

Perform `Sign In With GitHub`

```dart
final GitHubSignIn gitHubSignIn = GitHubSignIn(
        clientId: clientId,
        clientSecret: clientSecret,
        redirectUrl: redirectUrl);
    var result = await gitHubSignIn.signIn(context);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        print(result.token)
        break;

      case GitHubSignInResultStatus.cancelled:
      case GitHubSignInResultStatus.failed:
        print(result.errorMessage);
        break;
    }
```
