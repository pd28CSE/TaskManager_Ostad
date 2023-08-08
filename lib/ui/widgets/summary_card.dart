import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int number;
  const SummaryCard({
    super.key,
    required this.title,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text(
              number < 10 ? '0$number' : '$number',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(title)
          ],
        ),
      ),
    );
  }
}
