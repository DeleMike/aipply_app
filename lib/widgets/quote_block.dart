import 'package:aipply/utils/dimensions.dart';
import 'package:flutter/material.dart';

class QuoteBlock extends StatelessWidget {
  final String text;

  const QuoteBlock({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: kScreenWidth(context),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F8FA),
        borderRadius: BorderRadius.circular(6.0),
        border: const Border(left: BorderSide(color: Color(0xFFD0D7DE), width: 5.0)),
      ),

      child: Text(
        text,
        style: const TextStyle(color: Color(0xFF57606A), fontSize: 16, height: 1.5),
      ),
    );
  }
}
