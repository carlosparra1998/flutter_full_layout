import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{PROJECT_NAME}}/app/enums/http_call.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/clients/http_client/http_client.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/repositories/auth/models/auth_session.dart';
import 'package:mocktail/mocktail.dart';

class MockDio extends Mock implements Dio {
  @override
  Interceptors get interceptors => Interceptors();
}

void main() {
  late MockDio mockDio;
  late HttpClient client;

  setUpAll(() {});

  setUp(() {
    mockDio = MockDio();
    client = HttpClient(mockDio);
  });

  group('HttpClient.POST', () {
    test('POST OK', () async {
      when(
        () => mockDio.post(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'access_token': 'access', 'refresh_token': 'refresh'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts'),
        ),
      );

      final result = await client.call<AuthSession, AuthSession>(
        '/posts',
        method: HttpCall.POST,
      );

      expect(result.isError, isFalse);
      expect(result.data, isNotNull);
      expect(result.data!.accessToken, 'access');
      expect(result.data!.refreshToken, 'refresh');

      verify(
        () => mockDio.post(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).called(1);
    });

    test('POST KO', () async {
      when(
        () => mockDio.post(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenThrow(
        DioException(
          message: 'fail',
          requestOptions: RequestOptions(path: '/posts'),
          error: 'fail',
        ),
      );

      final result = await client.call<AuthSession, AuthSession>(
        '/posts',
        method: HttpCall.POST,
      );

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'fail');

      verify(
        () => mockDio.post(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).called(1);
    });
  });

  group('HttpClient.GET', () {
    test('GET OK', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'access_token': 'access', 'refresh_token': 'refresh'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts'),
        ),
      );

      final result = await client.call<AuthSession, AuthSession>(
        '/posts',
        method: HttpCall.GET,
      );

      expect(result.isError, isFalse);
      expect(result.data, isNotNull);
      expect(result.data!.accessToken, 'access');
      expect(result.data!.refreshToken, 'refresh');

      verify(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).called(1);
    });

    test('GET KO', () async {
      when(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenThrow(
        DioException(
          message: 'fail',
          requestOptions: RequestOptions(path: '/posts'),
          error: 'fail',
        ),
      );

      final result = await client.call<AuthSession, AuthSession>(
        '/posts',
        method: HttpCall.GET,
      );

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'fail');

      verify(
        () => mockDio.get(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).called(1);
    });
  });

  group('HttpClient.PUT', () {
    test('PUT OK', () async {
      when(
        () => mockDio.put(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenAnswer(
        (_) async => Response(
          data: {'access_token': 'access', 'refresh_token': 'refresh'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/posts'),
        ),
      );

      final result = await client.call<AuthSession, AuthSession>(
        '/posts',
        method: HttpCall.PUT,
      );

      expect(result.isError, isFalse);
      expect(result.data, isNotNull);
      expect(result.data!.accessToken, 'access');
      expect(result.data!.refreshToken, 'refresh');

      verify(
        () => mockDio.put(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).called(1);
    });

    test('PUT KO', () async {
      when(
        () => mockDio.put(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).thenThrow(
        DioException(
          message: 'fail',
          requestOptions: RequestOptions(path: '/posts'),
          error: 'fail',
        ),
      );

      final result = await client.call<AuthSession, AuthSession>(
        '/posts',
        method: HttpCall.PUT,
      );

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'fail');

      verify(
        () => mockDio.put(
          any(),
          queryParameters: any(named: 'queryParameters'),
          data: any(named: 'data'),
          options: any(named: 'options'),
          cancelToken: any(named: 'cancelToken'),
          onSendProgress: any(named: 'onSendProgress'),
          onReceiveProgress: any(named: 'onReceiveProgress'),
        ),
      ).called(1);
    });
  });
}
