/*import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//models
import 'package:aula_virtual/models/colegio/materia.dart';
import 'package:aula_virtual/models/evaluaciones/asistencia.dart';
//providers
import 'package:aula_virtual/providers/attendance_provider.dart';
//widgets
import 'package:aula_virtual/widgets/alumno/attendance_calendar.dart';

// Pantalla Principal de Asistencia
class StudentAttendanceScreen extends StatefulWidget {
  @override
  _StudentAttendanceScreenState createState() => _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState extends State<StudentAttendanceScreen> {
  late AttendanceProvider _attendanceProvider;

  @override
  void initState() {
    super.initState();
    _attendanceProvider = AttendanceProvider();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Asistencia'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildMateriaSelector(),
            _buildAttendanceStats(),
            AttendanceCalendar(provider: _attendanceProvider),
            _buildRecentAttendance(),
          ],
        ),
      ),
    );
  }

  Widget _buildMateriaSelector() {
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filtrar por Materia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            DropdownButton<int?>(
              isExpanded: true,
              value: _attendanceProvider.selectedMateriaId,
              hint: Text('Todas las materias'),
              items: [
                DropdownMenuItem<int?>(
                  value: null,
                  child: Text('Todas las materias'),
                ),
                ..._attendanceProvider.materias.map((materia) {
                  return DropdownMenuItem<int?>(
                    value: materia.id,
                    child: Text(materia.nombre),
                  );
                }).toList(),
              ],
              onChanged: (value) {
                setState(() {
                  _attendanceProvider.setSelectedMateria(value);
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttendanceStats() {
    final stats = _attendanceProvider.getStats(_attendanceProvider.selectedMateriaId);
    
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Estadísticas de Asistencia',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _statCard('Total Clases', stats.totalClases.toString(), Colors.blue),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _statCard('Porcentaje', '${stats.porcentajeAsistencia.toStringAsFixed(1)}%', 
                    stats.porcentajeAsistencia >= 80 ? Colors.green : Colors.red),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _statCard('Presentes', stats.presentes.toString(), Colors.green),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _statCard('Ausentes', stats.ausentes.toString(), Colors.red),
                ),
              ],
            ),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _statCard('Tardanzas', stats.tardanzas.toString(), Colors.orange),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: _statCard('Justificados', stats.justificados.toString(), Colors.blue),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _statCard(String title, String value, Color color) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: color,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAttendance() {
    final asistencias = _attendanceProvider.getAttendanceByMateria(_attendanceProvider.selectedMateriaId)
        .take(10)
        .toList();

    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Asistencia Reciente',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: asistencias.length,
              itemBuilder: (context, index) {
                final asistencia = asistencias[index];
                final materia = _attendanceProvider.materias.firstWhere((m) => m.id == asistencia.materia_id);
                
                return ListTile(
                  leading: Icon(
                    _getStatusIcon(asistencia.estado),
                    color: _getStatusColor(asistencia.estado),
                  ),
                  title: Text(materia.nombre),
                  subtitle: Text(
                    '${asistencia.fecha.day}/${asistencia.fecha.month}/${asistencia.fecha.year}',
                  ),
                  trailing: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(asistencia.estado).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      asistencia.estado.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(asistencia.estado),
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getStatusIcon(String estado) {
    switch (estado) {
      case 'presente':
        return Icons.check_circle;
      case 'ausente':
        return Icons.cancel;
      case 'tardanza':
        return Icons.access_time;
      case 'justificado':
        return Icons.info;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String estado) {
    switch (estado) {
      case 'presente':
        return Colors.green;
      case 'ausente':
        return Colors.red;
      case 'tardanza':
        return Colors.orange;
      case 'justificado':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}*/