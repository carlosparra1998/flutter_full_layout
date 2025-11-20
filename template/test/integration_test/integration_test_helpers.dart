import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{PROJECT_NAME}}/app/app.dart';
import 'package:{{PROJECT_NAME}}/app/repositories/clients/http_client/http_client.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

Future<void> pumpAppWithMocks(
  WidgetTester tester,
  MockHttpClient client,
) async {
  await tester.pumpWidget(BaseApp(client));
  await tester.pumpAndSettle();

  expect(find.byKey(Key('appbar_login')), findsOneWidget);
  expect(find.byKey(Key('login_email_textfield')), findsOneWidget);
  expect(find.byKey(Key('login_password_textfield')), findsOneWidget);
  expect(find.byKey(Key('login_button')), findsOneWidget);
}
