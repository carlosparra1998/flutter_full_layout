import 'package:full_layout_base/app/views/login/login_view.dart';
import 'package:full_layout_base/app/views/splash/splash_view.dart';
import 'package:get/get.dart';

class RoutesHelper {
  static final String _splashView = '/';
  static final String _loginView = '/login';

  static String get splashView => _splashView;
  static String get loginView => _loginView;

  static List<GetPage> get routes => [
    GetPage(name: _splashView, page: () => const SplashView()),
    GetPage(name: _loginView, page: () => const LoginView()),
  ];
}
