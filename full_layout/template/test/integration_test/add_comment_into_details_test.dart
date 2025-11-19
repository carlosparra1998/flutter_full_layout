import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/client_response.dart';
import 'package:hub_os_exercise_with_test/app/repositories/repositories/post_comments/models/post_comment.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import 'integration_test_helpers.dart';

class FakePostComment extends Fake implements PostComment {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakePostComment());
  });
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockPostRepository mockPostRepo;
  late MockPostCommentsRepository mockCommentsRepo;

  setUp(() {
    mockPostRepo = MockPostRepository();
    mockCommentsRepo = MockPostCommentsRepository();
  });

  testWidgets('Add comment', (WidgetTester tester) async {
    await pumpAppWithMocks(tester, mockPostRepo, mockCommentsRepo);

    when(() => mockCommentsRepo.setComment(any()))
        .thenAnswer((_) async => ClientResponse(data: 2, isError: false));

    await tester.tap(find.byKey(Key('post_widget_1')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('content_app_bar_title')), findsOneWidget);
    expect(find.byKey(Key('comment_widget_1')), findsOneWidget);
    expect(find.text('Titulo'), findsOneWidget);
    expect(find.text('Cuerpo'), findsOneWidget);

    await tester.tap(find.byKey(Key('add_comment_floating')));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(Key('comment_text_field_adder')), 'Segundo comentario');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('comment_button_adder')));
    await tester.pumpAndSettle();

    expect(find.text('Segundo comentario'), findsOneWidget);

    verify(() => mockCommentsRepo.setComment(any())).called(1);
  });
}
