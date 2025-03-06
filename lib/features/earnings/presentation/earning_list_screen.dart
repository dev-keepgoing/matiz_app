import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matiz/app/widgets/list_item.dart';
import 'package:matiz/features/earnings/data/models/monthly_earning.dart';

class EarningsListScreen extends StatelessWidget {
  final List<MonthlyEarning> earningsData;

  const EarningsListScreen({super.key, required this.earningsData});

  @override
  Widget build(BuildContext context) {
    // 🔹 Filter out entries where earnings are 0.0
    final filteredEarnings = earningsData.where((e) => e.earnings > 0).toList();

    if (filteredEarnings.isEmpty) {
      return const Center(child: Text("No earnings available."));
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      itemCount: filteredEarnings.length,
      itemBuilder: (context, index) {
        final earning = filteredEarnings[index];

        return ListItem(
          title:
              "\$${NumberFormat("#,##0.00", "en_US").format(earning.earnings)}",
          subtitle: earning.paidOn ?? 'IS NULL', // Display paid date

          backgroundColor:
              index.isOdd ? Colors.grey[200] : null, // Alternating row color
        );
      },
    );
  }
}
