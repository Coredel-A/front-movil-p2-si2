class NotaEvaluacion {
  final int id;
  final double? nota;
  final int alumno_id;
  final String alumno_nombre;
  final int evaluacion_id;
  final String evaluacion_nombre;
  final String tipo_evaluacion;

  NotaEvaluacion({
    required this.id,
    required this.nota,
    required this.alumno_id,
    required this.alumno_nombre,
    required this.evaluacion_id,
    required this.evaluacion_nombre,
    required this.tipo_evaluacion,
  });

  factory NotaEvaluacion.fromJson(Map<String, dynamic> json) {
    return NotaEvaluacion(
      id: json['id'] ?? 0,
      nota: json['nota'] != null
          ? (json['nota'] is String
              ? double.tryParse(json['nota'])
              : (json['nota'] as num).toDouble())
          : null,
      alumno_id: json['alumno_id'] ?? 0,
      alumno_nombre: json['alumno_nombre'] ?? '',
      evaluacion_id: json['evaluacion_id'] ?? 0,
      evaluacion_nombre: json['evaluacion_nombre'] ?? '',
      tipo_evaluacion: json['tipo_evaluacion'] ?? '',
    );
  }
}
