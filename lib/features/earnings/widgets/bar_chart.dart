// bar_chart.dart
import 'package:flutter/material.dart';
import 'package:matiz/features/earnings/data/models/monthly_earning.dart';

class BarChart extends StatefulWidget {
  final List<MonthlyEarning> monthlyData;
  final Function(MonthlyEarning) onBarSelected;

  const BarChart({
    super.key,
    required this.monthlyData,
    required this.onBarSelected,
  });

  @override
  BarChartState createState() => BarChartState();
}

class BarChartState extends State<BarChart> with TickerProviderStateMixin {
  late int selectedIndex;
  late List<AnimationController> controllers;
  late List<Animation<double>> animations;

  static const double minBarHeight =
      5.0; // Ensures visibility even for zero values

  @override
  void initState() {
    super.initState();
    selectedIndex = -1; // Default to no selection
    _initializeAnimations();
    _startSequentialAnimation();
  }

  void _initializeAnimations() {
    // Create controllers and animations based on the current monthlyData.
    controllers = List.generate(
      widget.monthlyData.length,
      (_) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      ),
    );

    animations = List.generate(
      widget.monthlyData.length,
      (index) => Tween<double>(
        begin: 0,
        end: widget.monthlyData[index].earnings,
      ).animate(
        CurvedAnimation(
          parent: controllers[index],
          curve: Curves.easeOut,
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant BarChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    // If the number of items has changed, reinitialize everything.
    if (oldWidget.monthlyData.length != widget.monthlyData.length) {
      for (var controller in controllers) {
        controller.dispose();
      }
      _initializeAnimations();
      _startSequentialAnimation();
    } else {
      // If only the values have changed, update each animation.
      for (int i = 0; i < widget.monthlyData.length; i++) {
        final newEnd = widget.monthlyData[i].earnings;
        // Create a new tween starting from the current value to the new target.
        animations[i] = Tween<double>(
          begin: animations[i].value,
          end: newEnd,
        ).animate(
          CurvedAnimation(
            parent: controllers[i],
            curve: Curves.easeOut,
          ),
        );
        controllers[i].reset();
        controllers[i].forward();
      }
    }
  }

  /// Public method to trigger the bar animation.
  void restartAnimation() {
    // Reset each controller and then start the sequential animation.
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].reset();
    }
    _startSequentialAnimation();
  }

  Future<void> _startSequentialAnimation() async {
    for (int i = 0; i < controllers.length; i++) {
      if (!mounted) return; // Ensure the widget is still in the tree
      controllers[i].forward();
      await Future.delayed(
        const Duration(milliseconds: 200), // Staggered animation delay
      );
    }
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Calculate the maximum earnings value (avoid division by zero).
    double maxEarning = widget.monthlyData
        .map((item) => item.earnings)
        .reduce((a, b) => a > b ? a : b);
    maxEarning = maxEarning > 0 ? maxEarning : 1;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // The row of animated bars.
        SizedBox(
          height: 150.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              widget.monthlyData.length,
              (index) {
                final item = widget.monthlyData[index];
                final bool isSelected = index == selectedIndex;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                    widget.onBarSelected(item);
                  },
                  child: AnimatedBuilder(
                    animation: animations[index],
                    builder: (context, child) {
                      // Calculate the bar height (with a minimum).
                      double barHeight =
                          animations[index].value / maxEarning * 120.0;
                      barHeight =
                          barHeight < minBarHeight ? minBarHeight : barHeight;

                      return Container(
                        width: 16.0,
                        height: barHeight,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: isSelected ? Colors.black : Colors.transparent,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16.0),
        // Month labels below the bars.
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(
            widget.monthlyData.length,
            (index) {
              final bool isSelected = index == selectedIndex;
              final String month = widget.monthlyData[index].month;

              return Text(
                month,
                style: TextStyle(
                  fontSize: 12.0,
                  color: isSelected ? Colors.black : Colors.grey[600],
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
