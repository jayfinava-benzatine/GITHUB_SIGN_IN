## [1.0.1] - 2025-09-17

### 🔧 Maintenance Release

- **ENHANCEMENT**: Updated documentation and package metadata
- **ENHANCEMENT**: Improved code organization and structure
- **FIX**: Minor bug fixes and performance improvements
- **MAINTENANCE**: Cleaned up changelog history for better readability

## [1.0.0] - 2024-01-17

### 🎉 Major Release - Complete Rewrite

- **NEW FEATURE**: Automatic user data fetching after successful authentication
- **NEW FEATURE**: Comprehensive user profile data including verified email
- **NEW FEATURE**: Enhanced error handling with detailed error messages
- **NEW FEATURE**: Complete API documentation with examples
- **NEW FEATURE**: Improved example app with user data display
- **ENHANCEMENT**: Better OAuth flow handling for both mobile and web
- **ENHANCEMENT**: Comprehensive README with setup instructions
- **ENHANCEMENT**: Added static analysis configuration
- **ENHANCEMENT**: Full pub.dev compliance with proper package structure
- **ENHANCEMENT**: Added comprehensive test coverage support
- **FIX**: Resolved all linting issues and warnings
- **FIX**: Improved null safety implementation
- **BREAKING CHANGE**: `GitHubSignInResult` now includes `userData` field
- **BREAKING CHANGE**: Updated minimum Flutter version to 3.0.0
- **BREAKING CHANGE**: Updated minimum Dart version to 3.0.0

### 📊 User Data Available

The package now automatically fetches and provides:

- User profile information (name, username, bio, etc.)
- Primary verified email address
- Repository and follower statistics
- Avatar URL and other profile details

### 🔧 Dependencies Updated

- `http`: ^1.5.0
- `webview_flutter`: ^4.13.0
- `url_launcher`: ^6.3.2
- Added `flutter_lints`: ^3.0.0 for better code quality

## [0.0.1] - 2024-01-17

- Implemented Sign In With Github.
