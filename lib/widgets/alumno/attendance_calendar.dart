/*import 'package:aula_virtual/models/evaluaciones/asistencia.dart';
import 'package:aula_virtual/providers/attendance_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class AttendanceCalendar extends StatefulWidget {
  final AttendanceProvider provider;

  const AttendanceCalendar({Key? key, required this.provider}) : super(key: key);

  @override
  _AttendanceCalendarState createState() => _AttendanceCalendarState();
}

class _AttendanceCalendarState extends State<AttendanceCalendar> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    final attendanceMap = widget.provider.getAttendanceMap(widget.provider.selectedMateriaId);
    
    return Card(
      margin: EdgeInsets.all(16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Calendario de Asistencia',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            SizedBox(height: 16),
            TableCalendar<Asistencia>(
              firstDay: DateTime.now().subtract(Duration(days: 365)),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              eventLoader: (day) {
                return attendanceMap[day] ?? [];
              },
              startingDayOfWeek: StartingDayOfWeek.monday,
              calendarStyle: CalendarStyle(
                outsideDaysVisible: false,
                markersMaxCount: 1,
                markerDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: true,
                titleCentered: true,
                formatButtonShowsNext: false,
                formatButtonDecoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12.0),
                ),
                formatButtonTextStyle: TextStyle(
                  color: Colors.white,
                ),
              ),
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                });
              },
              onFormatChanged: (format) {
                setState(() {
                  _calendarFormat = format;
                });
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              calendarBuilders: CalendarBuilders(
                markerBuilder: (context, day, events) {
                  if (events.isNotEmpty) {
                    final asistencia = events.first as Asistencia;
                    Color color;
                    switch (asistencia.estado) {
                      case 'presente':
                        color = Colors.green;
                        break;
                      case 'ausente':
                        color = Colors.red;
                        break;
                      case 'tardanza':
                        color = Colors.orange;
                        break;
                      case 'justificado':
                        color = Colors.blue;
                        break;
                      default:
                        color = Colors.grey;
                    }
                    return Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                      ),
                    );
                  }
                  return null;
                },
              ),
            ),
            if (_selectedDay != null && attendanceMap[_selectedDay] != null)
              Container(
                margin: EdgeInsets.only(top: 16),
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Asistencia del ${_selectedDay!.day}/${_selectedDay!.month}/${_selectedDay!.year}',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    ...attendanceMap[_selectedDay]!.map((asistencia) {
                      final materia = widget.provider.materias.firstWhere((m) => m.id == asistencia.materia_id);
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            Icon(
                              _getStatusIcon(asistencia.estado),
                              color: _getStatusColor(asistencia.estado),
                              size: 16,
                            ),
                            SizedBox(width: 8),
                            Text('${materia.nombre}: ${asistencia.estado.toUpperCase()}'),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            SizedBox(height: 16),
            _buildLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _legendItem('Presente', Colors.green),
        _legendItem('Ausente', Colors.red),
        _legendItem('Tardanza', Colors.orange),
        _legendItem('Justificado', Colors.blue),
      ],
    );
  }

  Widget _legendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 12)),
      ],
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