import 'package:flutter_test/flutter_test.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/sqflite_client/sqflite_client.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post_comments/models/post_comment.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements Database {}

class FakePostComment extends Fake implements PostComment {}

void main() {
  late MockDatabase mockDb;
  late SqfliteClient client;

  setUpAll(() {
    registerFallbackValue(FakePostComment());
  });

  setUp(() {
    mockDb = MockDatabase();
    client = SqfliteClient(mockDb);
  });

  group('SqfliteClient select', () {
    test('select OK', () async {
      final rows = [
        {'id': 1, 'postId': 1, 'userId': 10, 'comment': 'hola'}
      ];
      when(() => mockDb.query('post_comments', columns: null, where: null))
          .thenAnswer((_) async => rows);

      final result =
          await client.select<List<PostComment>, PostComment>('post_comments');

      expect(result.isError, isFalse);
      expect(result.data!.length, 1);
      expect(result.data!.first.comment, 'hola');
      verify(() => mockDb.query('post_comments', columns: null, where: null))
          .called(1);
    });
    test('select KO', () async {
      when(() => mockDb.query('post_comments', columns: null, where: null))
          .thenThrow(Exception('fail'));

      final result =
          await client.select<List<PostComment>, PostComment>('post_comments');

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      verify(() => mockDb.query('post_comments', columns: null, where: null))
          .called(1);
    });
  });
  group('SqfliteClient insert', () {
    test('insert OK', () async {
      final comment =
          PostComment(id: 0, postId: 1, userId: 10, comment: 'hola');
      when(() => mockDb.insert('post_comments', comment.toJson()))
          .thenAnswer((_) async => 5);

      final result = await client.insert<PostComment>('post_comments', comment);

      expect(result.isError, isFalse);
      expect(result.data, 5);
      verify(() => mockDb.insert('post_comments', comment.toJson())).called(1);
    });
    test('insert KO', () async {
      final comment =
          PostComment(id: 0, postId: 1, userId: 10, comment: 'hola');
      when(() => mockDb.insert('post_comments', comment.toJson()))
          .thenThrow(Exception('fail'));

      final result = await client.insert<PostComment>('post_comments', comment);

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      verify(() => mockDb.insert('post_comments', comment.toJson())).called(1);
    });
  });
  group('SqfliteClient delete', () {
    test('delete OK', () async {
      when(() => mockDb.delete('post_comments', where: 'id = 3'))
          .thenAnswer((_) async => 1);

      final result = await client.delete('post_comments', where: 'id = 3');

      expect(result.isError, isFalse);
      expect(result.data, 1);
      verify(() => mockDb.delete('post_comments', where: 'id = 3')).called(1);
    });
    test('delete KO', () async {
      when(() => mockDb.delete('post_comments', where: 'id = 3'))
          .thenThrow(Exception('fail'));

      final result = await client.delete('post_comments', where: 'id = 3');

      expect(result.isError, isTrue);
      expect(result.data, isNull);
      verify(() => mockDb.delete('post_comments', where: 'id = 3')).called(1);
    });
  });
}
