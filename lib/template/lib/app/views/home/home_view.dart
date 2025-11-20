import 'package:flutter/material.dart';
import 'package:{{PROJECT_NAME}}/app/style/app_text_styles.dart';
import 'package:{{PROJECT_NAME}}/app/utils/general_utils.dart';
import 'package:{{PROJECT_NAME}}/app/widgets/app_icon.dart';
import 'package:{{PROJECT_NAME}}/app/widgets/app_view.dart';
import 'package:{{PROJECT_NAME}}/app/widgets/empty_space.dart';
import 'package:{{PROJECT_NAME}}/app/widgets/h.dart';
import 'package:sizer/sizer.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeView();
}

class _HomeView extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return AppView(
      appBarWidgets: [
        EmptySpace(),
        Text(
          translate.home,
          style: AppTextStyles.mainStyle,
          key: Key('appbar_home'),
        ),
        EmptySpace(),
      ],
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(Icons.check, key: Key('icon_home')),
          H(3.h),
          Text(
            translate.loggedIn,
            style: AppTextStyles.mainStyle,
            key: Key('text_home'),
          ),
        ],
      ),
    );
  }
}
