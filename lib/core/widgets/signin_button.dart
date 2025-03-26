import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_clone/core/constants/constants.dart';
import 'package:reddit_clone/core/theme/pallete.dart';
import 'package:reddit_clone/features/auth/view_model/auth_view_model.dart';

class SigninButton extends ConsumerWidget {
  const SigninButton({super.key});

  void signInWithGoogle(WidgetRef ref, BuildContext context) {
    ref.read(authViewModelProvider.notifier).signInWithGoogle(context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ElevatedButton.icon(
      onPressed: () {
        signInWithGoogle(ref, context);
      },
      icon: Image.asset(Constants.googlePath, width: 35),
      label: Text(
        'Continue with Google',
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.greyColor,
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}
