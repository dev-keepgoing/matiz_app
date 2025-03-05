import 'package:flutter/material.dart';
import 'package:matiz/features/mycollection/data/models/achievement_model.dart';
import 'package:matiz/features/mycollection/presentation/achievement_screen.dart';

class AchievementBar extends StatelessWidget {
  final double progress;
  final String? label;
  final List<Achievement> achievements;
  final int totalAchievements;
  final String? rewardDescription;

  const AchievementBar({
    super.key,
    required this.totalAchievements,
    required this.progress,
    this.label = "POSTER GRATIS",
    required this.achievements,
    this.rewardDescription =
        "PARA GANAR DEBES DE COMPLETAR TODOS LOS LOGROS PARA ESTA TEMPORADA.",
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigate when ANY part of the bar is tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AchievementsScreen(
              achievements: achievements,
              rewardDescription: rewardDescription,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black, // Black background for the entire widget
          borderRadius: BorderRadius.circular(0.0), // Rounded corners
        ),
        padding: const EdgeInsets.all(12.0), // Padding inside the widget
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Icon at the start
            const Icon(
              Icons.emoji_events,
              color: Colors
                  .white, // White icon color to contrast with black background
              size: 28.0,
            ),
            const SizedBox(width: 12.0), // Space between icon and progress bar
            // Progress bar with sections and label
            Expanded(
              child: Stack(
                clipBehavior:
                    Clip.none, // Allow icon to move outside the bounds
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Label above the progress bar
                      Text(
                        label ?? '',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: 4.0),
                      Row(
                        children: List.generate(
                          totalAchievements,
                          (index) => Expanded(
                            child: Container(
                              margin: EdgeInsets.only(
                                  right: index < totalAchievements - 1
                                      ? 2.0
                                      : 0.0),
                              height: 12.0,
                              decoration: BoxDecoration(
                                color: index <
                                        (progress * totalAchievements).floor()
                                    ? Colors.white
                                    : Colors.grey[700],
                                borderRadius: index == 0
                                    ? const BorderRadius.only(
                                        topLeft: Radius.circular(6.0),
                                        bottomLeft: Radius.circular(6.0),
                                      )
                                    : index == totalAchievements - 1
                                        ? const BorderRadius.only(
                                            topRight: Radius.circular(6.0),
                                            bottomRight: Radius.circular(6.0),
                                          )
                                        : BorderRadius.zero,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Positioned clickable icon (now redundant but kept for visual)
                  const Positioned(
                    top: 0.0, // Move the icon slightly upward
                    right: 0, // Align to the end of the progress bar
                    child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 20.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
