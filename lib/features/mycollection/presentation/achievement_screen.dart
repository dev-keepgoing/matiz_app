import 'package:flutter/material.dart';
import 'package:matiz/features/mycollection/data/models/achievement_model.dart';

class AchievementsScreen extends StatelessWidget {
  final List<Achievement> achievements;
  final String? rewardDescription;

  const AchievementsScreen({
    super.key,
    required this.achievements,
    this.rewardDescription,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "LOGROS",
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: Colors.white),
        ),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(
          color: Colors.white, // Sets the color of the back icon to white
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 32.0),
            // **Reward Description (Only if not null)**
            if (rewardDescription != null) ...[
              Text(rewardDescription!,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 32.0),
            ],

            // **Achievements List**
            Expanded(
              child: ListView.separated(
                itemCount: achievements.length,
                separatorBuilder: (context, index) {
                  return const SizedBox(
                      height: 16.0); // Adds spacing between items
                },
                itemBuilder: (context, index) {
                  final achievement = achievements[index];
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Achievement Icon
                      Container(
                        decoration: BoxDecoration(
                          color: achievement.completed
                              ? Colors.black
                              : Colors.grey[300], // Container color
                          shape:
                              BoxShape.circle, // Keeps the container circular
                        ),
                        padding: const EdgeInsets.all(
                            8.0), // Padding inside the container
                        child: Icon(
                          Icons.stars,
                          color: achievement.completed
                              ? Colors.white
                              : Colors.grey, // Icon color
                          size: 28.0, // Icon size
                        ),
                      ),
                      const SizedBox(width: 16.0),
                      // Title, Description, and Divider
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title and Description
                            Text(
                              achievement.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .displayLarge!
                                  .copyWith(
                                    fontSize: 18.0,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              achievement.criteria,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    fontSize: 14.0,
                                    color: Colors.grey[700],
                                  ),
                            ),
                            const SizedBox(height: 16.0),
                            // Divider (aligned with text)
                            const Divider(
                              thickness: 1.0,
                              color: Colors.grey, // Divider color
                              indent: 0.0, // Starts at the text
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
