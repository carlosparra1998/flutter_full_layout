import 'package:flutter/material.dart';
import 'package:full_layout_base/app/extensions/num.dart';
import 'package:full_layout_base/app/widgets/app_icon.dart';
import 'package:sizer/sizer.dart';
import 'package:full_layout_base/app/style/app_colors.dart';
import 'package:full_layout_base/app/values/constants.dart';

class AppView extends StatefulWidget {
  final Widget content;
  final List<Widget> appBarWidgets;
  final IconData? floatingIcon;
  final Color? backgroundColor;
  final Key? floatingKey;
  final Function()? onFloatingPressed;

  const AppView({
    required this.content,
    this.appBarWidgets = const [],
    this.floatingIcon,
    this.onFloatingPressed,
    this.backgroundColor,
    this.floatingKey,
    super.key,
  });

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.green,
      body: SafeArea(
        child: Center(
          child: Container(
            color: widget.backgroundColor ?? AppColors.backgroundColor,
            child: Column(
              children: <Widget>[
                if (widget.appBarWidgets.isNotEmpty)
                  SizedBox(
                    height: 10.h.responsive(largeSize: 7.h),
                    child: appBar(),
                  ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: Constants.paddingVertical,
                      horizontal: Constants.paddingHorizontal,
                    ),
                    child: widget.content,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: floatingButton(),
    );
  }

  Widget appBar() {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.green,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Constants.paddingHorizontal * 1.5,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: widget.appBarWidgets,
          ),
        ),
      ),
    );
  }

  Widget? floatingButton() {
    return widget.floatingIcon == null
        ? null
        : FloatingActionButton(
            key: widget.floatingKey,
            elevation: 2,
            onPressed: widget.onFloatingPressed,
            backgroundColor: AppColors.green,
            child: AppIcon(
              widget.floatingIcon!,
              size: 30.responsive(largeSize: 40),
            ),
          );
  }
}
