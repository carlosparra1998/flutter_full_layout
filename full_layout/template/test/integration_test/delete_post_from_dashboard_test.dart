import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hub_os_exercise_with_test/app/repositories/clients/client_response.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import 'integration_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockPostRepository mockPostRepo;
  late MockPostCommentsRepository mockCommentsRepo;

  setUp(() {
    mockPostRepo = MockPostRepository();
    mockCommentsRepo = MockPostCommentsRepository();
  });

  testWidgets('Delete post', (WidgetTester tester) async {
    await pumpAppWithMocks(tester, mockPostRepo, mockCommentsRepo);

    when(() => mockCommentsRepo.removeAllCommentsFromPost(1)).thenAnswer(
        (_) async => ClientResponse(data: 1, isError: false));

    await tester.drag(
      find.byKey(Key('dismissible_post_1')),
      const Offset(-500, 0),
    );
    await tester.pumpAndSettle();
    expect(find.byKey(Key('post_widget_1')), findsNothing);

    verify(() => mockCommentsRepo.removeAllCommentsFromPost(1)).called(1);
  });
}
