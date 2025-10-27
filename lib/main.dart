import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'aipply_app.dart';

void main() async {
  _setUp();
  runApp(
    DevicePreview(
      enabled: false,
      builder: (context) => ProviderScope(child: AipplyApp()),
    ),
  );
}

Future<void> _setUp() async {
  WidgetsFlutterBinding.ensureInitialized();
  usePathUrlStrategy();
}
