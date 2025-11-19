import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:full_layout_base/app/services/language/language_cubit.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() {});

  late LanguageCubit cubit;

  setUp(() {
    cubit = LanguageCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('LanguageCubit.initProvider', () {
    test('initProvider', () async {
      cubit.initProvider();
      expect(cubit.locale, isNotNull);
      expect(cubit.locale!.languageCode, 'es');
    });
  });

  group('LanguageCubit.changeLanguage', () {
    test('changeLanguage', () async {
      cubit.changeLanguage(Locale('en'));
      expect(cubit.locale, isNotNull);
      expect(cubit.locale!.languageCode, 'en');
    });
  });
}
