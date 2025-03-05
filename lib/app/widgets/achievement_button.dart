import 'package:flutter/material.dart';

class AchievementButton extends StatelessWidget {
  final VoidCallback onPressed; // Callback for button press

  const AchievementButton({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: Colors.black,
      child: const Icon(
        Icons.emoji_events, // Achievement icon
        color: Colors.white,
        size: 28.0,
      ),
    );
  }
}
