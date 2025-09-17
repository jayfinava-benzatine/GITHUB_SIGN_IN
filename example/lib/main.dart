import 'package:flutter/material.dart';
import 'package:github_sign_in/github_sign_in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter GitHub Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: 'abd975f97f953c6e1843',
      clientSecret: '709fb6441354c8d148248ae2cab0673b4ce7f1d5',
      redirectUrl: 'https://l2t-flutter.firebaseapp.com/__/auth/handler',
      title: 'GitHub Connection',
      centerTitle: false,
  );

  void _gitHubSignIn(BuildContext context) async {
    var result = await gitHubSignIn.signIn(context);
    switch (result.status) {
      case GitHubSignInResultStatus.ok:
        print('✅ GitHub Sign In Successful!');
        print('🔑 Access Token: ${result.token}');
        
        if (result.userData != null) {
          print('👤 User Data:');
          print('   - Name: ${result.userData!['name']}');
          print('   - Email: ${result.userData!['email']}');
          print('   - Username: ${result.userData!['login']}');
          print('   - Avatar: ${result.userData!['avatar_url']}');
          print('   - Bio: ${result.userData!['bio']}');
          print('   - Public Repos: ${result.userData!['public_repos']}');
          print('   - Followers: ${result.userData!['followers']}');
          print('   - Following: ${result.userData!['following']}');
          
          // Show success dialog with user info
          _showUserInfoDialog(context, result.userData!);
        } else {
          print('⚠️ User data could not be fetched');
        }
        break;

      case GitHubSignInResultStatus.cancelled:
        print('❌ GitHub Sign In Cancelled');
        print(result.errorMessage);
        break;
        
      case GitHubSignInResultStatus.failed:
        print('❌ GitHub Sign In Failed');
        print(result.errorMessage);
        break;
    }
  }

  void _showUserInfoDialog(BuildContext context, Map<String, dynamic> userData) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('GitHub User Info'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
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
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildInfoRow(String label, String? value) {
    if (value == null || value.isEmpty) return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _gitHubSignIn(context);
          },
          child: Text("GitHub Connection"),
        ),
      ),
    );
  }
}
