import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:{{PROJECT_NAME}}/app/extensions/num.dart';
import 'package:{{PROJECT_NAME}}/app/services/language/language_cubit.dart';
import 'package:{{PROJECT_NAME}}/app/style/app_colors.dart';
import 'package:{{PROJECT_NAME}}/app/style/app_text_styles.dart';
import 'package:{{PROJECT_NAME}}/app/widgets/w.dart';
import 'package:{{PROJECT_NAME}}/l10n/L10N.dart';
import 'package:sizer/sizer.dart';

class LanguageDropdown extends StatefulWidget {
  const LanguageDropdown({super.key});

  @override
  State<LanguageDropdown> createState() => _LanguageDropdownState();
}

class _LanguageDropdownState extends State<LanguageDropdown> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LanguageCubit, LanguageState>(
      listener: (context, state) {},
      builder: (context, state) {
        Locale? currentValue = context.read<LanguageCubit>().locale;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            color: AppColors.backgroundColor,
            border: Border.all(color: AppColors.black, width: 1.2),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 40,
          child: DropdownButton<Locale>(
            value: currentValue,
            underline: const SizedBox(),
            dropdownColor: AppColors.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            items: L10n.supportedLocales.map((loc) {
              final label = L10n.getFlag(
                code: loc.languageCode,
                size: 15.responsive(smallSize: 14, largeSize: 20),
              );
              return DropdownMenuItem(
                value: loc,
                key: Key('dropdown_languages_${loc.languageCode}'),
                child: Row(
                  children: [
                    label,
                    W(3.w),
                    Text(
                      L10n.getLanguageName(loc.languageCode),
                      style: AppTextStyles.textFieldStyle,
                    ),
                  ],
                ),
              );
            }).toList(),
            onChanged: (Locale? newLoc) {
              if (newLoc == null) return;
              context.read<LanguageCubit>().changeLanguage(newLoc);
            },
          ),
        );
      },
    );
  }
}
