import 'package:{{PROJECT_NAME}}/app/views/home/home_view.dart';
import 'package:{{PROJECT_NAME}}/app/views/login/login_view.dart';
import 'package:{{PROJECT_NAME}}/app/views/splash/splash_view.dart';
import 'package:get/get.dart';

class RoutesHelper {
  static final String _splashView = '/';
  static final String _loginView = '/login';
  static final String _homeView = '/home';

  static String get splashView => _splashView;
  static String get loginView => _loginView;
  static String get homeView => _homeView;

  static List<GetPage> get routes => [
    GetPage(name: _splashView, page: () => const SplashView()),
    GetPage(name: _loginView, page: () => const LoginView()),
    GetPage(name: _homeView, page: () => const HomeView()),
  ];
}
