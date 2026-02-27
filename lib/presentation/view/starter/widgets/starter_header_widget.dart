import 'package:flutter/material.dart';

class StarterHeaderWidget extends StatelessWidget {
  const StarterHeaderWidget({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: TextButton(
        style: TextButton.styleFrom(
          foregroundColor: color,
        ),
        onPressed: () {
          // TODO: Navigate to main experience.
        },
        child: const Text(
          'SKIP',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            letterSpacing: 1.6,
          ),
        ),
      ),
    );
  }
}

