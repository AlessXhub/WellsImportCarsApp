import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';

class ApiException implements Exception {
  const ApiException(this.message, {this.statusCode});
  final String message;
  final int? statusCode;
  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();
  final http.Client _client;

  Future<dynamic> get(String path, {String? token}) =>
      _send('GET', path, token: token);
  Future<dynamic> post(
    String path,
    Map<String, dynamic> body, {
    String? token,
  }) => _send('POST', path, token: token, body: body);

  Future<dynamic> _send(
    String method,
    String path, {
    String? token,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final headers = <String, String>{
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }
    try {
      final response = method == 'GET'
          ? await _client.get(uri, headers: headers).timeout(ApiConfig.timeout)
          : await _client
                .post(uri, headers: headers, body: jsonEncode(body))
                .timeout(ApiConfig.timeout);
      final decoded = response.bodyBytes.isEmpty
          ? null
          : jsonDecode(utf8.decode(response.bodyBytes));
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return decoded;
      }
      throw ApiException(
        _message(decoded, response.statusCode),
        statusCode: response.statusCode,
      );
    } on ApiException {
      rethrow;
    } on TimeoutException {
      throw const ApiException(
        'La API tardó demasiado en responder. Intenta nuevamente.',
      );
    } on SocketException {
      throw ApiException(
        'No se pudo conectar con la API en ${ApiConfig.baseUrl}. Verifica que esté encendida y que la URL corresponda al dispositivo.',
      );
    } on http.ClientException {
      throw ApiException(
        'No se pudo establecer comunicación con la API en ${ApiConfig.baseUrl}.',
      );
    } on FormatException {
      throw const ApiException('La API devolvió una respuesta JSON no válida.');
    }
  }

  String _message(dynamic data, int status) {
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) return data['message'] as String;
      if (data['title'] is String) return data['title'] as String;
      if (data['errors'] is Map) {
        final values = (data['errors'] as Map).values
            .expand((e) => e is List ? e : [e])
            .join(' ');
        if (values.isNotEmpty) return values;
      }
    }
    return switch (status) {
      400 => 'Los datos enviados no son válidos.',
      401 => 'La sesión no es válida o expiró.',
      403 => 'No tienes permiso para realizar esta acción.',
      404 => 'No se encontró el registro solicitado.',
      409 => 'La operación entra en conflicto con datos existentes.',
      _ => 'La API respondió con un error HTTP $status.',
    };
  }
}
