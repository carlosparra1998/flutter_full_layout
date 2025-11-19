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

  testWidgets('Apertura app', (WidgetTester tester) async {
    await pumpAppWithMocks(tester, mockPostRepo, mockCommentsRepo);
  });
}
