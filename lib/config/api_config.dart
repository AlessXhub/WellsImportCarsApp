import 'package:flutter/foundation.dart';

class ApiConfig {
  const ApiConfig._();

  static const String _configuredBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );

  /// Uses the host alias required by the active Flutter platform.
  ///
  /// Android emulators reach the development PC through 10.0.2.2. Desktop
  /// and web builds run on the PC itself, so localhost is correct there. A
  /// physical phone must still receive the PC's LAN address with
  /// --dart-define=API_BASE_URL=http://192.168.X.X:5142.
  static String get baseUrl {
    if (_configuredBaseUrl.trim().isNotEmpty) {
      return _withoutTrailingSlash(_configuredBaseUrl.trim());
    }
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:5142';
    }
    return 'http://localhost:5142';
  }

  static String _withoutTrailingSlash(String value) =>
      value.endsWith('/') ? value.substring(0, value.length - 1) : value;

  static const Duration timeout = Duration(seconds: 10);
}
