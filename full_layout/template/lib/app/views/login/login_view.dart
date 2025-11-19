import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_layout_base/app/routes/routes_helper.dart';
import 'package:full_layout_base/app/services/auth/auth_cubit.dart';
import 'package:full_layout_base/app/services/language/language_cubit.dart';
import 'package:full_layout_base/app/style/app_text_styles.dart';
import 'package:full_layout_base/app/utils/general_utils.dart';
import 'package:full_layout_base/app/views/login/forms/login_form.dart';
import 'package:full_layout_base/app/widgets/app_button.dart';
import 'package:full_layout_base/app/widgets/app_text_field.dart';
import 'package:full_layout_base/app/widgets/app_view.dart';
import 'package:full_layout_base/app/widgets/empty_space.dart';
import 'package:full_layout_base/app/widgets/h.dart';
import 'package:full_layout_base/app/widgets/language_dropdown.dart';
import 'package:full_layout_base/app/widgets/loader.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LanguageCubit, LanguageState>(
      listener: (context, state) {},
      builder: (context, state) {
        return BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthLoading) {
              state.loading ? showLoader(context) : pop(context);
            }
            if (state is AuthSuccess) {
              Get.offAllNamed(RoutesHelper.homeView);
            }
            if (state is AuthError) {
              showSnackBar(
                state.codeMessage == 'email'
                    ? translate.emailRequired
                    : translate.password,
              );
            }
          },
          builder: (context, state) {
            LoginForm form = context.read<AuthCubit>().form;
            return AppView(
              floatingIcon: Icons.help,
              appBarWidgets: [
                EmptySpace(),
                Text(
                  translate.login,
                  style: AppTextStyles.mainStyle,
                  key: Key('appbar_login'),
                ),
                EmptySpace(),
              ],
              content: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AppTextField(
                    key: Key('login_email_textfield'),
                    controller: form.emailController,
                    hintText: translate.email,
                  ),
                  H(3.h),
                  AppTextField(
                    key: Key('login_password_textfield'),
                    controller: form.passwordController,
                    hintText: translate.password,
                  ),
                  H(3.h),
                  AppButton(
                    key: Key('login_button'),
                    title: translate.access,
                    onTap: () => context.read<AuthCubit>().login(),
                  ),
                  H(5.h),
                  LanguageDropdown(key: Key('dropdown_languages'),),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
