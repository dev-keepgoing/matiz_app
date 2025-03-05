import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BalanceDisplay extends StatelessWidget {
  final double balance;
  final String currency;

  const BalanceDisplay({
    super.key,
    required this.balance,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    String formattedBalance =
        '\$${NumberFormat("#,##0.00", "en_US").format(balance)}';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'GANACIAS ESTE MES',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              formattedBalance,
              style: Theme.of(context).textTheme.headlineLarge,
            ),
          ],
        ),
        Text("* EL BALANCE ES ACTUALIZADO TODOS LOS DÍAS A LAS 6PM.",
            style: Theme.of(context).textTheme.bodyMedium),
        Text("* EL CICLO DE GANACIAS RE-INICIA AL FINAL DE MES",
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
