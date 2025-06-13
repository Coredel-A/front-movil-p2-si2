import 'package:aula_virtual/models/colegio/materia.dart';
import 'package:flutter/material.dart';
import '../../models/colegio/curso.dart';
import '../../services/api_service.dart';

class CursoProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Curso> _cursos = [];
  Curso? _currentCurso;
  bool _isLoading = false;

  List<Curso> get cursos => _cursos;
  Curso? get currentCurso => _currentCurso;
  bool get isLoading => _isLoading;

  Future<void> fetchCursos() async {
    _isLoading = true;
    _cursos = [];
    try {
      int page = 1;
      bool hayMas = true;
      while (hayMas) {
        final data = await _apiService.get('/cursos/');
        final List<dynamic> results = data['results'];

        final cursosPagina = results.map((e) => Curso.fromJson(e)).toList();
        _cursos.addAll(cursosPagina);

        hayMas = data['next'] != null;
        page++;
      }
      print("Cursos cargados: ${_cursos.length}");
    } catch (e) {
      print('Error al cargar Cursos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCursoById(int id) async {
    _isLoading = true;
    try {
      final data = await ApiService().get('/cursos/$id/');
      _currentCurso = Curso.fromJson(data);
      print('Curso obtenido: ${_currentCurso!.nombre}');
    } catch (e) {
      print('Error al cargar Curso por ID: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchCursosByDocenteId(int docenteId) async {
    _isLoading = true;
    _cursos = [];

    try {
      int page = 1;
      bool hayMas = true;
      final Set<int?> cursoIds = {};
      while (hayMas) {
        final data = await _apiService.get(
          '/materias/?docente_id=$docenteId&page=$page',
        );
        final List<dynamic> results = data['results'];

        final materias = results.map((e) => Materia.fromJson(e)).toList();
        cursoIds.addAll(materias.map((m) => m.curso_id));

        hayMas = data['next'] != null;
        page++;
      }
      cursoIds.removeWhere((id) => id == null);
      for (var id in cursoIds) {
        final cursoData = await _apiService.get('/cursos/$id/');
        _cursos.add(Curso.fromJson(cursoData));
      }
      print("Cursos del docente $docenteId cargados: ${_cursos.length}");
    } catch (e) {
      print("Error al cargar cursos del docente $docenteId: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
