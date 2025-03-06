import 'package:flutter/material.dart';
import 'package:matiz/features/earnings/widgets/notice_card.dart';

class PayoutNotice extends StatelessWidget {
  final String title;
  final String description;

  const PayoutNotice({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) return const SizedBox.shrink();
    return NoticeCard(
      title: title,
      description: description,
    );
  }
}
