import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wells_import_cars_app/config/api_config.dart';

void main() {
  test('usa localhost por defecto fuera de Android', () {
    if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
      expect(ApiConfig.baseUrl, 'http://localhost:5142');
    }
  });

  test('la URL base no termina con diagonal', () {
    expect(ApiConfig.baseUrl.endsWith('/'), isFalse);
  });
}
