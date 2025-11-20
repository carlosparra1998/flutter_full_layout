import 'package:flutter/material.dart';
import 'package:{{PROJECT_NAME}}/app/style/app_colors.dart';
import 'package:{{PROJECT_NAME}}/app/style/app_text_styles.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hintText;
  final int? maxLength;
  final Function(String)? onChanged;

  const AppTextField({
    required this.controller,
    this.hintText,
    this.maxLength,
    this.onChanged,
    super.key,
  });
  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        border: border(),
        enabledBorder: border(),
        focusedBorder: border(),
        counterText: '',
        filled: true,
        fillColor: AppColors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 20,
        ),
        hintText: hintText,
        hintStyle: AppTextStyles.textFieldStyle.copyWith(color: AppColors.grey),
      ),
      onChanged: onChanged,
      style: AppTextStyles.textFieldStyle,
      controller: controller,
      maxLength: maxLength,
    );
  }

  InputBorder border() => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: AppColors.black, width: 2),
      );
}
