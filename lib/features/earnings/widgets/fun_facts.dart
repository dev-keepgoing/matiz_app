import 'package:flutter/material.dart';

class FunFactsWidget extends StatefulWidget {
  final List<FunFactItem> items;

  const FunFactsWidget({
    super.key,
    required this.items,
  });

  @override
  _FunFactsWidgetState createState() => _FunFactsWidgetState();
}

class _FunFactsWidgetState extends State<FunFactsWidget> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      child: Column(
        children: [
          const SizedBox(height: 16.0),

          // Scrollable Images
          SizedBox(
            height: 300.0, // Ensures consistent height for the images
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(widget.items.length, (index) {
                  final item = widget.items[index];
                  final isSelected = _currentIndex == index;

                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      width: isSelected
                          ? 220.0
                          : 150.0, // Bigger width for selected item
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: isSelected
                            ? Border.all(color: Colors.black, width: 2.0)
                            : null,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.asset(
                          item.image,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 16.0),

          // Selected Title and Description
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.items[_currentIndex].title,
                  style: Theme.of(context).textTheme.displayLarge!.copyWith(
                        fontSize: 18.0,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 8.0),
                Text(
                  widget.items[_currentIndex].description,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        fontSize: 14.0,
                        color: Colors.grey[700],
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// FunFactItem Model
class FunFactItem {
  final String image;
  final String title;
  final String description;

  FunFactItem({
    required this.image,
    required this.title,
    required this.description,
  });
}
