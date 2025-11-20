# Flutter Full Layout - Flutter CLEAN ARCH Project Generator 🚀🚀🚀

`Current Full Layout CLI version: 1.2.0`

`Flutter version: 3.38.2`

`Dart version: 3.10.0`

CLI to generate a complete Flutter project with `CLEAN ARCHITECTURE`.

It will allow the developer to create a base project with CLEAN ARCHITECTURE. In this architecture, we use `services (Cubits)` for each use case. These services will communicate with `repositories` (for each use case), and these repositories will communicate with the `DIO client (HTTP)`.

- In this layout, `BLoC and Cubit` are used for state management. 
- `DIO` is used for communication with the REST API. 
- `l10n` is used for translations.
- `Real use case` in full operation (Auth - login)
- Basic `responsive design` management
- `Route management` with GET
- Defined styles (text styles and colours)
- Complete initialiser in Splash Screen
- `Predefined tests` (unit, integration and widgets) [91.8% coverage].
- A `homemade HTTP client (using DIO)` that provides directly constructed objects/lists, without the need for processing (just indicate the fromJson of a specific class to target in the client).
 
---

## Installing

Install globally via Dart:

```bash
dart pub global activate flutter_full_layout
```

> After installation, the `flutter_full_layout` command will be available globally.

---

## Usage

Create a new Flutter project using your template:

```bash
flutter_full_layout create my_app --package com.example.myapp --name "My App"
```

* `my_app` → folder name for your new project
* `--package` → (optional) your app's package ID (e.g., `com.example.myapp`)
* `--name` → (optional) display name of your app

---

## Details about your newly created project


### Detail 1. Clean Architecture.

```bash
├── app
│   ├── app.dart
│   ├── enums
│   ├── extensions
│   ├── repositories
│   ├── routes
│   ├── services
│   ├── style
│   ├── utils
│   ├── values
│   ├── views
│   └── widgets
├── l10n
└── main.dart
```

In this architecture, you will find all the modules in a very orderly fashion.
Everything related to the application windows can be found in `views`, while all services (Cubits) can be found in the `services` directory.
For communication with REST, we have all clients and repositories in `repositories`.

---

### Detail 2. State Gesture - BLoC with Cubit.

The first step is to establish dependency injection in the `app.dart` file, with all the services to be used (cubits).

```dart
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
        builder: (_, _, _) => BlocConsumer<LanguageCubit, LanguageState>(
          listener: (context, state) {},
          builder: (context, state) {
            Locale? locale = context.read<LanguageCubit>().locale;
            return GetMaterialApp(
              title: 'Layout App',
              navigatorKey: navigatorKey,
              debugShowCheckedModeBanner: false,
              locale: locale,
              supportedLocales: L10n.supportedLocales,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              initialRoute: RoutesHelper.splashView,
              getPages: RoutesHelper.routes,
              theme: ThemeData(),
            );
          },
        ),
      ),
    );
  }
}
```

An example of Cubit can be our `language_cubit.dart`, which manages the current language of the application:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  LanguageCubit() : super(const AuthInitial());

  Locale? _locale;

  Locale? get locale => _locale;

  void initProvider() {
    _locale = Locale('es');
  }

  void changeLanguage(Locale newLoc) {
    _locale = newLoc;
    emit(LanguageUpdated());
  }
}
```

To set up a consumer, simply place `BlocConsumer` in the window you want:

```dart
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
                  LanguageDropdown(key: Key('dropdown_languages')),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
```

---

### Detail 3. DIO and homemade HTTP Client.

In order for our repositories to communicate with REST API, we use `DIO` as the main library, but we have created middleware (`HttpClient`) to facilitate all management of data to be sent and received via HTTP.

Example of using `HttpClient` with one of our repositories:

```dart
class AuthRepository {
  final HttpClient client;

  AuthRepository(this.client);

