import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// A Flutter widget that displays a GitHub OAuth sign-in page using WebView.
/// 
/// This widget handles the OAuth flow by loading the GitHub authorization URL
/// and capturing the redirect callback to extract the authorization code.
class GitHubSignInPage extends StatefulWidget {
  /// Creates a new GitHub sign-in page.
  /// 
  /// The [url] parameter is the GitHub OAuth authorization URL.
  /// The [redirectUrl] parameter is the callback URL configured in your GitHub OAuth app.
  /// The [clearCache] parameter determines whether to clear browser cache (defaults to true).
  /// The [title] parameter sets the page title.
  /// The [centerTitle] parameter determines whether to center the title.
  /// The [userAgent] parameter allows setting a custom user agent string.
  /// The [appBar] parameter allows providing a custom AppBar.
  const GitHubSignInPage(
      {required this.url,
      required this.redirectUrl,
      super.key,
      this.userAgent,
      this.clearCache = true,
      this.title = '',
      this.centerTitle,
      this.appBar});

  /// The GitHub OAuth authorization URL to load.
  final String url;
  
  /// The redirect URL configured in your GitHub OAuth app.
  final String redirectUrl;
  
  /// Whether to clear the browser cache before loading the page.
  final bool clearCache;
  
  /// The title to display in the app bar.
  final String title;
  
  /// Whether to center the title in the app bar.
  final bool? centerTitle;
  
  /// Custom user agent string for the WebView.
  final String? userAgent;
  
  /// Custom AppBar to use instead of the default one.
  final AppBar? appBar;

  @override
  State<GitHubSignInPage> createState() => _GitHubSignInPageState();
}

class _GitHubSignInPageState extends State<GitHubSignInPage> {
  static const String _userAgentMacOSX =
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/94.0.4606.61 Safari/537.36';

  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    // Initialize the WebViewController
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setUserAgent(widget.userAgent ?? _userAgentMacOSX)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) {
            if (url.contains('error=')) {
              Navigator.of(context).pop(
                Exception(Uri.parse(url).queryParameters['error']),
              );
            } else if (url.startsWith(widget.redirectUrl)) {
              Navigator.of(context).pop(url.replaceFirst('${widget.redirectUrl}?code=', '').trim());
            }
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));

    // Clear cache if requested
    if (widget.clearCache) {
      _controller.clearCache();
      WebViewCookieManager().clearCookies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: widget.appBar ??
            AppBar(
              title: Text(widget.title),
              centerTitle: widget.centerTitle,
            ),
        body: WebViewWidget(controller: _controller));
  }

  @override
  void dispose() {
    super.dispose();
  }
}
