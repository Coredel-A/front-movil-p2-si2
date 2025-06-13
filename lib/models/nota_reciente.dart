class NotaReciente {
  final String materia;
  final String evaluacion;
  final double nota;
  final DateTime fehca;
  final String tipo;
  final String? observaciones;

  NotaReciente({
    required this.materia,
    required this.evaluacion,
    required this.nota,
    required this.fehca,
    required this.tipo,
    this.observaciones,
  });
}