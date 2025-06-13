import 'package:flutter/widgets.dart';

class AlertaSimple {
  final String titulo;
  final String mensaje;
  final String tipo;
  final DateTime fecha;
  final IconData icono;

  AlertaSimple({
    required this.titulo,
    required this.mensaje,
    required this.tipo,
    required this.fecha,
    required this.icono,
  });
}