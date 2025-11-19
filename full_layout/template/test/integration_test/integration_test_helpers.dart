import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_os_exercise_with_test/app/app.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/client_response.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post/models/post.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post/post_repository.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post_comments/models/post_comment.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post_comments/post_comments_repository.dart';
import 'package:hub_os_exercise_with_test/app/services/posts/posts_cubit.dart';
import 'package:mocktail/mocktail.dart';

// --- Mocks ---
class MockPostRepository extends Mock implements PostRepository {}

class MockPostCommentsRepository extends Mock
    implements PostCommentsRepository {}

Future<void> pumpAppWithMocks(
  WidgetTester tester,
  MockPostRepository mockPostRepo,
  MockPostCommentsRepository mockCommentsRepo,
) async {
  final fakeComment = PostComment(
    id: 1,
    postId: 1,
    userId: 10,
    comment: 'Comentario inicial',
  );
  final fakePost = Post(
    id: 1,
    userId: 10,
    title: 'Titulo',
    body: 'Cuerpo',
    comments: [],
  );

  when(() => mockPostRepo.fetchPosts()).thenAnswer(
      (_) async => ClientResponse(data: [fakePost], isError: false));

  when(() => mockCommentsRepo.getComments()).thenAnswer(
      (_) async => ClientResponse(data: [fakeComment], isError: false));

  // --- Act: arrancar app ---
  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => PostsCubit(
            postsRepo: mockPostRepo,
            commentsRepo: mockCommentsRepo,
          ),
        ),
      ],
      child: HubOsApp(),
    ),
  );

  await tester.pumpAndSettle();

  // --- Assert ---
  expect(find.byKey(Key('dashboard_appbar_title')), findsOneWidget);
  expect(find.byKey(Key('post_widget_1')), findsOneWidget);
  expect(find.text('Titulo'), findsOneWidget);
  expect(find.text('Cuerpo'), findsOneWidget);

  verify(() => mockPostRepo.fetchPosts()).called(1);
  verify(() => mockCommentsRepo.getComments()).called(1);
}
