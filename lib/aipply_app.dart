import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../l10n/app_localizations.dart';
import '../l10n/l10n.dart';
import 'utils/app_router.dart';
import 'utils/app_theme.dart';
import 'utils/constants.dart';
import 'utils/fallback_localization.dart';

/// app config for theme and app default options
class AipplyApp extends ConsumerStatefulWidget {
  const AipplyApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _AipplyAppState();
}

class _AipplyAppState extends ConsumerState<AipplyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: kAppName,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
      theme: AppTheme(context).themeData(isDarkModeOn: false),
      scaffoldMessengerKey: messengerKey,
      routerConfig: AppRouter.getRouter(),
      supportedLocales: L10n.all,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        FallbackLocalizationDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
    );
  }
}
