import 'package:flutter/material.dart';
import 'package:{{PROJECT_NAME}}/app/style/app_colors.dart';
import 'package:{{PROJECT_NAME}}/app/style/app_text_styles.dart';
import 'package:{{PROJECT_NAME}}/app/values/constants.dart';

class AppButton extends StatelessWidget {
  final String title;
  final Function() onTap;
  final bool enable;
  final Color? backgroundColor;

  const AppButton({
    required this.title,
    required this.onTap,
    this.enable = true,
    this.backgroundColor,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enable,
      child: Opacity(
        opacity: enable ? 1 : .5,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            child: Container(
              decoration: BoxDecoration(
                color: backgroundColor ?? AppColors.green,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: Constants.paddingVertical * 2,
                  horizontal: Constants.paddingHorizontal * 5,
                ),
                child: Text(title, style: AppTextStyles.mainStyle),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
