import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ApiService {
  final String baseUrl = 'http://10.0.2.2:8000/api';
  String? accessToken;
  String? refreshToken;

  apiService() {
    _loadTokens();
  }

  Future<void> _saveUserSession(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
    this.accessToken = accessToken;
    this.refreshToken = refreshToken;
  }

  Future<void> _loadTokens() async {
    final prefs = await SharedPreferences.getInstance();
    accessToken = prefs.getString('access_token');
    refreshToken = prefs.getString('refresh_token');
  }

  //verifica si el usuario esta logueado
  Future<bool> isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');

    if (token != null) {
      accessToken = token;
      refreshToken = prefs.getString('refresh_token');
      return true;
    }
    return false;
  }

  //refrescar el token si expira
  Future<bool> _refreshAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    final currentRefreshToken = prefs.getString('refresh_token');

    if (currentRefreshToken == null) {
      print('No hay refresh token disponible');
      return false;
    }

    final url = Uri.parse('$baseUrl/usuarios/auth/refresh/');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refresh': currentRefreshToken}),
    );

    print('STATUS CODE: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newAccessToken = data['access'];

      // Actualizar el access token en memoria inmediatamente
      accessToken = newAccessToken;

      // Guardar el nuevo access token
      await prefs.setString('access_token', newAccessToken);

      // Solo actualizar refresh token si viene en la respuesta
      if (data.containsKey('refresh') && data['refresh'] != null) {
        final newRefreshToken = data['refresh'];
        refreshToken = newRefreshToken;
        await prefs.setString('refresh_token', newRefreshToken);
        print('Nuevo refresh token: $newRefreshToken');
      } else {
        // Si no viene nuevo refresh token, mantener el actual
        print('Refresh token no actualizado, manteniendo el actual');
      }

      print('Nuevo access token: $newAccessToken');
      return true;
    } else {
      print('Falló el refresh del token: ${response.body}');
      // Si falla el refresh, limpiar tokens y requerir login
      await logout();
      return false;
    }
  }

  //elimina la sesion del usuario
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    accessToken = null;
    refreshToken = null;
  }

  /*  //login del usuario
  Future<Usuario> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/auth/login/'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    print('STATUS CODE: ${response.statusCode}');
    print('BODY: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final loginResponse = LogingResponse.fromJson(data);

      await _saveUserSession(loginResponse.access, loginResponse.refresh);
      return loginResponse.user;
    } else if (response.statusCode == 401 || response.statusCode == 400) {
      throw Exception('Credenciales incorrectas');
    } else {
      throw Exception('Error al iniciar sesion');
    }
  }*/

  //-----------------------FUNCIONES GENERALES CRUD-----------------------
  Future<List<dynamic>> getList(String endpoint) async {
    await _loadTokens();

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body) as List<dynamic>;
    } else if (response.statusCode == 401) {
      final success = await _refreshAuthToken();
      if (success) {
        return await getList(endpoint);
      } else {
        throw Exception('Token inválido y no se pudo refrescar');
      }
    } else {
      throw Exception('GET ${response.statusCode}: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> get(String endpoint) async {
    // Asegurar que tenemos los tokens cargados
    await _loadTokens();

    print('Access token para GET: $accessToken');

    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    print('GET $endpoint - Status: ${response.statusCode}');

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      print("Token expirado. Intentando refrescar...");
      final success = await _refreshAuthToken();
      if (success) {
        // Reintentar con el nuevo token
        return await get(endpoint);
      } else {
        throw Exception(
          'Token inválido y no se pudo refrescar. Requiere login.',
        );
      }
    } else {
      throw Exception('GET ${response.statusCode}: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> post(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    await _loadTokens();

    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      final success = await _refreshAuthToken();
      if (success) {
        return await post(endpoint, body);
      } else {
        throw Exception('Token inválido y no se pudo refrescar');
      }
    } else {
      throw Exception('POST ${response.statusCode}: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> put(
    String endpoint,
    Map<String, dynamic> body,
  ) async {
    await _loadTokens();

    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body),
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      final success = await _refreshAuthToken();
      if (success) {
        return await put(endpoint, body);
      } else {
        throw Exception('Token inválido y no se pudo refrescar');
      }
    } else {
      throw Exception('PUT ${response.statusCode}: ${response.body}');
    }
  }

  Future<void> delete(String endpoint) async {
    await _loadTokens();

    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Authorization': 'Bearer $accessToken',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      if (response.statusCode == 401) {
        final success = await _refreshAuthToken();
        if (success) {
          return await delete(endpoint);
        } else {
          throw Exception('Token inválido y no se pudo refrescar');
        }
      } else {
        throw Exception('DELETE ${response.statusCode}: ${response.body}');
      }
    }
  }

  //----------------------------------------------------------------------
}
