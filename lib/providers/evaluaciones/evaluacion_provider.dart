import 'package:flutter/material.dart';
import '../../models/evaluaciones/evaluacion.dart';
import '../../models/evaluaciones/nota_evaluacion.dart';
import '../../services/api_service.dart';

class EvaluacionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Evaluacion> _evaluaciones = [];
  List<NotaEvaluacion> _notas = [];

  Evaluacion? _selectedEvaluacion;
  NotaEvaluacion? _selectedNota;

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Evaluacion> get evaluaciones => _evaluaciones;
  List<NotaEvaluacion> get notas => _notas;
  Evaluacion? get selectedEvaluacion => _selectedEvaluacion;
  NotaEvaluacion? get selectedNota => _selectedNota;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void setSelectedEvaluacion(Evaluacion evaluacion) {
    _selectedEvaluacion = evaluacion;
    notifyListeners();
  }

  void setSelectedNota(NotaEvaluacion nota) {
    _selectedNota = nota;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Método principal para cargar todos los datos del alumno
  Future<void> fetchAlumnoData(int alumnoId) async {
    _isLoading = true;
    _error = null;
    try {
      await fetchNotasRecientesByAlumno(alumnoId);
      if (_notas.isNotEmpty) {
        final evaluacionIds =
            _notas
                .map((n) => n.evaluacion_id)
                .where((id) => id != null && id > 0)
                .toSet();
        await fetchEvaluacionesByIds(evaluacionIds.toList());
        print("Evaluaciones cargadas: ${_evaluaciones.length}");
      }
    } catch (e) {
      _error = "Error al cargar datos del alumno: $e";
      print(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchNotasRecientesByAlumno(
    int alumnoId, {
    int limit = 5,
  }) async {
    _isLoading = true;

    try {
      _notas.clear();

      // Solo obtenemos la primera página ordenada (el backend ya lo ordena)
      final data = await _apiService.get(
        '/notas-evaluacion/?alumno_id=$alumnoId&page=1',
      );
      final List<dynamic> results = data['results'];

      final notasPagina =
          results.map((e) => NotaEvaluacion.fromJson(e)).toList();

      // Solo las más recientes (las primeras `limit` del backend)
      _notas.addAll(notasPagina.take(limit));

      print("✅ Últimas $limit notas del alumno $alumnoId cargadas.");
    } catch (e) {
      print('❌ Error al cargar notas recientes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  int fetchEvaluacionesTotales() {
    return _evaluaciones.length;
  }

  Future<void> fetchNotasByAlumno(int alumnoId) async {
    try {
      _notas.clear();
      int page = 1;
      bool hayMas = true;

      while (hayMas) {
        final data = await _apiService.get(
          '/notas-evaluacion/?alumno_id=$alumnoId&page=$page',
        );
        final List<dynamic> results = data['results'];

        final notasPagina =
            results.map((e) => NotaEvaluacion.fromJson(e)).toList();
        _notas.addAll(notasPagina);

        hayMas = data['next'] != null;
        page++;
      }

      print("✅ Notas del alumno $alumnoId cargadas: ${_notas.length}");
    } catch (e) {
      throw Exception("❌ Error al cargar notas: $e");
    }
  }

  Future<void> fetchEvaluacionesByIds(List<int> evaluacionIds) async {
    try {
      _evaluaciones.clear();
      for (int id in evaluacionIds) {
        if (id <= 0) {
          print("ID de evaluación inválido: $id");
          continue;
        } // omitir IDs inválidos
        print("Solicitando evaluación con ID: $id");

        final data = await _apiService.get('/evaluaciones/$id/');
        print("Evaluación recibida: $data");

        _evaluaciones.add(Evaluacion.fromJson(data));
      }
    } catch (e) {
      throw Exception("Error al cargar evaluaciones: $e");
    }
  }

  // Método adicional para cargar evaluaciones por alumno directamente
  Future<void> fetchEvaluacionesByAlumno(int alumnoId) async {
    try {
      _evaluaciones.clear();
      int page = 1;
      bool hayMas = true;

      while (hayMas) {
        final data = await _apiService.get(
          '/evaluaciones/?alumno_id=$alumnoId&page=$page',
        );
        final List<dynamic> results = data['results'];

        final evaluacionesPagina =
            results.map((e) => Evaluacion.fromJson(e)).toList();
        _evaluaciones.addAll(evaluacionesPagina);

        hayMas = data['next'] != null;
        page++;
      }

      print(
        "✅ Evaluaciones del alumno $alumnoId cargadas: ${_evaluaciones.length}",
      );
    } catch (e) {
      throw Exception("❌ Error al cargar evaluaciones del alumno: $e");
    }
  }

  // Obtener evaluaciones con sus notas correspondientes
  List<Map<String, dynamic>> getEvaluacionesConNotas() {
    return _evaluaciones.map((evaluacion) {
      final nota = getNotaForEvaluacion(evaluacion.id);
      return {'evaluacion': evaluacion, 'nota': nota};
    }).toList();
  }

  NotaEvaluacion? getNotaForEvaluacion(int evaluacionId) {
    try {
      return _notas.firstWhere((n) => n.evaluacion_id == evaluacionId);
    } catch (e) {
      return null;
    }
  }

  // Obtener tareas pendientes (evaluaciones sin nota o con nota null)
  List<Evaluacion> getTareasPendientes() {
    return _evaluaciones.where((evaluacion) {
      final nota = getNotaForEvaluacion(evaluacion.id);
      return nota == null || nota.nota == null;
    }).toList();
  }

  // Obtener últimas calificaciones (evaluaciones con nota)
  List<Map<String, dynamic>> getUltimasCalificaciones({int limit = 5}) {
    final evaluacionesConNota =
        _evaluaciones
            .where((evaluacion) {
              final nota = getNotaForEvaluacion(evaluacion.id);
              return nota != null && nota.nota != null;
            })
            .map((evaluacion) {
              final nota = getNotaForEvaluacion(evaluacion.id)!;
              return {'evaluacion': evaluacion, 'nota': nota};
            })
            .toList();

    // Ordenar por ID de evaluación (asumiendo que mayor ID = más reciente)
    evaluacionesConNota.sort(
      (a, b) => (b['evaluacion'] as Evaluacion).id.compareTo(
        (a['evaluacion'] as Evaluacion).id,
      ),
    );

    return evaluacionesConNota.take(limit).toList();
  }

  // Obtener estadísticas del alumno
  Map<String, dynamic> getEstadisticasAlumno() {
    final totalEvaluaciones = _evaluaciones.length;
    final evaluacionesConNota =
        _evaluaciones.where((evaluacion) {
          final nota = getNotaForEvaluacion(evaluacion.id);
          return nota != null && nota.nota != null;
        }).length;
    final evaluacionesPendientes = getTareasPendientes().length;

    // Calcular promedio si hay notas
    double? promedio;
    if (evaluacionesConNota > 0) {
      final notasConValor = _notas.where((n) => n.nota != null).toList();
      if (notasConValor.isNotEmpty) {
        final suma = notasConValor.fold(0.0, (sum, nota) => sum + nota.nota!);
        promedio = suma / notasConValor.length;
      }
    }

    return {
      'total_evaluaciones': totalEvaluaciones,
      'evaluaciones_con_nota': evaluacionesConNota,
      'evaluaciones_pendientes': evaluacionesPendientes,
      'promedio': promedio,
    };
  }
}
