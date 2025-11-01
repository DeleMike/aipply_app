import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import '../utils/app_colors.dart';

class SingleLineWaitWidget extends StatelessWidget {
  const SingleLineWaitWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final border = BorderRadius.circular(12);
    const double bHeight = 25;
    return LayoutBuilder(
      builder: (context, constraints) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: border,
          child: ShimmerWidget.rectangular(
            height: bHeight * .75,
            width: constraints.maxWidth,
          ),
        ),
      ),
    );
  }
}

class ShimmerWidget extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ShimmerWidget.rectangular({
    super.key,
    this.width = double.infinity,
    required this.height,
  }) : shapeBorder = const RoundedRectangleBorder();

  const ShimmerWidget.circular({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.shapeBorder = const CircleBorder(),
  });

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    baseColor: AppColors.kBlack.withValues(alpha: 0.24),
    highlightColor: Theme.of(context).canvasColor,
    period: const Duration(milliseconds: 1500),
    child: Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: AppColors.kBlack.withValues(alpha: 0.24),
        shape: shapeBorder,
      ),
    ),
  );
}
