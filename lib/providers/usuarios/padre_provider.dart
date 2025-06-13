import 'package:flutter/material.dart';
import 'package:aula_virtual/models/usuarios/padre.dart';
import 'package:aula_virtual/services/api_service.dart';

class PadreProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Padre> _padres = [];
  Padre? _selectedPadre;
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Padre> get padres => _padres;
  Padre? get selectedPadre => _selectedPadre;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Cargar todos los padres
  Future<void> fetchPadres() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _apiService.get('/padres/'); // Asegúrate que sea la URL correcta
      final List<dynamic> results = data['results'];
      _padres = results.map((json) => Padre.fromJson(json)).toList();
    } catch (e) {
      _error = 'Error al cargar padres: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getPadreById(int id) async {
    _isLoading = true;
    try {
      final data = await ApiService().get(
        '/padres/$id',
      ); // <- corregir URL si era incorrecta
      _selectedPadre = Padre.fromJson(
        data,
      ); // <-- ahora sí, ya que data es Map<String, dynamic>
    } catch (e) {
      print('Error al cargar Padre por ID: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Establecer padre seleccionado
  void setSelectedPadre(Padre padre) {
    _selectedPadre = padre;
    notifyListeners();
  }

  // Limpiar selección y errores
  void clear() {
    _selectedPadre = null;
    _error = null;
    notifyListeners();
  }
}
