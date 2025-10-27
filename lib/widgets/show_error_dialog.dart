import 'package:flutter/material.dart';

// Make sure this path matches your project structure
import '../utils/app_colors.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),

      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: AppColors.kError, size: 48),
          const SizedBox(height: 16),
          Text(
            'Error',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: AppColors.kError,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),

      // Style the content
      content: Text(
        message,
        textAlign: TextAlign.center,
        style: Theme.of(
          context,
        ).textTheme.bodyLarge?.copyWith(color: AppColors.kTextSecondary),
      ),

      actionsAlignment: MainAxisAlignment.center,
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'OK',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              color: AppColors.kPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    ),
  );
}
