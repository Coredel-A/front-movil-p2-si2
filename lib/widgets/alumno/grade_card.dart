import 'package:aula_virtual/models/evaluaciones/libreta_trimestral.dart';
import 'package:flutter/material.dart';
import 'package:aula_virtual/providers/colegio/materia_provider.dart';
import 'package:provider/provider.dart';

class GradeCard extends StatelessWidget {
  final LibretaTrimestral libreta;

  const GradeCard({Key? key, required this.libreta}) : super(key: key);

  Color _getGradeColor(double nota) {
    if (nota >= 90) return Colors.green;
    if (nota >= 80) return Colors.blue;
    if (nota >= 70) return Colors.orange;
    if (nota >= 60) return Colors.yellow[700]!;
    return Colors.red;
  }

  String _getGradeLevel(double nota) {
    if (nota >= 90) return 'Excelente';
    if (nota >= 80) return 'Muy Bueno';
    if (nota >= 70) return 'Bueno';
    if (nota >= 60) return 'Regular';
    return 'Insuficiente';
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MateriaProvider>(
      builder: (context, materiaProvider, child) {
        // Obtener el nombre de la materia del provider
        final nombreMateria = materiaProvider.getNombreMateria(libreta.materia_id);
        
        return Card(
          elevation: 4,
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        nombreMateria,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: _getGradeColor(libreta.promedio),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${libreta.promedio.toStringAsFixed(1)}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _getGradeLevel(libreta.promedio),
                      style: TextStyle(
                        color: _getGradeColor(libreta.promedio),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      'T${libreta.trimestre} - ${libreta.gestion}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                if (libreta.observacion.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Observación:',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                            color: Colors.grey[700],
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          libreta.observacion,
                          style: TextStyle(
                            color: Colors.grey[600], 
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}