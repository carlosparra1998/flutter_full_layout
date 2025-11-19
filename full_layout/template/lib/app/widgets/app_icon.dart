import 'package:flutter/material.dart';
import 'package:full_layout_base/app/extensions/num.dart';
import 'package:full_layout_base/app/style/app_colors.dart';

class AppIcon extends StatelessWidget {
  final IconData icon;
  final Color? color;
  final double? size;
  final Function()? onTap;

  const AppIcon(this.icon, {this.color, this.size, this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Icon(
        icon,
        color: color ?? AppColors.black,
        size: size ?? 20.responsive(largeSize: 28),
      ),
    );
  }
}
