import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_layout_base/app/routes/routes_helper.dart';
import 'package:full_layout_base/app/services/language/language_cubit.dart';
import 'package:full_layout_base/app/widgets/app_view.dart';
import 'package:get/route_manager.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LanguageCubit>().initProvider();
      Get.offAllNamed(RoutesHelper.loginView);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppView(content: Center(child: CircularProgressIndicator()));
  }
}
