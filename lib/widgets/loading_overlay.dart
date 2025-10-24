import 'dart:ui';

import 'package:aipply/utils/app_colors.dart';
import 'package:flutter/material.dart';

import '../utils/assets.dart';

class LoadingOverlay extends StatelessWidget {
  final bool isLoading;
  final String headerText;
  final String descriptionText;

  const LoadingOverlay({
    super.key,
    required this.isLoading,
    required this.headerText,
    required this.descriptionText,
  });

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Stack(
            children: [
              // Blur effect
              Positioned.fill(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                  child: Container(
                    color: AppColors.kWhite.withValues(
                      alpha: 0.6,
                    ), // Semi-transparent overlay
                  ),
                ),
              ),
              // Loading UI
              if (headerText.isNotEmpty && descriptionText.isNotEmpty) ...[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title text
                      Text(
                        headerText,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      // Subtitle text
                      Text(
                        descriptionText,
                        style: TextStyle(fontSize: 14, color: AppColors.kTextOnAccent),
                      ),
                      SizedBox(height: 20),
                      // Custom loading widget with logo and circular progress
                      CustomLoadingIndicator(),
                    ],
                  ),
                ),
              ],
              if (headerText.isEmpty && descriptionText.isEmpty)
                Center(child: CustomLoadingIndicator()),
            ],
          )
        : SizedBox.shrink(); // Return an empty widget when not loading
  }
}

class CustomLoadingIndicator extends StatelessWidget {
  const CustomLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Circular progress indicator
        SizedBox(
          width: 80,
          height: 80,
          child: CircularProgressIndicator(
            strokeWidth: 6,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
            backgroundColor: Colors.grey[300],
          ),
        ),
        // Logo in the center
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.kTransparent,
          ),
          child: Center(
            child: Image.asset(AssetsImages.aipplyIcon, width: 50, height: 50),
          ),
        ),
      ],
    );
  }
}
