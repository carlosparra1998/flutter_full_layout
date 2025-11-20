import 'package:{{PROJECT_NAME}}/app/utils/general_utils.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {});

  group('isTokenExpired', () {
    test('No expire (until 3000 year)', () async {
      String token = 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjMyNTAzNjgwMDAwfQ.sig';
      final result = isTokenExpired(token);
      expect(result, isFalse);
    });

    test('Expire', () async {
      String token = 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOjk0NjY4NDgwMH0.sig';
      final result = isTokenExpired(token);
      expect(result, isTrue);
    });

    test('Invalid (no points)', () async {
      String token = 'invalidtoken';
      final result = isTokenExpired(token);
      expect(result, isTrue);
    });

    test('Invalid (no base64)', () async {
      String token = 'aaa.bbb.ccc';
      final result = isTokenExpired(token);
      expect(result, isTrue);
    });

    test('Invalid (no exp)', () async {
      String token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjMifQ.sig';
      final result = isTokenExpired(token);
      expect(result, isTrue);
    });

    test('Invalid (no int exp)', () async {
      String token = 'eyJhbGciOiJIUzI1NiJ9.eyJleHAiOiJub3RfaW50In0.sig';
      final result = isTokenExpired(token);
      expect(result, isTrue);
    });
  });
}
