import 'package:flutter/material.dart';
import 'package:full_layout_base/app/widgets/app_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return AppView(content: Placeholder());
  }
}