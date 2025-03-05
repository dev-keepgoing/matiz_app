import 'package:flutter/material.dart';
import 'package:matiz/app/themes/theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerSingle extends StatelessWidget {
  final double height;
  final double radious;

  const ShimmerSingle({
    super.key,
    this.height = 200, // Default height
    this.radious = AppTheme.cardBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Container(
          height: height, // Allow customization of height
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(0),
          ),
        ),
      ),
    );
  }
}
