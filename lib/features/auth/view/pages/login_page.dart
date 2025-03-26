import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/widgets/loader.dart';
import 'package:reddit_clone/core/widgets/signin_button.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.logoPath, height: 40),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Skip', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body:
          isLoading
              ? Loader()
              : Padding(
                padding: const EdgeInsets.only(top: 40, left: 24, right: 24),
                child: Column(
                  children: [
                    Text(
                      'Dive into anything',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 40),
                    Image.asset(Constants.loginEmotePath),
                    SizedBox(height: 50),
                    SigninButton(),
                  ],
                ),
              ),
    );
  }
}
