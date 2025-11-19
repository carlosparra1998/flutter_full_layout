import 'package:flutter_test/flutter_test.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/client_response.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/sqflite_client/sqflite_client.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post_comments/models/post_comment.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post_comments/post_comments_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockSqfliteClient extends Mock implements SqfliteClient {}

class FakePostComment extends Fake implements PostComment {}

void main() {
  late MockSqfliteClient mockSqlClient;
  late PostCommentsRepository repository;

  setUp(() {
    mockSqlClient = MockSqfliteClient();
    repository = PostCommentsRepository(mockSqlClient);
  });

  group('getComments', () {
    test('getComments devuelve lista correctamente', () async {
      final comment =
          PostComment(id: 1, postId: 1, userId: 10, comment: 'hola');

      when(() => mockSqlClient.select<List<PostComment>, PostComment>(
                any(),
                columns: any(named: 'columns'),
                where: any(named: 'where'),
              ))
          .thenAnswer(
              (_) async => ClientResponse(data: [comment], isError: false));

      final result = await repository.getComments();

      expect(result.isError, isFalse);
      expect(result.data!.length, 1);
      expect(result.data!.first.comment, 'hola');

      verify(() => mockSqlClient.select<List<PostComment>, PostComment>(
            'post_comments',
            columns: any(named: 'columns'),
            where: any(named: 'where'),
          )).called(1);
    });
    test('getComments falla', () async {
      when(() => mockSqlClient.select<List<PostComment>, PostComment>(
                any(),
                columns: any(named: 'columns'),
                where: any(named: 'where'),
              ))
          .thenAnswer((_) async =>
              ClientResponse(data: null, isError: true, errorMessage: 'fail'));

      final result = await repository.getComments();

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'fail');

      verify(() => mockSqlClient.select<List<PostComment>, PostComment>(
            'post_comments',
            columns: any(named: 'columns'),
            where: any(named: 'where'),
          )).called(1);
    });
  });

  group('setComment', () {
    test('setComment inserta y devuelve id', () async {
      final comment =
          PostComment(id: 0, postId: 1, userId: 10, comment: 'hola');

      when(() => mockSqlClient.insert<PostComment>('post_comments', comment))
          .thenAnswer((_) async => ClientResponse(data: 5, isError: false));

      final result = await repository.setComment(comment);

      expect(result.isError, isFalse);
      expect(result.data, 5);

      verify(() => mockSqlClient.insert<PostComment>('post_comments', comment))
          .called(1);
    });
    test('setComment falla', () async {
      final comment =
          PostComment(id: 0, postId: 1, userId: 10, comment: 'hola');
      when(() => mockSqlClient.insert<PostComment>('post_comments', comment))
          .thenAnswer((_) async =>
              ClientResponse(data: null, isError: true, errorMessage: 'fail'));

      final result = await repository.setComment(comment);

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'fail');

      verify(() => mockSqlClient.insert<PostComment>('post_comments', comment))
          .called(1);
    });
  });

  group('removeComment', () {
    test('removeComment elimina comentario', () async {
      when(() => mockSqlClient.delete('post_comments', where: 'id = 3'))
          .thenAnswer((_) async => ClientResponse(data: 1, isError: false));

      final result = await repository.removeComment(3);

      expect(result.isError, isFalse);
      expect(result.data, 1);

      verify(() => mockSqlClient.delete('post_comments', where: 'id = 3'))
          .called(1);
    });
    test('removeComment falla', () async {
      when(() => mockSqlClient.delete('post_comments', where: 'id = 3'))
          .thenAnswer((_) async =>
              ClientResponse(data: null, isError: true, errorMessage: 'fail'));

      final result = await repository.removeComment(3);

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'fail');

      verify(() => mockSqlClient.delete('post_comments', where: 'id = 3'))
          .called(1);
    });
  });

  group('removeAllCommentsFromPost', () {
    test('removeAllCommentsFromPost elimina comentarios de post', () async {
      when(() => mockSqlClient.delete('post_comments', where: 'postId = 7'))
          .thenAnswer((_) async => ClientResponse(data: 3, isError: false));

      final result = await repository.removeAllCommentsFromPost(7);

      expect(result.isError, isFalse);
      expect(result.data, 3);

      verify(() => mockSqlClient.delete('post_comments', where: 'postId = 7'))
          .called(1);
    });
    test('removeAllCommentsFromPost falla', () async {
      when(() => mockSqlClient.delete('post_comments', where: 'postId = 7'))
          .thenAnswer((_) async =>
              ClientResponse(data: null, isError: true, errorMessage: 'fail'));

      final result = await repository.removeAllCommentsFromPost(7);

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      expect(result.errorMessage, 'fail');

      verify(() => mockSqlClient.delete('post_comments', where: 'postId = 7'))
          .called(1);
    });
  });
}
