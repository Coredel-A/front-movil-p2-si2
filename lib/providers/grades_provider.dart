import 'package:flutter/foundation.dart';
import 'package:aula_virtual/models/colegio/materia.dart';
import 'package:aula_virtual/models/evaluaciones/libreta_trimestral.dart';
import 'package:aula_virtual/models/evaluaciones/nota_evaluacion.dart';

class GradesProvider with ChangeNotifier {
  List<LibretaTrimestral> _trimestrales = [];
  List<NotaEvaluacion> _evaluaciones = [];
  List<Materia> _materias = [];
  bool _isLoading = false;
  int _selectedTrimestre = 1;
  int _selectedGestion = DateTime.now().year;
  String? _errorMessage;
  int? _currentAlumnoId;

  // Getters
  List<LibretaTrimestral> get trimestrales => _trimestrales;
  List<NotaEvaluacion> get evaluaciones => _evaluaciones;
  List<Materia> get materias => _materias;
  bool get isLoading => _isLoading;
  int get selectedTrimestre => _selectedTrimestre;
  int get selectedGestion => _selectedGestion;
  String? get errorMessage => _errorMessage;
  int? get currentAlumnoId => _currentAlumnoId;

  double get promedioGeneral {
    if (_trimestrales.isEmpty) return 0.0;
    double suma = _trimestrales.fold(0.0, (sum, item) => sum + item.promedio);
    return suma / _trimestrales.length;
  }

  // Setters mejorados
  void setTrimestre(int trimestre, int alumnoId) {
    if (_selectedTrimestre != trimestre) {
      _selectedTrimestre = trimestre;
      notifyListeners();
      // Cargar datos con el nuevo trimestre
      _loadCurrentStudentGrades(alumnoId);
    }
  }

  void setGestion(int gestion, int alumnoId) {
    if (_selectedGestion != gestion) {
      _selectedGestion = gestion;
      notifyListeners();
      // Cargar datos con la nueva gestión
      _loadCurrentStudentGrades(alumnoId);
    }
  }

  // Método principal para cargar notas de un alumno específico
  Future<void> loadGrades(int alumnoId) async {
    _currentAlumnoId = alumnoId;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Llamada a la API o base de datos
      await _fetchGradesFromApi(alumnoId);
    } catch (e) {
      _errorMessage = 'Error al cargar las notas: ${e.toString()}';
      print('Error en loadGrades: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Método privado para cargar datos del alumno actual (cuando cambien filtros)
  Future<void> _loadCurrentStudentGrades(int alumnoId) async {
    if (_currentAlumnoId != null) {
      await loadGrades(alumnoId);
    }
  }

  // Método privado para obtener datos de la API
  Future<void> _fetchGradesFromApi(int alumnoId) async {
    try {
      // TODO: Reemplazar con llamadas reales a tu API

      // Ejemplo de cómo podrían ser las llamadas:
      // final trimestralesResponse = await ApiService.getLibretasTrimestrales(
      //   alumnoId: alumnoId,
      //   trimestre: _selectedTrimestre,
      //   gestion: _selectedGestion,
      // );

      // final evaluacionesResponse = await ApiService.getNotasEvaluaciones(
      //   alumnoId: alumnoId,
      //   trimestre: _selectedTrimestre,
      //   gestion: _selectedGestion,
      // );

      // final materiasResponse = await ApiService.getMaterias();

      // Por ahora, simulamos la carga con un delay
      await Future.delayed(Duration(seconds: 1));

      // Aquí asignarías los datos reales de la API:
      // _trimestrales = trimestralesResponse.map((item) => LibretaTrimestral.fromJson(item)).toList();
      // _evaluaciones = evaluacionesResponse.map((item) => NotaEvaluacion.fromJson(item)).toList();
      // _materias = materiasResponse.map((item) => Materia.fromJson(item)).toList();

      // Mientras tanto, listas vacías (sin datos de prueba)
      _trimestrales = [];
      _evaluaciones = [];
      _materias = [];
    } catch (e) {
      throw Exception('Error al obtener datos de la API: $e');
    }
  }

  // Método para limpiar los datos
  void clearData() {
    _trimestrales.clear();
    _evaluaciones.clear();
    _materias.clear();
    _errorMessage = null;
    notifyListeners();
  }

  // Método para agregar una nota (útil para actualizaciones en tiempo real)
  void addOrUpdateLibreta(LibretaTrimestral libreta) {
    final index = _trimestrales.indexWhere((item) => item.id == libreta.id);
    if (index != -1) {
      _trimestrales[index] = libreta;
    } else {
      _trimestrales.add(libreta);
    }
    notifyListeners();
  }

  // Método para agregar una evaluación
  void addOrUpdateEvaluacion(NotaEvaluacion evaluacion) {
    final index = _evaluaciones.indexWhere((item) => item.id == evaluacion.id);
    if (index != -1) {
      _evaluaciones[index] = evaluacion;
    } else {
      _evaluaciones.add(evaluacion);
    }
    notifyListeners();
  }

  // Método para obtener notas de una materia específica
  List<LibretaTrimestral> getGradesByMateria(int materiaId) {
    return _trimestrales
        .where((libreta) => libreta.materia_id == materiaId)
        .toList();
  }

  // Método para obtener evaluaciones de una materia específica
  List<NotaEvaluacion> getEvaluacionesByMateria(int materiaId) {
    // Aquí necesitarías una relación entre evaluaciones y materias
    // Esto depende de cómo esté estructurada tu base de datos
    return _evaluaciones;
  }

  // Método para refrescar datos
  Future<void> refreshGrades(int alumnoId) async {
    await loadGrades(alumnoId);
  }
}
