class Evaluacion {
  final int id;
  final String nombre;
  final String tipo;
  final String dimension;
  final double? porcentaje;
  final int trimestre;
  final int materia_id;
  final int gestion_id;
  final String materia_nombre;
  final int gestion_anio;

  Evaluacion({
    required this.id,
    required this.nombre,
    required this.tipo,
    required this.dimension,
    required this.porcentaje,
    required this.trimestre,
    required this.materia_id,
    required this.gestion_id,
    required this.materia_nombre,
    required this.gestion_anio,
 
  });

  factory Evaluacion.fromJson(Map<String, dynamic> json) {
    return Evaluacion(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      tipo: json['tipo'] ?? '',
      dimension: json['dimension'] ?? '',
      porcentaje: json['porcentaje'] != null
          ? (json['porcentaje'] is String
              ? double.tryParse(json['porcentaje'])
              : (json['porcentaje'] as num).toDouble())
          : null,
      trimestre: json['trimestre'] ?? 1,
      materia_id: json['materia_id'] ?? 0,
      gestion_id: json['gestion_id'] ?? 0,
      materia_nombre: json['materia_nombre'] ?? '',
      gestion_anio: json['gestion_anio'] ?? DateTime.now().year,
    );
  }
}