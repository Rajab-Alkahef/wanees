import 'package:flutter/material.dart';

class TalkingTextResultWidget extends StatelessWidget {
  const TalkingTextResultWidget({
    super.key,
    required this.wordSpoken,
  });

  final String wordSpoken;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: Container(
      padding: const EdgeInsets.all(20),
      child: Text(
        wordSpoken,
        style: const TextStyle(
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    ));
  }
}
