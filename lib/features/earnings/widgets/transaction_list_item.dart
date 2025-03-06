import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:matiz/app/widgets/list_item.dart';
import 'package:matiz/features/earnings/data/models/transaction.dart';
import 'package:matiz/features/earnings/data/repositories/transaction_repository.dart';
import '../bloc/transaction_bloc.dart';
import '../bloc/transaction_event.dart';
import '../bloc/transaction_state.dart';

class TransactionListScreen extends StatelessWidget {
  const TransactionListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransactionBloc(
          transactionRepository:
              RepositoryProvider.of<TransactionRepository>(context))
        ..add(FetchTransactions()),
      child: BlocBuilder<TransactionBloc, TransactionState>(
        builder: (context, state) {
          if (state is TransactionLoading) {
            return _buildShimmerLoader(); // ✅ Show shimmer effect while loading
          } else if (state is TransactionError) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is TransactionLoaded) {
            final transactions = state.transactions;

            if (transactions.isEmpty) {
              return const Center(child: Text("No transactions available."));
            }

            // 🏷️ Group transactions by date
            final Map<String, List<Transaction>> groupedTransactions = {};
            final today = DateTime.now();
            final yesterday = today.subtract(const Duration(days: 1));

            for (var transaction in transactions) {
              final transactionDate = DateTime.parse(transaction.date);
              String formattedDate;

              if (_isSameDay(transactionDate, today)) {
                formattedDate = "HOY";
              } else if (_isSameDay(transactionDate, yesterday)) {
                formattedDate = "AYER";
              } else {
                formattedDate = DateFormat('MMM dd, yyyy')
                    .format(transactionDate)
                    .toUpperCase();
              }

              groupedTransactions
                  .putIfAbsent(formattedDate, () => [])
                  .add(transaction);
            }

            return ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              itemCount: groupedTransactions.length,
              itemBuilder: (context, index) {
                String dateKey = groupedTransactions.keys.elementAt(index);
                List<Transaction> items = groupedTransactions[dateKey]!;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🏷️ Section Header
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        dateKey, // Today, Yesterday, or formatted date
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    // Transactions for this section with alternating colors
                    ...items.asMap().entries.map((entry) {
                      final itemIndex = entry.key;
                      final transaction = entry.value;

                      return ListItem(
                        imageUrl: transaction.image,
                        title:
                            'POSTER ${transaction.number.map((int num) => "#$num").join(", ")}',
                        backgroundColor: itemIndex.isOdd
                            ? Colors.grey[
                                200] // Odd transactions get a light gray background
                            : null, // Even transactions use default
                      );
                    }),
                  ],
                );
              },
            );
          }

          return const Center(child: Text("No transactions available."));
        },
      ),
    );
  }

  // 🛠 Helper to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  // 🌟 Shimmer Placeholder Loader
  Widget _buildShimmerLoader() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      itemCount: 5, // Show 5 shimmer placeholders
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: Container(
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        );
      },
    );
  }
}
