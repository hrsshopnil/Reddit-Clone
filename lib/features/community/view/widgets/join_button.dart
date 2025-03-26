import 'package:flutter/material.dart';

class JoinButton extends StatelessWidget {
  final String text;
  const JoinButton({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: Colors.blue, width: 0.5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      ),
      child: Text(text, style: TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}
