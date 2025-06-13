import 'package:flutter/material.dart';
import '../../models/colegio/materia.dart';
import '../../services/api_service.dart';

class MateriaProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Materia> _materias = [];
  Materia? _currentMateria;
  bool _isLoading = false;

  List<Materia> get materias => _materias;
  Materia? get currentMateria => _currentMateria;
  bool get isLoading => _isLoading;

  Map<int, String> _materiaNombres = {};

  bool _hasMore = true;
  bool _isFetchingMore = false;

  bool get hasMore => _hasMore;
  bool get isFetchingMore => _isFetchingMore;

  Future<void> fetchMaterias() async {
    _isLoading = true;
    _materias = [];
    try {
      int page = 1;
      bool hayMas = true;
      while (hayMas) {
        final data = await _apiService.get('/materias/?page=$page');
        final List<dynamic> results = data['results'];

        final materiasPagina = results.map((e) => Materia.fromJson(e)).toList();
        _materias.addAll(materiasPagina);

        hayMas = data['next'] != null;
        page++;
      }
      print("Materias del docente cargadas: ${_materias.length}");
    } catch (e) {
      print('Error al cargar Materias: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMateriaById(int materiaId) async {
    _isLoading = true;
    try {
      final data = await _apiService.get('/materias/$materiaId/');
      _currentMateria = Materia.fromJson(data);
    } catch (e) {
      print('Error al cargar el Materia $materiaId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMateriasByDocente(int docenteId) async {
    _isLoading = true;
    _materias = [];
    try {
      int page = 1;
      bool hayMas = true;

      while (hayMas) {
        final data = await _apiService.get(
          '/materias/?docente_id=$docenteId&page=$page',
        );
        final List<dynamic> results = data['results'];

        final materiasPagina = results.map((e) => Materia.fromJson(e)).toList();
        _materias.addAll(materiasPagina);

        hayMas = data['next'] != null;
        page++;
      }

      print("✅ Materias del docente cargadas: ${_materias.length}");
    } catch (e) {
      print("❌ Error al cargar materias del docente: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String> fetchNombreMateriaById(int materiaId) async {
    try {
      final data = await _apiService.get('/materias/$materiaId/');
      final materia = Materia.fromJson(data);
      return materia.nombre;
    } catch (e) {
      print('❌ Error al obtener el nombre de la materia $materiaId: $e');
      return 'Materia desconocida';
    }
  }

  Future<void> preloadNombreMaterias(List<int> materiaIds) async {
    for (var id in materiaIds) {
      if (!_materiaNombres.containsKey(id)) {
        final nombre = await fetchNombreMateriaById(id);
        _materiaNombres[id] = nombre;
      }
    }
    notifyListeners();
  }

  String getNombreMateria(int materiaId) {
    return _materiaNombres[materiaId] ?? 'Materia';
  }
}
