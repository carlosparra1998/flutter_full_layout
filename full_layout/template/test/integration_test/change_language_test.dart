import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_layout_base/app/enums/http_call.dart';
import 'package:full_layout_base/app/repositories/clients/client_response.dart';
import 'package:full_layout_base/app/repositories/repositories/auth/models/auth_session.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mocktail/mocktail.dart';

import 'integration_test_helpers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockHttpClient client;

  setUp(() {
    client = MockHttpClient();
  });

  testWidgets('Inicio de sesión', (WidgetTester tester) async {
    await pumpAppWithMocks(tester, client);

    expect(find.text('Login'), findsOne);
    expect(find.text('Inicio de sesión'), findsNothing);

    await tester.tap(find.byKey(Key('dropdown_languages')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('dropdown_languages_es')).last);
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsNothing);
    expect(find.text('Inicio de sesión'), findsOne);

    when(
      () => client.call<AuthSession, AuthSession>(
        any(),
        method: HttpCall.POST,
        data: any(named: 'data'),
        queryParameters: any(named: 'queryParameters'),
        tokenRequired: any(named: 'tokenRequired'),
      ),
    ).thenAnswer(
      (_) async => ClientResponse(
        data: AuthSession(accessToken: 'access', refreshToken: 'refresh'),
        isError: false,
      ),
    );

    await tester.enterText(find.byKey(Key('login_email_textfield')), 'login');
    await tester.enterText(find.byKey(Key('login_password_textfield')), 'pass');
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(Key('login_button')));
    await tester.pumpAndSettle();

    expect(find.text('Home'), findsOne);
    expect(find.text('Sesión iniciada'), findsOne);
  });
}
