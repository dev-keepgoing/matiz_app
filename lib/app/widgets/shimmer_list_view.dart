import 'package:flutter/material.dart';
import 'package:matiz/app/themes/theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerListView extends StatelessWidget {
  final int itemCount;
  final double height;

  const ShimmerListView({
    super.key,
    this.itemCount = 6, // Default placeholder items
    this.height = 600, // Default height
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: height, // Allow customization of height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(AppTheme.cardBorderRadius),
              ),
            ),
          ),
        );
      },
    );
  }
}
