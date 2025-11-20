import 'package:flutter/cupertino.dart';
import 'package:{{PROJECT_NAME}}/app/extensions/num.dart';
import 'package:{{PROJECT_NAME}}/app/style/app_colors.dart';

class AppTextStyles {
  static TextStyle mainStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 25.responsive(smallSize: 22, largeSize: 30),
  );
  static TextStyle textFieldStyle = TextStyle(
    fontSize: 18.responsive(largeSize: 25),
    color: AppColors.black,
  );
}
