import 'package:aipply/utils/dimensions.dart';
import 'package:flutter/material.dart';

class QuoteBlock extends StatelessWidget {
  final String text;

  const QuoteBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      // 1. Padding inside the box
      padding: const EdgeInsets.all(16.0),
      width: kScreenWidth(context),

      // 2. The styling for the box
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FA), // GitHub's light gray background
        borderRadius: BorderRadius.circular(6.0),

        // 3. The left border
        border: const Border(
          left: BorderSide(
            color: Color(0xFFD0D7DE), // GitHub's border gray
            width: 5.0,
          ),
        ),
      ),

      // 4. The text itself
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF57606A), // GitHub's muted text color
          fontSize: 16,
          height: 1.5, // Line spacing
        ),
      ),
    );
  }
}
