import 'package:flutter/material.dart';
import 'package:github_oauth_signin/github_oauth_signin.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const MyHomePage(title: 'Flutter GitHub Demo'),
      );
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({required this.title, super.key});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
    clientId: 'abd975f97f953c6e1843',
    clientSecret: '709fb6441354c8d148248ae2cab0673b4ce7f1d5',
    redirectUrl: 'https://l2t-flutter.firebaseapp.com/__/auth/handler',
    title: 'GitHub Connection',
    centerTitle: false,
  );

  Future<void> _gitHubSignIn(BuildContext context) async {
    final GitHubSignInResult result = await gitHubSignIn.signIn(context);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        debugPrint('✅ GitHub Sign In Successful!');
        debugPrint('🔑 Access Token: ${result.token}');

        if (result.userData != null) {
          debugPrint('👤 User Data:');
          debugPrint('   - Name: ${result.userData!['name']}');
          debugPrint('   - Email: ${result.userData!['email']}');
          debugPrint('   - Username: ${result.userData!['login']}');
          debugPrint('   - Avatar: ${result.userData!['avatar_url']}');
          debugPrint('   - Bio: ${result.userData!['bio']}');
          debugPrint('   - Public Repos: ${result.userData!['public_repos']}');
          debugPrint('   - Followers: ${result.userData!['followers']}');
          debugPrint('   - Following: ${result.userData!['following']}');

          // Show success dialog with user info
          // ignore: use_build_context_synchronously
          _showUserInfoDialog(context, result.userData!);
        } else {
          debugPrint('⚠️ User data could not be fetched');
        }
        break;

      case GitHubSignInResultStatus.cancelled:
        debugPrint('❌ GitHub Sign In Cancelled');
        debugPrint(result.errorMessage);
        break;

      case GitHubSignInResultStatus.failed:
        debugPrint('❌ GitHub Sign In Failed');
        debugPrint(result.errorMessage);
        break;
    }
  }

  void _showUserInfoDialog(BuildContext context, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('GitHub User Info'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (userData['avatar_url'] != null)
                Center(
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(userData['avatar_url']),
                  ),
                ),
              const SizedBox(height: 16),
              _buildInfoRow('Name', userData['name']),
              _buildInfoRow('Username', userData['login']),
              _buildInfoRow('Email', userData['email']),
              _buildInfoRow('Bio', userData['bio']),
              _buildInfoRow('Public Repos', userData['public_repos']?.toString()),
              _buildInfoRow('Followers', userData['followers']?.toString()),
              _buildInfoRow('Following', userData['following']?.toString()),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              _gitHubSignIn(context);
            },
            child: const Text('GitHub Connection'),
          ),
        ),
      );
}
