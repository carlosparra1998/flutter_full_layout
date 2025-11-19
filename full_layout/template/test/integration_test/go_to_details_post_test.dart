import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'integration_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockPostRepository mockPostRepo;
  late MockPostCommentsRepository mockCommentsRepo;

  setUp(() {
    mockPostRepo = MockPostRepository();
    mockCommentsRepo = MockPostCommentsRepository();
  });

  testWidgets('Go to details', (WidgetTester tester) async {
    await pumpAppWithMocks(tester, mockPostRepo, mockCommentsRepo);
    await tester.tap(find.byKey(Key('post_widget_1')));
    await tester.pumpAndSettle();
    expect(find.byKey(Key('content_app_bar_title')), findsOneWidget);
    expect(find.byKey(Key('comment_widget_1')), findsOneWidget);
    expect(find.text('Titulo'), findsOneWidget);
    expect(find.text('Cuerpo'), findsOneWidget);
  });
}
