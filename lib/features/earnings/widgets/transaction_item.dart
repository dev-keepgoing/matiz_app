import 'package:flutter/material.dart';
import 'package:matiz/features/earnings/data/models/transaction.dart';

class TransactionItem extends StatelessWidget {
  final Transaction transaction;

  const TransactionItem({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(vertical: 6.0), // 🏷️ Space between items
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200], // 🔹 Light gray background
        borderRadius: BorderRadius.circular(12), // 🔹 Rounded edges
      ),
      child: ListTile(
        leading: ClipOval(
          child: Image.network(
            transaction.image,
            width: 50,
            height: 50,
            fit: BoxFit.cover,
          ),
        ),
        title: Text(
          'POSTER ${transaction.number.map((num) => "#$num").join(", ")}',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        // subtitle: Text(
        //   "${transaction.date} • ORDER #${transaction.orderId}",
        //   style: const TextStyle(color: Colors.grey),
        // ),
        // trailing: Text(
        //   "-\$${transaction.collection}",
        //   style: const TextStyle(
        //     fontWeight: FontWeight.bold,
        //     color: Colors.red,
        //   ),
        // ),
      ),
    );
  }
}
