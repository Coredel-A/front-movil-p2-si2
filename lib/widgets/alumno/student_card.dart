import 'package:flutter/material.dart';
import '../../models/usuarios/alumno.dart';
import '../../models/colegio/curso.dart';

class StudentCard extends StatelessWidget {
  final Alumno alumno;
  final Curso? curso;

  const StudentCard({Key? key, required this.alumno, required this.curso})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Foto de perfil
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue.shade100,
              child: Text(
                '${alumno.first_name.isNotEmpty ? alumno.first_name[0] : ''}'
                '${alumno.last_name.isNotEmpty ? alumno.last_name[0] : ''}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue.shade700,
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Nombre completo
            Text(
              alumno.nombre_completo,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Código del estudiante
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Text(
                'Código: ${alumno.codigo}',
                style: TextStyle(
                  color: Colors.blue.shade700,
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
            ),
            if (curso != null)
              Text(
                '${curso!.nombre} - ${curso!.nivel} - ${curso!.turno}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                textAlign: TextAlign.center,
              ),

            const SizedBox(height: 16),

            // Estado y riesgo académico
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color:
                        alumno.estado == 'Activo'
                            ? Colors.green.shade50
                            : Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          alumno.estado == 'Activo'
                              ? Colors.green.shade200
                              : Colors.orange.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        alumno.estado == 'Activo'
                            ? Icons.check_circle_outline
                            : Icons.warning_outlined,
                        size: 16,
                        color:
                            alumno.estado == 'Activo'
                                ? Colors.green.shade700
                                : Colors.orange.shade700,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        alumno.estado,
                        style: TextStyle(
                          color:
                              alumno.estado == 'Activo'
                                  ? Colors.green.shade700
                                  : Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
