class Materia {
  final int id;
  final String nombre;
  final String descripcion;
  final int? curso_id;
  final int? docente_id;
  final int? gestion_id;
  final String curso_nombre;
  final String docente_nombre;
  final int gestion_anio;

  Materia ({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.curso_id,
    required this.docente_id,
    required this.gestion_id,
    required this.curso_nombre,
    required this.docente_nombre,
    required this.gestion_anio,
  });

  factory Materia.fromJson(Map<String, dynamic> json) {
    return Materia(
      id: json['id'],
      nombre: json['nombre'],
      descripcion: json['descripcion'],
      curso_id: json['curso_id'],
      docente_id: json['docente_id'],
      gestion_id: json['gestion_id'],
      curso_nombre: json['curso_nombre'],
      docente_nombre: json['docente_nombre'],
      gestion_anio: json['gestion_anio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombre': nombre,
      'descripcion': descripcion,
      'curso_id': curso_id,
      'docente_id': docente_id,
    };
  }
}