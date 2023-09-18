import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';

class EmptyInsightCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final String emptyMessage;
  final VoidCallback onCardTap;

  EmptyInsightCard({
    required this.icon,
    required this.color,
    required this.label,
    required this.emptyMessage,
    required this.onCardTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: GestureDetector(
      onTap: onCardTap,
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: DottedBorder(
            padding: const EdgeInsets.all(20.0),
            borderType: BorderType.RRect,
            radius: const Radius.circular(4.0),
            dashPattern: const [10, 10],
            color: Colors.grey,
            strokeWidth: 2,
            child: Column(
              children: [
                Icon(
                  Icons.add,
                  size: 32,
                  color: color,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        emptyMessage,
                        overflow: TextOverflow
                            .ellipsis, // Trim text and add ellipsis (...) when it overflows
                        maxLines: 1, // Set the maximum number of lines to 1
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ));
  }
}
