import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_layout_base/app/widgets/loader.dart';

void main() {
  setUp(() {
  });
  testWidgets('ArcLoader renders correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: Scaffold(body: ArcLoader())),
    );

    expect(find.byType(ArcLoader), findsOneWidget);
    expect(find.byType(CustomPaint), findsAny);
  });
}
