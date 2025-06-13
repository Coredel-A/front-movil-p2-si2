
class Curso {
  final int id;
  final String nombre;
  final String descripcion;
  final String nivel;
  final String turno;

  Curso ({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.nivel,
    required this.turno,
  });

  factory Curso.fromJson(Map<String, dynamic> json) {
    return Curso(
      id: json['id'] ?? 0,
      nombre: json['nombre'] ?? '',
      descripcion: json['descripcion'] ?? '',
      nivel: json['nivel'] ?? '',
      turno: json['turno'] ?? '',
    );
  }
}

