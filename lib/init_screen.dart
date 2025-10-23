import 'package:aipply/core/home/presentations/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class InitScreen extends ConsumerStatefulWidget {
  const InitScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _InitScreenState();
}

class _InitScreenState extends ConsumerState<InitScreen> {
  @override
  Widget build(BuildContext context) {
    return HomeScreen();
  }
}
