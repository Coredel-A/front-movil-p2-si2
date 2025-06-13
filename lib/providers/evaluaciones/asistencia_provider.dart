import 'package:flutter/material.dart';
import '../../models/evaluaciones/asistencia.dart';
import '../../services/api_service.dart';

class AsistenciaProvider with ChangeNotifier {
  List<Asistencia> _asistencias = [];
  Asistencia?  _currentAsistencia;
  bool _isLoading = false;

  List<Asistencia> get asistencias => _asistencias;
  Asistencia? get currentAsistencia => _currentAsistencia;
  bool get isLoading => _isLoading;
  
  Future<void> getAsistenciaByAlumno(int alumnoId) async { 
    _isLoading = true;
    try {
      final data = await ApiService().get('/asistencia/alumno/$alumnoId');
      _currentAsistencia = Asistencia.fromJson(data);
    } catch (e) {
      print('Error al cargar La asistencia del alumno $alumnoId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAsistenciaByAlumnoAndMateria(int alumnoId, int materiaId) async {
    _isLoading = true;
    try {
      final data = await ApiService().get('/asistencia/alumno/$alumnoId/materia/$materiaId');
      _currentAsistencia = Asistencia.fromJson(data);
    } catch (e) {
      print('Error al cargar la asistencia del alumno $alumnoId de la materia $materiaId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAsistenciaByFecha(int alumnoId, DateTime fecha) async {
    _isLoading = true;
    try {
      final data = await ApiService().get('/asistencia/alumno/$alumnoId/fecha/$fecha');
      _currentAsistencia = Asistencia.fromJson(data);
    } catch (e) {
      print('Error al cargar la asistencian en el dia $fecha: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getAsistenciaReciente(int alumnoId) async {
    
  }
}