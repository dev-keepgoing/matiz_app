import 'package:flutter/material.dart';

class ScreenWrapper extends StatelessWidget {
  final String title;
  final Widget body;

  const ScreenWrapper({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      ),
      body: body,
    );
  }
}
