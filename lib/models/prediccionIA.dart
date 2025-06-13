import 'usuarios/alumno.dart';
import 'colegio/materia.dart';

class Prediccionia {
  final int id;
  final Alumno? alumno_id;
  final Materia? materia_id;
  final DateTime fecha_prediccion;
  final double valor_predicho;
  final String categoria; // 'alta', 'media', 'baja'

  Prediccionia({
    required this.id,
    this.alumno_id,
    this.materia_id,
    required this.fecha_prediccion,
    required this.valor_predicho,
    required this.categoria,
  });

  factory Prediccionia.fromJson(Map<String, dynamic> json) {
    return Prediccionia(
      id: json['id'],
      alumno_id: json['alumno_id'] != null ? Alumno.fromJson(json['alumno_id']) : null,
      materia_id: json['materia_id'] != null ? Materia.fromJson(json['materia_id']) : null,
      fecha_prediccion: DateTime.parse(json['fecha_prediccion']),
      valor_predicho: json['valor_predicho'].toDouble(),
      categoria: json['categoria'],
    );
  }
}