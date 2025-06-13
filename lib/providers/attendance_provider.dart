import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/evaluaciones/asistencia.dart';
import '../models/colegio/materia.dart';

class AttendanceStats {
  final int totalClases;
  final int presentes;
  final int ausentes;
  final int tardanzas;
  final int justificados;

  AttendanceStats({
    required this.totalClases,
    required this.presentes,
    required this.ausentes,
    required this.tardanzas,
    required this.justificados,
  });

  double get porcentajeAsistencia =>
      totalClases > 0 ? (presentes / totalClases) * 100 : 0;
}

class AttendanceProvider extends ChangeNotifier {
  List<Asistencia> _asistencias = [];
  List<Materia> _materias = [];
  int? _selectedMateriaId;

  List<Asistencia> get asistencias => _asistencias;
  List<Materia> get materias => _materias;
  int? get selectedMateriaId => _selectedMateriaId;

  Future<void> fetchMaterias(int alumnoId) async {
    try {
      final response = await http.get(Uri.parse('/alumno/$alumnoId/materias/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _materias = data.map((item) => Materia.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Error al cargar materias');
      }
    } catch (e) {
      print('Error en fetchMaterias: $e');
    }
  }

  Future<void> fetchAsistencias(int alumnoId) async {
    try {
      final response = await http.get(Uri.parse('/alumno/$alumnoId/asistencias/'));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _asistencias = data.map((item) => Asistencia.fromJson(item)).toList();
        notifyListeners();
      } else {
        throw Exception('Error al cargar asistencias');
      }
    } catch (e) {
      print('Error en fetchAsistencias: $e');
    }
  }

  void setSelectedMateria(int? materiaId) {
    _selectedMateriaId = materiaId;
    notifyListeners();
  }

  List<Asistencia> getAttendanceByMateria(int? materiaId) {
    if (materiaId == null) return _asistencias;
    return _asistencias.where((a) => a.materia == materiaId).toList();
  }

  /*AttendanceStats getStats(int? materiaId) {
    final asistencias = getAttendanceByMateria(materiaId);
    return AttendanceStats(
      totalClases: asistencias.length,
      presentes: asistencias.where((a) => a.estado == 'presente').length,
      ausentes: asistencias.where((a) => a.estado == 'ausente').length,
      tardanzas: asistencias.where((a) => a.estado == 'tardanza').length,
      justificados: asistencias.where((a) => a.estado == 'justificado').length,
    );
  }*/

  Map<DateTime, List<Asistencia>> getAttendanceMap(int? materiaId) {
    final asistencias = getAttendanceByMateria(materiaId);
    Map<DateTime, List<Asistencia>> map = {};
    for (var asistencia in asistencias) {
      final date = DateTime(asistencia.fecha.year, asistencia.fecha.month, asistencia.fecha.day);
      map.putIfAbsent(date, () => []).add(asistencia);
    }
    return map;
  }
}
