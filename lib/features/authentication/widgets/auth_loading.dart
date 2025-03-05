import 'dart:async';
import 'package:flutter/material.dart';

class AuthenticationLoadingWidget extends StatefulWidget {
  const AuthenticationLoadingWidget({super.key});

  @override
  _AuthenticationLoadingWidgetState createState() =>
      _AuthenticationLoadingWidgetState();
}

class _AuthenticationLoadingWidgetState
    extends State<AuthenticationLoadingWidget> {
  int dotCount = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Update the dot count every 500ms.
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        dotCount = (dotCount + 1) % 4; // Cycles through 0, 1, 2, 3 dots
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black, // Dark semi-transparent overlay
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo Image
            Image.asset(
              'assets/images/matiz_white.png', // Ensure this image exists in your assets folder
              width: 120.0, // Adjust width
              height: 120.0, // Adjust height
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 16.0),

            // Animated Text: "CREANDO TU CUENTA DE MATIZ..."
            AnimatedTextWithDots(
                baseText: "BUSCANDO LOS DETALLES DE TU CUENTA"),

            const SizedBox(height: 16.0),
          ],
        ),
      ),
    );
  }
}

// Animated Text with Dots
class AnimatedTextWithDots extends StatefulWidget {
  final String baseText;

  const AnimatedTextWithDots({super.key, required this.baseText});

  @override
  _AnimatedTextWithDotsState createState() => _AnimatedTextWithDotsState();
}

class _AnimatedTextWithDotsState extends State<AnimatedTextWithDots> {
  int dotCount = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Update the dot count every 500ms.
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        dotCount = (dotCount + 1) % 4; // Cycles through 0, 1, 2, 3 dots
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(
        widget.baseText,
        style: Theme.of(context)
            .textTheme
            .headlineSmall
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      Text(
        '.' * dotCount,
        style: Theme.of(context)
            .textTheme
            .headlineMedium
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
      ),
    ]);
  }
}