  Future<ClientResponse<AuthSession>> login(
    String email,
    String password,
  ) async {
    return await client.call<AuthSession, AuthSession>(
      AuthEndpoints.login,
      method: HttpCall.POST,
      tokenRequired: false,
      data: jsonEncode({'email': email, 'password': password}),
    );
  }
}
```

In this case, the login receives an object called `ClientResponse`, which will contain information about the communication. If everything went well, it will include the data (ClientResponse().data), and if the service failed, it will include a flag (ClientResponse().isError) and information about the error (ClientResponse().errorMessage).

In order for this client to know how to generate the object with the information received, we only need to include the `fromJson` of our object in this code snippet (`http_client.dart`):

```dart
  R _getResultObject<R>(dynamic response) {
    switch (R) {
      case AuthSession:
        return AuthSession.fromJson(response) as R;      
      case OurNewObject:
        return OurNewObject.fromJson(response) as R;
      //add more
      default:
        return response as R;
    }
  }
```

And in the case of receiving a `list of objects`:

```dart
class TestRepository {
  final HttpClient client;

  TestRepository(this.client);

  Future<ClientResponse<List<MyObject>>> login(
    String email,
    String password,
  ) async {
    return await client.call<List<MyObject>, MyObject>(
      TestEndpoints.getList,
      method: HttpCall.GET,
    );
  }
}
```

### Detail 4. Internationalitation with l10n.

Currently, we have included two languages (Spanish and English) in our layout.

If we want to add a new translated label, we must add a new field to all *.arb files (one for each language).

```json
{
    "spanish" : "Spanish",
    "english" : "English",
    "newLabel" : "My new label"
}
```

To update this, simply run: 

```bash
$flutter gen-l10n
```

To add a new language, simply include it in the list of languages (supportedLocales in `L10N.dart`) and add a new .arb file.

Once included, to update this, simply run:

```bash
$flutter gen-l10n
```

And to access a translation, simply use `translate.newLabel`:

```dart
Text(
  translate.newLabel,
  style: AppTextStyles.mainStyle
)
```

### Detail 5. Route Helper with GET.

To facilitate navigation between windows, we use `RouteHelper.dart`:

```dart
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
```

To navigate, we use these instructions:

```dart
Get.toNamed(RoutesHelper.loginView); //TO-type navigation (we increase the stack)
Get.offAllNamed(RoutesHelper.loginView); //OFFALL navigation (we clear the stack)
```

### Detail 6. Responsive Design.

To facilitate responsive design, we use this extension of `num`:

```dart
extension NumExtension on num {
  double responsive({num? smallSize, num? largeSize}) =>
      (isLargeScreen
              ? largeSize ?? this
              : isSmallScreen
              ? smallSize ?? this
              : this)
          .toDouble();
}
```

Example of use:

```dart
AppIcon(
  widget.floatingIcon!,
  size: 30.responsive(largeSize: 40, smallSize: 20)
)
```

### Detail 6. Test types and examples (91.8% coverage).

In the layout, we have defined three types of tests so that you can easily use them as a reference.

- `Unit tests`
- `Integration tests`
- `Widget tests`

You can generate a coverage lcov file with:

```dart
$flutter test --coverage
```

Example of use:

```dart
test('Login OK', () async {
      when(
        () => mockClient.call<AuthSession, AuthSession>(
          any(),
          method: HttpCall.POST,
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          tokenRequired: any(named: 'tokenRequired'),
        ),
      ).thenAnswer(
        (_) async => ClientResponse(
          data: AuthSession(accessToken: 'access', refreshToken: 'refresh'),
          isError: false,
        ),
      );

      final result = await repository.login('email', 'pass');

      expect(result.isError, isFalse);
      expect(result.data!.accessToken, 'access');
      expect(result.data!.refreshToken, 'refresh');

      verify(
        () => mockClient.call<AuthSession, AuthSession>(
          any(),
          method: HttpCall.POST,
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          tokenRequired: any(named: 'tokenRequired'),
        ),
      ).called(1);
    }
);
```