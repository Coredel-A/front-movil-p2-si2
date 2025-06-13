import 'package:flutter/material.dart';
import '../../models/usuarios/alumno.dart';
import '../../services/api_service.dart';

class AlumnoProvider with ChangeNotifier {
  List<Alumno> _alumnos = [];
  Alumno? _currentAlumno;
  bool _isLoading = false;

  List<Alumno> get alumnos => _alumnos;
  Alumno? get currentAlumno => _currentAlumno;
  bool get isLoading => _isLoading;

  Future<void> getAlumnoById(int id) async {
    _isLoading = true;
    try {
      final data = await ApiService().get(
        '/alumnos/$id',
      ); // <- corregir URL si era incorrecta
      _currentAlumno = Alumno.fromJson(
        data,
      ); // <-- ahora sí, ya que data es Map<String, dynamic>
      print('Alumno obtenido: ${_currentAlumno!.nombre_completo}');
    } catch (e) {
      print('Error al cargar Alumno por ID: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAlumnos() async {
    _isLoading = true;
    _alumnos = []; 
    int page = 1;
    bool hayMas = true;

    try {
      while (hayMas) {
        final data = await ApiService().get('/alumnos/?page=$page');
        final List<dynamic> results = data['results'];

        final alumnosPagina = results.map((e) => Alumno.fromJson(e)).toList();
        _alumnos.addAll(alumnosPagina); 

        hayMas = data['next'] != null;
        page++;
      }

      print("Alumnos cargados: ${_alumnos.length}");
    } catch (e) {
      print('Error al cargar Alumnos: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //acceso centralizado para obtener al "alumno actual" en tu aplicación
  Future<void> getCurrentAlumno() async {
    try {
      //final profile = await ApiService().get('/auth/profile/');
      //final alumnoId = profile['alumno_id'];
      await getAlumnoById(
        1,
      ); //por ahora con codigo hatas que tengan la autenticacion
    } catch (e) {
      print('Error al obtener el alumno actual: $e');
    }
  }
}
