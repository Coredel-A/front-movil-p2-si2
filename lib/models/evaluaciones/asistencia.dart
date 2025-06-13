class Asistencia {
  final int id;
  final int? alumno;
  final int? materia;
  final int? gestion;
  final DateTime fecha;
  final bool presente;
  final String alumno_nombre;
  final String materia_nombre;
  final int gestion_anio;

  Asistencia({
    required this.id,
    required this.alumno,
    required this.materia,
    required this.gestion,
    required this.fecha,
    required this.presente,
    required this.alumno_nombre,
    required this.materia_nombre,
    required this.gestion_anio,
  });

  factory Asistencia.fromJson(Map<String, dynamic> json) {
    return Asistencia(
      id: json['id'],
      alumno: json['alumno'],
      materia: json['materia'],
      gestion: json['gestion'],
      fecha: DateTime.parse(json['fecha']),
      presente: bool.parse(json['presente']),
      alumno_nombre: json['alumno_nombre'],
      materia_nombre: json['materia_nombre'],
      gestion_anio: json['gestion_anio'],
    );
  }

  /*Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alumno_id': alumno_id?.toJson(),
      'materia_id': materia_id?.toJson(),
      'fecha': fecha.toIso8601String(),
      'estado': estado,
      'docente_id': docente_id?.toJson(),
    };
  }*/
}