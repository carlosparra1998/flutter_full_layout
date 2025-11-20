import 'package:flutter_test/flutter_test.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/clients/client_response.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/repositories/auth/auth_repository.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/repositories/auth/models/auth_session.dart';
import 'package:{{PROJECT_NAME}}/app/services/auth/auth_cubit.dart';
import 'package:mocktail/mocktail.dart';

class MockPostRepository extends Mock implements AuthRepository {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {});

  late AuthCubit cubit;
  late AuthRepository authRepository;

  setUp(() {
    authRepository = MockPostRepository();
    cubit = AuthCubit(authRepository);
  });

  tearDown(() {
    cubit.close();
  });

  group('PostsCubit.login', () {
    test('Login OK', () async {
      when(() => authRepository.login(any(), any())).thenAnswer(
        (_) async => ClientResponse(
          data: AuthSession(accessToken: 'access', refreshToken: 'refresh'),
          isError: false,
        ),
      );

      cubit.form.emailController.text = 'email';
      cubit.form.passwordController.text = 'pass';

      await cubit.login();

      expect(cubit.session, isNotNull);
      expect(cubit.session!.accessToken, 'access');
      expect(cubit.session!.refreshToken, 'refresh');

      verify(() => authRepository.login(any(), any())).called(1);
    });

    test('There is not email', () async {
      cubit.form.emailController.text = '';
      cubit.form.passwordController.text = 'pass';

      await cubit.login();

      expect(cubit.session, isNull);

      verifyNever(() => authRepository.login(any(), any()));
    });

    test('There is not password', () async {
      cubit.form.emailController.text = 'email';
      cubit.form.passwordController.text = '';

      await cubit.login();

      expect(cubit.session, isNull);

      verifyNever(() => authRepository.login(any(), any()));
    });

    test('Login KO', () async {
      when(() => authRepository.login(any(), any())).thenAnswer(
        (_) async =>
            ClientResponse(data: null, isError: true, errorMessage: 'error'),
      );

      cubit.form.emailController.text = 'badEmail';
      cubit.form.passwordController.text = 'pass';

      await cubit.login();

      expect(cubit.session, isNull);
      verify(() => authRepository.login(any(), any())).called(1);
    });
  });
}
