import 'package:flutter/material.dart';

class ListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String? imageUrl;
  final Color? backgroundColor;

  const ListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.imageUrl,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6.0), // Space between items
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color:
            backgroundColor ?? Colors.white, // ✅ Use provided color or default
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.black,
          width: 2.0,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 🖼 Optional Image (Only Shows if Provided)
          if (imageUrl != null)
            ClipOval(
              child: Image.network(
                imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              ),
            ),
          if (imageUrl != null) const SizedBox(width: 12), // Spacing

          // 📌 Text Content (Title + Optional Subtitle)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 🏷 Title (Always Required)
                Text(title,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        )),

                // 📌 Optional Subtitle (Hidden if null)
                if (subtitle != null)
                  Text(subtitle!, style: Theme.of(context).textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
