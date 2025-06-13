import 'package:flutter/material.dart';
import '../../models/evaluaciones/nota_evaluacion.dart';
import '../../services/api_service.dart';

class NotaEvaluacionProvider with ChangeNotifier {
  List<NotaEvaluacion> _notas = [];
  NotaEvaluacion? _currentNotaEvaluacion;
  bool _isLoading = false;

  List<NotaEvaluacion> get notas => _notas;
  NotaEvaluacion? get currentNotaEvaluacion => _currentNotaEvaluacion;
  bool get isLoading => _isLoading;

  Future<void> fetchNotasByAlumno(int alumnoId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final data = await ApiService().getList(
        '/notas-evaluacion/?alumno_id=$alumnoId',
      );
      _notas = data.map((e) => NotaEvaluacion.fromJson(e)).toList();
    } catch (e) {
      print('Error al cargar las Notas del alumno $alumnoId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getNotasByEvaluacion(int evaluacionId) async {
    _isLoading = true;
    try {
      final data = await ApiService().get('/notaevaluacion/$evaluacionId');
      _currentNotaEvaluacion = NotaEvaluacion.fromJson(data);
    } catch (e) {
      print(
        'Error al cargar la lista de notas de la evaluacion $evaluacionId: $e',
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
