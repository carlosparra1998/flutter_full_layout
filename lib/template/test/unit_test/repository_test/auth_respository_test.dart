import 'package:flutter_test/flutter_test.dart';
import 'package:{{PROJECT_NAME}}/app/enums/http_call.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/clients/client_response.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/clients/http_client/http_client.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/repositories/auth/auth_repository.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/repositories/auth/models/auth_session.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

void main() {
  late MockHttpClient mockClient;
  late AuthRepository repository;

  setUp(() {
    mockClient = MockHttpClient();
    repository = AuthRepository(mockClient);
  });

  group('AuthRepository.login', () {
    test('Login correcto', () async {
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
    });

    test('Login incorrecto', () async {
      when(
        () => mockClient.call<AuthSession, AuthSession>(
          any(),
          method: HttpCall.POST,
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          tokenRequired: any(named: 'tokenRequired'),
        ),
      ).thenAnswer(
        (_) async =>
            ClientResponse(data: null, isError: true, errorMessage: 'error'),
      );

      final result = await repository.login('email', 'pass');

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'error');

      verify(
        () => mockClient.call<AuthSession, AuthSession>(
          any(),
          method: HttpCall.POST,
          data: any(named: 'data'),
          queryParameters: any(named: 'queryParameters'),
          tokenRequired: any(named: 'tokenRequired'),
        ),
      ).called(1);
    });
  });
}
