## [1.0.0] - 2024-01-17

### 🎉 Major Release - Complete Rewrite

* **NEW FEATURE**: Automatic user data fetching after successful authentication
* **NEW FEATURE**: Comprehensive user profile data including verified email
* **NEW FEATURE**: Enhanced error handling with detailed error messages
* **NEW FEATURE**: Complete API documentation with examples
* **NEW FEATURE**: Improved example app with user data display
* **ENHANCEMENT**: Better OAuth flow handling for both mobile and web
* **ENHANCEMENT**: Comprehensive README with setup instructions
* **ENHANCEMENT**: Added static analysis configuration
* **ENHANCEMENT**: Full pub.dev compliance with proper package structure
* **ENHANCEMENT**: Added comprehensive test coverage support
* **FIX**: Resolved all linting issues and warnings
* **FIX**: Improved null safety implementation
* **BREAKING CHANGE**: `GitHubSignInResult` now includes `userData` field
* **BREAKING CHANGE**: Updated minimum Flutter version to 3.0.0
* **BREAKING CHANGE**: Updated minimum Dart version to 3.0.0

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

## [0.0.6] - v0.0.6

* **BREAKING CHANGES**: Updated to latest Flutter/Dart SDK (3.0.0+)
* Updated webview_flutter to 4.13.0 with new WebViewController API
* Updated url_launcher to 6.3.2 with new launchUrl API
* Updated http to 1.5.0
* Fixed all deprecation warnings and analyzer issues
* Updated example app to use latest Flutter conventions
* Improved null safety implementation

## [0.0.5-dev.4] - v0.0.5-dev.4

* Update dependencies including webview_flutter to 3.0.0

## [0.0.5-dev.3] - v0.0.5-dev.3

* Fix possibility to clear cache

## [0.0.5-dev.2] - v0.0.5-dev.2

* Fix cancel button

## [0.0.5-dev.1] - v0.0.5-dev.1

* Add null safety

## [0.0.4] - v0.0.4

* Update dependencies

## [0.0.3] - v0.0.3

* Improve error handling

## [0.0.2] - v0.0.2

* Allow to cache session

## [0.0.1] - v0.0.1

* Implement Sign In With GitHub
