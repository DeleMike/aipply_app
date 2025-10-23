import 'package:aipply/l10n/app_localizations.dart';
import 'package:aipply/utils/app_colors.dart';
import 'package:aipply/utils/assets.dart';
import 'package:aipply/utils/dimensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Container(
            height: kScreenHeight(context),
            width: kScreenWidth(context) * 0.5,

            decoration: BoxDecoration(color: AppColors.kPrimary),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(AssetsImages.aipplyIcon),
                  Text(
                    AppLocalizations.of(context)!.appName,
                    style: Theme.of(context).textTheme.displayLarge!.copyWith(
                      fontSize: 65,
                      color: AppColors.kAccent,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
