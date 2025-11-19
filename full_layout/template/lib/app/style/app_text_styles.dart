import 'package:flutter/cupertino.dart';
import 'package:full_layout_base/app/extensions/num.dart';
import 'package:full_layout_base/app/style/app_colors.dart';

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
