import 'dart:async';
import 'package:flutter/material.dart';

class AnimatedEarningsText extends StatefulWidget {
  const AnimatedEarningsText({super.key});

  @override
  _AnimatedEarningsTextState createState() => _AnimatedEarningsTextState();
}

class _AnimatedEarningsTextState extends State<AnimatedEarningsText> {
  final String baseText = "Buscando tus ganancias";
  int dotCount = 0;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Update the dot count every 500ms.
    timer = Timer.periodic(const Duration(milliseconds: 500), (timer) {
      setState(() {
        dotCount = (dotCount + 1) % 4; // cycles through 0, 1, 2, 3
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
    // Use the text style from the current theme.
    final textStyle = Theme.of(context).textTheme.displayLarge!;

    // Calculate the maximum width required by the text with the maximum number of dots.
    final maxText = '$baseText...'; // assuming 3 dots is the max
    final textPainter = TextPainter(
      text: TextSpan(text: maxText, style: textStyle),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    final maxWidth = textPainter.width;

    // Build the current text with the current number of dots.
    final currentText = '$baseText${'.' * dotCount}';

    return SizedBox(
      width: maxWidth, // Fixes the width to the maximum width needed.
      child: Text(
        currentText,
        key: ValueKey<int>(dotCount), // Helps AnimatedSwitcher detect changes.
        style: textStyle,
      ),
    );
  }
}
