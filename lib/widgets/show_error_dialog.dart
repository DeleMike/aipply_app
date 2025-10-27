import 'package:flutter/material.dart';

import '../utils/app_colors.dart';

void showErrorDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Error', style: Theme.of(context).textTheme.bodyMedium),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'OK',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium!.copyWith(color: AppColors.kPrimary),
          ),
        ),
      ],
    ),
  );
}
