import 'package:flutter/material.dart';
import 'package:full_layout_base/app/widgets/app_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  Widget build(BuildContext context) {
    return AppView(content: Placeholder());
  }
}