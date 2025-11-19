import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_os_exercise_with_test/app/enums/http_call.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/http_client/http_client.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post/models/post.dart';
import 'package:mocktail/mocktail.dart';

// Mocks
class MockDio extends Mock implements Dio {
  @override
  Interceptors get interceptors => Interceptors(); // devuelve un objeto real
}

class FakeRequestOptions extends Fake implements RequestOptions {}

class FakeResponse<T> extends Fake implements Response<T> {}

void main() {
  late MockDio mockDio;
  late HttpClient client;

  setUpAll(() {
    registerFallbackValue(FakeRequestOptions());
    registerFallbackValue(FakeResponse<Map<String, dynamic>>());
  });

  setUp(() {
    mockDio = MockDio();
    client = HttpClient(mockDio);
  });

  group('HttpClient GET', () {
    test('call GET devuelve datos correctamente', () async {
      final postJson = {
        'id': 1,
        'userId': 10,
        'title': 'titulo',
        'body': 'cuerpo'
      };

      // Simulamos la respuesta de Dio
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenAnswer((_) async => Response(
                data: [postJson],
                statusCode: 200,
                requestOptions: RequestOptions(path: '/posts'),
              ));

      final result =
          await client.call<List<Post>, Post>('/posts', method: HttpCall.GET);

      expect(result.isError, isFalse);
      expect(result.data!.length, 1);
      expect(result.data!.first.id, 1);

      verify(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).called(1);
    });
    test('call GET devuelve error si Dio lanza exception', () async {
      when(() => mockDio.get(any(),
              queryParameters: any(named: 'queryParameters')))
          .thenThrow(DioException(
              message: 'fail',
              requestOptions: RequestOptions(path: '/posts'), error: 'fail'));

      final result =
          await client.call<List<Post>, Post>('/posts', method: HttpCall.GET);

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'fail');

      verify(() => mockDio.get(any(),
          queryParameters: any(named: 'queryParameters'))).called(1);
    });
  });
}
