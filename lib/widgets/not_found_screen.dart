import 'package:aipply/utils/app_router.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../utils/app_colors.dart';

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.search_off, size: 80, color: AppColors.kGray500),
              const SizedBox(height: 24),
              Text(
                '404 - Page Not Found',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: AppColors.kTextPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                "Sorry, the page you're looking for doesn't exist or has been moved.",
                textAlign: TextAlign.center,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: AppColors.kTextSecondary),
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.kPrimary,
                  foregroundColor: AppColors.kWhite,
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                ),
                onPressed: () {
                  // Use replace to clear the bad history
                  context.go(AppRouter.homeScreen);
                },
                child: const Text('Go to Homepage'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
