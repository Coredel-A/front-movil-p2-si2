import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:aula_virtual/models/usuarios/login_response.dart';
import 'package:aula_virtual/services/api_service.dart';

class AuthProvider with ChangeNotifier {
  LoginResponse? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  LoginResponse? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _currentUser != null;

  // Método para hacer login
  Future<bool> login(String username, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final apiService = ApiService();
      
      // Datos para el login
      final loginData = {
        'username': username,
        'password': password,
      };

      // Llamada al API (asumiendo que tienes un método post en ApiService)
      final response = await apiService.post('/login/', loginData);
      
      if (response != null) {
        _currentUser = LoginResponse.fromJson(response);
        
        // Guardar tokens en SharedPreferences
        await _saveTokens(_currentUser!.accessToken, _currentUser!.refreshToken);
        
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = 'Error en el servidor';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'Error de conexión: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Método para logout
  Future<void> logout() async {
    _currentUser = null;
    await _clearTokens();
    notifyListeners();
  }

  // Guardar tokens en SharedPreferences
  Future<void> _saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);
  }

  // Limpiar tokens
  Future<void> _clearTokens() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    await prefs.remove('refresh_token');
  }

  // Verificar si hay tokens guardados al iniciar la app
  Future<void> checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final accessToken = prefs.getString('access_token');
    
    if (accessToken != null) {
      // Aquí podrías validar el token con el servidor
      // Por ahora asumimos que si existe el token, el usuario está logueado
      // En una implementación real, deberías verificar si el token sigue siendo válido
    }
  }

  // Limpiar mensaje de error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}