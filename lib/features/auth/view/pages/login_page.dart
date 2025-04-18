import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/widgets/loader.dart';
import 'package:reddit_clone/core/widgets/signin_button.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';
import 'package:reddit_clone/responsive.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  void signInAsGuest(WidgetRef ref, BuildContext context) {
    ref.read(authViewModelProvider.notifier).signInAsGuest(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authViewModelProvider);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(Constants.logoPath, height: 40),
        actions: [
          TextButton(
            onPressed: () => signInAsGuest(ref, context),
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
                    Image.asset(Constants.loginEmotePath, height: 400),
                    SizedBox(height: 50),
                    Responsive(child: SigninButton()),
                  ],
                ),
              ),
    );
  }
}
