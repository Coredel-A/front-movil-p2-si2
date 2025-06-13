import 'package:aula_virtual/models/evaluaciones/nota_evaluacion.dart';
import 'package:flutter/material.dart';

class SimpleNotaCard extends StatelessWidget {
  final NotaEvaluacion notaEvaluacion;

  const SimpleNotaCard({
    Key? key,
    required this.notaEvaluacion,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: (notaEvaluacion.nota ?? 0) >= 80
              ? Colors.green.shade100
              : (notaEvaluacion.nota ?? 0) >= 60
                  ? Colors.orange.shade100
                  : Colors.red.shade100,
          child: Text(
            '${(notaEvaluacion.nota ?? 0).toInt()}',
            style: TextStyle(
              color: (notaEvaluacion.nota ?? 0) >= 80
                  ? Colors.green.shade700
                  : (notaEvaluacion.nota ?? 0) >= 60
                      ? Colors.orange.shade700
                      : Colors.red.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          notaEvaluacion.evaluacion_nombre,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              'Alumno: ${notaEvaluacion.alumno_nombre}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            notaEvaluacion.tipo_evaluacion,
            style: TextStyle(
              color: Colors.blue.shade700,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}