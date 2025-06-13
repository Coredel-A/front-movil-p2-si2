class LibretaTrimestral {
  final int id;
  final int? alumno_id;
  final int materia_id;
  final int trimestre;
  final int gestion;
  final double promedio;
  final String observacion;

  LibretaTrimestral({
    required this.id,
    required this.alumno_id,
    required this.materia_id,
    required this.trimestre,
    required this.gestion,
    required this.promedio,
    required this.observacion,
  });

  factory LibretaTrimestral.fromJson(Map<String, dynamic> json) {
    return LibretaTrimestral(
      id: json['id'],
      alumno_id: json['alumno_id'],
      materia_id: json['materia_id'],
      trimestre: json['trimestre'],
      gestion: json['gestion'],
      promedio: (json['promedio'] ?? 0.0).toDouble(),
      observacion: json['observacion'] ?? '',
    );
  }
}