import 'package:aula_virtual/models/usuarios/docente.dart';
import 'package:flutter/material.dart';
import '../../models/colegio/materia.dart';
import '../../services/api_service.dart';

class DocenteProvider with ChangeNotifier {
  List<Docente> _docente = [];
  Docente? _currentDocente;
  bool _isLoading = false;

  List<Docente> get docente => _docente;
  Docente? get currentdocente => _currentDocente;
  bool get isLoading => _isLoading;

  // Métodos que faltan en DocenteProvider

  Future<void> fetchDocentes() async {
    _isLoading = true;
    try {
      final data = await ApiService().getList('/profesores/');
      _docente = data.map((e) => Docente.fromJson(e)).toList();
    } catch (e) {
      print('Error al cargar Docentes: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchDocenteById(int docenteId) async {
    _isLoading = true;
    try {
      final data = await ApiService().get('/profesores/$docenteId/');
      _currentDocente = Docente.fromJson(data);
    } catch (e) {
      print('Error al cargar el Docente $docenteId: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> getCurrentDocente() async {
    _isLoading = true;
    try {
      // Asumiendo que existe un endpoint para el docente actual
      final data = await ApiService().get('/profesores/');
      _currentDocente = Docente.fromJson(data);
    } catch (e) {
      print('Error al cargar el Docente actual: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
