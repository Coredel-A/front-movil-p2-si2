import 'package:aula_virtual/models/colegio/materia.dart';
import 'package:flutter/material.dart';
import '../../models/evaluaciones/libreta_trimestral.dart';
import '../../services/api_service.dart';

class LibretaTrimestralProvider with ChangeNotifier {
  List<LibretaTrimestral> _libreta = [];
  LibretaTrimestral? _currentLibretaTrimestral;
  bool _isLoading = false;

  List<LibretaTrimestral> get libreta => _libreta;
  LibretaTrimestral? get currentLibretaTrimestral => _currentLibretaTrimestral;
  bool get isLoading => _isLoading;

  /*
  Future<void> getLibretasTrimestrales()
  Obtener todas las libretas (útil para administración general).

  Future<void> getLibretaByAlumno(int alumnoId)
  Obtener todas las libretas trimestrales de un alumno.

  Future<void> getLibretaByAlumnoYPeriodo(int alumnoId, int periodoId)
  Obtener la libreta específica de un alumno para un periodo determinado.

  Future<void> getLibretaByCursoYPeriodo(int cursoId, int periodoId)
  Obtener las libretas de todos los alumnos de un curso en un periodo.

  Future<void> calcularPromediosPorAlumno(int alumnoId, int periodoId)
  Método opcional si manejas el cálculo de promedios de forma manual y no del lado del backend.
  */

  Future<void> getLibretaByAlumno(int alumnoId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await ApiService().get('/$alumnoId');
      _currentLibretaTrimestral = LibretaTrimestral.fromJson(data);
    } catch (e) {
      print('Error al obtener la libreta del alumno $alumnoId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getLibretaByAlumnoYPeriodo(int alumnoId, int periodoId) async {
    _isLoading = true;
    notifyListeners();
    try {
      final data = await ApiService().get('/$alumnoId');
      _currentLibretaTrimestral = LibretaTrimestral.fromJson(data);
    } catch (e) {
      print('Error al obtener la libreta del alumno $alumnoId en el periodo $periodoId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /*String getNombreMateria(LibretaTrimestral libreta, List<Materia> materias) {
    return materias.firstWhere((m) => m.id == libreta.materia_id,
      orElse: () => Materia(
        id: 0, 
        nombre: 'Desconocido',
        descripcion: 'Desconocido',
        curso_id: null,
        docente_id:  null,
        )).nombre;
  }*/
}


