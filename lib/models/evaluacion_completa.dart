import 'package:aula_virtual/models/evaluaciones/evaluacion.dart';
import 'package:aula_virtual/models/evaluaciones/nota_evaluacion.dart';

class EvaluacionCompleta {
  final Evaluacion evaluacion;
  final NotaEvaluacion? nota_evaluacion;

  EvaluacionCompleta({
    required this.evaluacion,
    this.nota_evaluacion,
  });

  //bool get entregado => nota_evaluacion?.entregado ?? false;
  double? get nota => nota_evaluacion?.nota;
  //bool get isVencida => evaluacion.fecha.isBefore(DateTime.now()) && !entregado;
}