import 'package:flutter_test/flutter_test.dart';
import 'package:{{PROJECT_NAME}}/app/utils/general_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {});

  group('SharedPreference', () {
    test('Test getString', () async {
      SharedPreferences.setMockInitialValues({'key1': 'value'});
      final result = await getString('key1');
      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result, 'value');
    });

    test('Test setString', () async {
      await setString('key2', 'value2');
      final result = await getString('key2');

      expect(result, isNotNull);
      expect(result, isNotEmpty);
      expect(result, 'value2');
    });
  });
}
