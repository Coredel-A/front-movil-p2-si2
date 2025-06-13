class Gestion {
  final int id;
  final int anio;
  final String descripcion;
  final bool activa;

  Gestion ({
    required this.id,
    required this.anio,
    required this.descripcion,
    required this.activa,
  });

  factory Gestion.fromJson(Map<String, dynamic> json) {
    return Gestion(
      id: json['id'],
      anio: json['anio'],
      descripcion: json['descripcion'],
      activa: bool.parse(json['activa']),
    );
  }
}