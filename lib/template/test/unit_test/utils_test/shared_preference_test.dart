import 'package:flutter_test/flutter_test.dart';
import 'package:{{PROJECT_NAME}}/app/utils/general_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {});

  group('SharedPreference', () {
    test('Test getString', () async {
      SharedPreferences.setMockInitialValues({'key1': 'value'});
      final result = await getStringSharedPreferences('key1');
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result, 'value');
    });

    test('Test setString', () async {
      await setStringSharedPreferences('key2', 'value2');
      final result = await getStringSharedPreferences('key2');

      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result, 'value2');
    });
  });
}
