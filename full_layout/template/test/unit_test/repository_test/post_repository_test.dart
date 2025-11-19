import 'package:flutter_test/flutter_test.dart';
import 'package:hub_os_exercise_with_test/app/enums/http_call.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/client_response.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/http_client/http_client.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post/models/post.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post/post_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

class FakePost extends Fake implements Post {}

void main() {
  late MockHttpClient mockHttpClient;
  late PostRepository repository;

  setUpAll(() {
    registerFallbackValue(FakePost());
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    repository = PostRepository(mockHttpClient);
  });

  group('PostRepository.fetchPosts', () {
    test('retorna lista de posts correctamente', () async {
      // Arrange
      final post = Post(
          id: 1, userId: 10, title: 'Titulo', body: 'Cuerpo', comments: []);
      when(() => mockHttpClient.call<List<Post>, Post>(
                any(),
                method: HttpCall.GET,
                data: any(named: 'data'),
                queryParameters: any(named: 'queryParameters'),
              ))
          .thenAnswer(
              (_) async => ClientResponse(data: [post], isError: false));

      // Act
      final result = await repository.fetchPosts();

      // Assert
      expect(result.isError, isFalse);
      expect(result.data!.length, 1);
      expect(result.data!.first.id, 1);
      verify(() => mockHttpClient.call<List<Post>, Post>(
            any(),
            method: HttpCall.GET,
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
          )).called(1);
    });

    test('retorna error si HttpClient falla', () async {
      // Arrange
      when(() => mockHttpClient.call<List<Post>, Post>(
                any(),
                method: HttpCall.GET,
                data: any(named: 'data'),
                queryParameters: any(named: 'queryParameters'),
              ))
          .thenAnswer((_) async => ClientResponse<List<Post>>(
              data: null, isError: true, errorMessage: 'fail'));

      // Act
      final result = await repository.fetchPosts();

      // Assert
      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'fail');
      verify(() => mockHttpClient.call<List<Post>, Post>(
            any(),
            method: HttpCall.GET,
            data: any(named: 'data'),
            queryParameters: any(named: 'queryParameters'),
          )).called(1);
    });
  });
}
