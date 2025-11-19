import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:full_layout_base/app/routes/routes_helper.dart';
import 'package:full_layout_base/app/services/language/language_cubit.dart';
import 'package:full_layout_base/app/utils/general_utils.dart';
import 'package:full_layout_base/l10n/L10N.dart';
import 'package:full_layout_base/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:full_layout_base/app/repositories/clients/http_client/http_client.dart';
import 'package:full_layout_base/app/repositories/repositories/auth/auth_repository.dart';
import 'package:full_layout_base/app/services/auth/auth_cubit.dart';

class BaseApp extends StatelessWidget {
  final HttpClient httpClient;

  const BaseApp(this.httpClient, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LanguageCubit>(create: (_) => LanguageCubit()),
        BlocProvider<AuthCubit>(
          create: (_) => AuthCubit(AuthRepository(httpClient)),
        ),
      ],
      child: Sizer(
        builder: (_, _, _) => Consumer<LanguageCubit>(
          builder: (_, provider, _) => GetMaterialApp(
            title: '//TODO 2505',
            navigatorKey: navigatorKey,
            debugShowCheckedModeBanner: false,
            locale: provider.locale,
            supportedLocales: L10n.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            initialRoute: RoutesHelper.splashView,
            getPages: RoutesHelper.routes,
            theme: ThemeData(),
          ),
        ),
      ),
    );
  }
}
