// earnings_chart.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:matiz/features/earnings/data/models/monthly_earning.dart';
import 'package:matiz/features/earnings/widgets/bar_chart.dart';
import 'package:matiz/app/widgets/animated_earnings_text.dart';

class EarningsChart extends StatefulWidget {
  final List<MonthlyEarning> monthlyData;

  const EarningsChart({
    Key? key,
    required this.monthlyData,
  }) : super(key: key);

  @override
  _EarningsChartState createState() => _EarningsChartState();
}

class _EarningsChartState extends State<EarningsChart> {
  late double selectedEarning;
  String? selectedMonth;
  bool _isAnimating = false;
  Timer? _animationTimer;

  // This variable holds the data currently shown in the BarChart.
  late List<MonthlyEarning> _displayedMonthlyData;

  // GlobalKey to access BarChart's state.
  final GlobalKey<BarChartState> _barChartKey = GlobalKey<BarChartState>();

  @override
  void initState() {
    super.initState();
    // Initially, display the incoming monthlyData.
    _displayedMonthlyData = widget.monthlyData;
    _updateSelectedEarning();
  }

  void _updateSelectedEarning() {
    // Calculate total earnings from the _displayedMonthlyData.
    selectedEarning = _displayedMonthlyData.fold(
      0.0,
      (sum, item) => sum + item.earnings,
    );
  }

  @override
  void didUpdateWidget(covariant EarningsChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // When new monthly data arrives, trigger the animated text,
    // and after 3 seconds, update the displayed data.
    if (oldWidget.monthlyData != widget.monthlyData) {
      setState(() {
        _isAnimating = true;
      });
      _animationTimer?.cancel();
      _animationTimer = Timer(const Duration(seconds: 3), () {
        setState(() {
          _isAnimating = false;
          // Update the displayed data only after the animation finishes.
          _displayedMonthlyData = widget.monthlyData;
          // Recalculate the total earnings using the updated data.
          _updateSelectedEarning();
        });
        // Trigger the BarChart’s internal animation (bars going up).
        _barChartKey.currentState?.restartAnimation();
      });
    }
  }

  @override
  void dispose() {
    _animationTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide.none,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display the current selected month or a default text.
            if (selectedMonth == null)
              Text(
                'TOTAL DE GANANCIAS',
                style: Theme.of(context).textTheme.bodySmall,
              )
            else
              Text(
                selectedMonth!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            // AnimatedSwitcher to show either the animated earnings text
            // or the normal formatted earnings once the animation is done.
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: _isAnimating
                  ? const AnimatedEarningsText(key: ValueKey('animating'))
                  : Text(
                      selectedEarning != 0
                          ? '\$${NumberFormat("#,##0.00", "en_US").format(selectedEarning)}'
                          : "\$0.00",
                      key: const ValueKey('earnings'),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
            ),
            // The BarChart is always visible.
            // It receives _displayedMonthlyData, so it will only show the new data after the animation finishes.
            BarChart(
              key: _barChartKey,
              monthlyData: _displayedMonthlyData,
              onBarSelected: (MonthlyEarning selectedItem) {
                setState(() {
                  selectedEarning = selectedItem.earnings;
                  selectedMonth = selectedItem.month;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
