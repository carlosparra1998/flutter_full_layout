import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/client_response.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post/models/post.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post/post_repository.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post_comments/models/post_comment.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post_comments/post_comments_repository.dart';
import 'package:hub_os_exercise_with_test/app/services/posts/posts_cubit.dart';
import 'package:mocktail/mocktail.dart';

// --- MOCKS & FAKES ---

class MockPostRepository extends Mock implements PostRepository {}

class MockPostCommentsRepository extends Mock
    implements PostCommentsRepository {}

// mocktail requires fakes for any non-nullable custom types used with `any()` or as parameters
class FakePost extends Fake implements Post {}

class FakePostComment extends Fake implements PostComment {}

class FakeBuildContext extends Fake implements BuildContext {}

void main() {
  // Registrar fakes una vez antes de los tests
  setUpAll(() {
    registerFallbackValue(FakePost());
    registerFallbackValue(FakePostComment());
    registerFallbackValue(FakeBuildContext());
  });

  late MockPostRepository mockPostRepo;
  late MockPostCommentsRepository mockCommentsRepo;
  late PostsCubit cubit;

  setUp(() {
    mockPostRepo = MockPostRepository();
    mockCommentsRepo = MockPostCommentsRepository();

    cubit = PostsCubit(
      postsRepo: mockPostRepo,
      commentsRepo: mockCommentsRepo,
    );
  });

  tearDown(() {
    // si tu cubit necesita ser cerrado
    cubit.close();
  });

  group('PostsCubit.initService', () {
    test('carga posts y comments correctamente (success path)', () async {
      // arrange: posts returned by HTTP
      final post = Post(id: 1, userId: 10, comments: [], title: '', body: '');
      when(() => mockPostRepo.fetchPosts()).thenAnswer(
        (_) async => ClientResponse<List<Post>>(
          data: [post],
          isError: false,
          errorMessage: null,
        ),
      );

      // arrange: comments returned by SQL
      final comment =
          PostComment(id: 1, postId: 1, userId: 10, comment: 'hola');
      when(() => mockCommentsRepo.getComments()).thenAnswer(
        (_) async => ClientResponse<List<PostComment>>(
          data: [comment],
          isError: false,
          errorMessage: null,
        ),
      );

      // act
      await cubit.initService();

      // assert
      expect(cubit.httpError, isFalse);
      expect(cubit.sqlError, isFalse);
      expect(cubit.posts.length, 1);
      expect(cubit.posts.first.id, 1);
      expect(cubit.posts.first.comments.length, 1);
      expect(cubit.posts.first.comments.first.comment, 'hola');

      verify(() => mockPostRepo.fetchPosts()).called(1);
      verify(() => mockCommentsRepo.getComments()).called(1);
    });

    test('si fetchPosts falla, setea httpError y no llama sql', () async {
      when(() => mockPostRepo.fetchPosts()).thenAnswer(
        (_) async => ClientResponse<List<Post>>(
          data: null,
          isError: true,
          errorMessage: 'http fail',
        ),
      );

      // act
      await cubit.initService();

      // assert
      expect(cubit.httpError, isTrue);
      expect(cubit.sqlError, isFalse);
      expect(cubit.posts, isEmpty);

      verify(() => mockPostRepo.fetchPosts()).called(1);
      verifyNever(() => mockCommentsRepo.getComments());
    });

    test('si getComments falla, setea sqlError', () async {
      final post = Post(id: 2, userId: 5, comments: [], body: '', title: '');
      when(() => mockPostRepo.fetchPosts()).thenAnswer(
        (_) async => ClientResponse<List<Post>>(
          data: [post],
          isError: false,
          errorMessage: null,
        ),
      );

      when(() => mockCommentsRepo.getComments()).thenAnswer(
        (_) async => ClientResponse<List<PostComment>>(
          data: null,
          isError: true,
          errorMessage: 'db fail',
        ),
      );

      // act
      await cubit.initService();

      // assert
      expect(cubit.httpError, isFalse);
      expect(cubit.sqlError, isTrue);
      expect(cubit.posts.length, 1); // posts cargados aún si comments fallan
      verify(() => mockPostRepo.fetchPosts()).called(1);
      verify(() => mockCommentsRepo.getComments()).called(1);
    });
  });

  group('PostsCubit addComment', () {
    test('addComment satisfactorio', () async {
      final post = Post(id: 7, userId: 2, comments: [], title: '', body: '');
      cubit.posts = [post];
      final userComment = 'Hola mundo';
      when(() => mockCommentsRepo.setComment(any())).thenAnswer(
        (_) async =>
            ClientResponse<int>(data: 100, isError: false, errorMessage: null),
      );
      // Act
      await cubit.addComment(userComment, post);

      // Assert
      expect(cubit.posts.first.comments.length, 1);
      expect(cubit.posts.first.comments.first.comment, 'Hola mundo');
      expect(cubit.posts.first.comments.first.id, 100);

      // Verifica que el repositorio fue llamado
      verify(() => mockCommentsRepo.setComment(any())).called(1);
    });
    test('addComment no hace nada si userComment es null', () async {
      final post = Post(id: 1, userId: 10, comments: [], title: '', body: '');
      cubit.posts = [post];

      await cubit.addComment(null, post);

      expect(cubit.posts.first.comments, isEmpty);
      verifyNever(() => mockCommentsRepo.setComment(any()));
    });
    test('addComment no agrega comentario si el repositorio falla', () async {
      final post = Post(id: 1, userId: 10, comments: [], title: '', body: '');
      cubit.posts = [post];

      final userComment = 'Hola error';

      when(() => mockCommentsRepo.setComment(any())).thenAnswer(
        (_) async => ClientResponse<int>(
            data: null, isError: true, errorMessage: 'fail'),
      );

      await cubit.addComment(userComment, post);

      expect(cubit.posts.first.comments, isEmpty);
      verify(() => mockCommentsRepo.setComment(any())).called(1);
    });
  });

  group('PostsCubit removeComment / removePost', () {
    test(
        'removeComment elimina el comentario de la lista cuando repo responde ok',
        () async {
      // arrange: un post con un comentario
      final comment = PostComment(id: 3, postId: 7, userId: 2, comment: 'x');
      final post =
          Post(id: 7, userId: 2, comments: [comment], title: '', body: '');
      cubit.posts = [post];

      when(() => mockCommentsRepo.removeComment(3)).thenAnswer(
        (_) async =>
            ClientResponse<int>(data: 1, isError: false, errorMessage: null),
      );

      // act: pasa un BuildContext fake (no usado en la implementación)
      await cubit.removeComment(comment);

      // assert
      expect(cubit.posts.first.comments, isEmpty);
      verify(() => mockCommentsRepo.removeComment(3)).called(1);
    });

    test('removeComment no hace nada si repo falla', () async {
      final comment = PostComment(id: 4, postId: 8, userId: 2, comment: 'y');
      final post =
          Post(id: 8, userId: 2, comments: [comment], title: '', body: '');
      cubit.posts = [post];

      when(() => mockCommentsRepo.removeComment(4)).thenAnswer(
        (_) async => ClientResponse<int>(
            data: null, isError: true, errorMessage: 'fail'),
      );

      await cubit.removeComment(comment);

      // comentario sigue presente
      expect(cubit.posts.first.comments.length, 1);
      verify(() => mockCommentsRepo.removeComment(4)).called(1);
    });

    test('removePost borra post cuando repo responde ok', () async {
      final post = Post(id: 9, userId: 3, comments: [], title: '', body: '');
      cubit.posts = [post];

      when(() => mockCommentsRepo.removeAllCommentsFromPost(9)).thenAnswer(
        (_) async =>
            ClientResponse<int>(data: 1, isError: false, errorMessage: null),
      );

      await cubit.removePost(post);

      expect(cubit.posts, isEmpty);
      verify(() => mockCommentsRepo.removeAllCommentsFromPost(9)).called(1);
    });

    test('removePost no borra si repo falla', () async {
      final post = Post(id: 10, userId: 3, comments: [], title: '', body: '');
      cubit.posts = [post];

      when(() => mockCommentsRepo.removeAllCommentsFromPost(10)).thenAnswer(
        (_) async => ClientResponse<int>(
            data: null, isError: true, errorMessage: 'fail'),
      );

      await cubit.removePost(post);

      expect(cubit.posts.length, 1);
      verify(() => mockCommentsRepo.removeAllCommentsFromPost(10)).called(1);
    });
  });
}
