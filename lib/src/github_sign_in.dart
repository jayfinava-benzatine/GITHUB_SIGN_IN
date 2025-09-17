import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'github_sign_in_page.dart';
import 'github_sign_in_result.dart';

class GitHubSignIn {
  final String clientId;
  final String clientSecret;
  final String redirectUrl;
  final String scope;
  final String title;
  final bool? centerTitle;
  final bool allowSignUp;
  final bool clearCache;
  final String? userAgent;

  final String _githubAuthorizedUrl = "https://github.com/login/oauth/authorize";
  final String _githubAccessTokenUrl = "https://github.com/login/oauth/access_token";

  GitHubSignIn({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUrl,
    this.scope = "user,gist,user:email",
    this.title = "",
    this.centerTitle,
    this.allowSignUp = true,
    this.clearCache = true,
    this.userAgent,
  });

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
        errorMessage: "Sign In attempt has been cancelled.",
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
      headers: {"Accept": "application/json"},
      body: {"client_id": clientId, "client_secret": clientSecret, "code": code},
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
          errorMessage: "Access token not found in response",
        );
      }
    } else {
      result = GitHubSignInResult(
        GitHubSignInResultStatus.failed,
        errorMessage: "Unable to obtain token. Received: ${response.statusCode}",
      );
    }

    return result;
  }

  String _generateAuthorizedUrl() {
    return "$_githubAuthorizedUrl?" + "client_id=$clientId" + "&redirect_uri=$redirectUrl" + "&scope=$scope" + "&allow_signup=$allowSignUp";
  }

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
        print('❌ Failed to fetch user data: ${userResponse.statusCode}');
        return null;
      }

      final userData = json.decode(utf8.decode(userResponse.bodyBytes)) as Map<String, dynamic>;

      // Fetch user emails
      final emailsResponse = await http.get(
        Uri.parse(emailsApiUrl),
        headers: headers,
      );

      if (emailsResponse.statusCode != 200) {
        print('❌ Failed to fetch user emails: ${emailsResponse.statusCode}');
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
        print('❌ No primary verified email found');
        return null;
      }

      // Add primary email to user data
      userData['email'] = primaryEmail;

      return userData;
    } catch (e) {
      print('❌ HTTP Request failed: $e');
      return null;
    }
  }
}
