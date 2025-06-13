import 'package:flutter/material.dart';
import 'package:aula_virtual/models/alerta_simple.dart';
class SimpleAlertCard extends StatelessWidget {
  final AlertaSimple alerta;

  const SimpleAlertCard({Key? key, required this.alerta}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color borderColor;

    switch (alerta.tipo) {
      case 'warning':
        backgroundColor = Colors.orange.shade50;
        borderColor = Colors.orange;
        break;
      case 'danger':
        backgroundColor = Colors.red.shade50;
        borderColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.blue.shade50;
        borderColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border(left: BorderSide(width: 4, color: borderColor)),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(alerta.icono, color: borderColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    alerta.titulo,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: borderColor,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alerta.mensaje,
                    style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${alerta.fecha.day}/${alerta.fecha.month}/${alerta.fecha.year}',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}