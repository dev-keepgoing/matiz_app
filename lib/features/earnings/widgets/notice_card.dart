import 'package:flutter/material.dart';

class NoticeCard extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onTap;
  final double arrowHeigth;
  final double arrowWidth;

  const NoticeCard(
      {super.key,
      required this.title,
      required this.description,
      this.onTap,
      this.arrowHeigth = 32,
      this.arrowWidth = 64});

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) return const SizedBox.shrink();
    return GestureDetector(
      onTap: onTap, // Enable tap if navigation is provided
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Colors.black, width: 2.0),
        ),
        margin: const EdgeInsets.symmetric(horizontal: 0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 📝 Title with Arrow
              Row(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // Ensures arrow is at the end
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.displayLarge,
                      overflow: TextOverflow.ellipsis, // Prevents overflow
                    ),
                  ),
                  if (onTap != null)
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0), // Space between text & arrow
                      child: Image.asset(
                        'assets/icons/scribble_arrow.png', // Matches the provided design
                        height: arrowHeigth,
                        width: arrowWidth,
                      ),
                    ),
                ],
              ),
              const SizedBox(
                  height: 8), // Spacing between title and description
              Text(
                description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
