import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:aula_virtual/models/evaluaciones/libreta_trimestral.dart';
import 'package:aula_virtual/providers/colegio/materia_provider.dart';

class PerformanceChart extends StatelessWidget {
  final List<LibretaTrimestral> grades;

  const PerformanceChart({Key? key, required this.grades}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (grades.isEmpty) {
      return Container(
        height: 200,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bar_chart_outlined,
                size: 48,
                color: Colors.grey[400],
              ),
              SizedBox(height: 12),
              Text(
                'No hay datos para mostrar',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Consumer<MateriaProvider>(
      builder: (context, materiaProvider, child) {
        // Pre-cargar los nombres de las materias si no están cargados
        final materiaIds = grades.map((g) => g.materia_id).toSet().toList();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          materiaProvider.preloadNombreMaterias(materiaIds);
        });

        return Container(
          height: 320, // Aumenté la altura para acomodar la leyenda
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // Título del gráfico
              Padding(
                padding: EdgeInsets.only(bottom: 16),
                child: Text(
                  'Rendimiento por Materia',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[700],
                  ),
                ),
              ),
              // Gráfico
              Expanded(
                flex: 3,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    maxY: 100,
                    minY: 0,
                    barTouchData: BarTouchData(
                      enabled: true,
                      touchTooltipData: BarTouchTooltipData(
                        tooltipBgColor: Colors.grey[800],
                        tooltipPadding: EdgeInsets.all(8),
                        tooltipMargin: 8,
                        getTooltipItem: (group, groupIndex, rod, rodIndex) {
                          if (groupIndex < grades.length) {
                            final grade = grades[groupIndex];
                            final materiaNombre = materiaProvider.getNombreMateria(grade.materia_id);
                            return BarTooltipItem(
                              '$materiaNombre\n',
                              TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              children: [
                                TextSpan(
                                  text: '${grade.promedio.toStringAsFixed(1)} pts',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ],
                            );
                          }
                          return null;
                        },
                      ),
                    ),
                    titlesData: FlTitlesData(
                      show: true,
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            if (value.toInt() < grades.length) {
                              final grade = grades[value.toInt()];
                              final materia = materiaProvider.getNombreMateria(grade.materia_id);
                              return Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  _truncateText(materia, 8),
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              );
                            }
                            return SizedBox.shrink();
                          },
                          reservedSize: 32,
                        ),
                      ),
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          interval: 20,
                          reservedSize: 40,
                          getTitlesWidget: (value, meta) {
                            return Text(
                              '${value.toInt()}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[600],
                                fontWeight: FontWeight.w500,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    borderData: FlBorderData(
                      show: true,
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                        left: BorderSide(
                          color: Colors.grey[300]!,
                          width: 1,
                        ),
                      ),
                    ),
                    gridData: FlGridData(
                      show: true,
                      drawVerticalLine: false,
                      horizontalInterval: 20,
                      getDrawingHorizontalLine: (value) {
                        return FlLine(
                          color: Colors.grey[200]!,
                          strokeWidth: 1,
                        );
                      },
                    ),
                    barGroups: grades.asMap().entries.map((entry) {
                      final index = entry.key;
                      final grade = entry.value;
                      
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: grade.promedio,
                            color: _getBarColor(grade.promedio),
                            width: 20,
                            borderRadius: BorderRadius.circular(4),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: 100,
                              color: Colors.grey[100],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
              // Leyenda
              SizedBox(height: 16),
              Expanded(
                flex: 1,
                child: _buildLegend(),
              ),
            ],
          ),
        );
      },
    );
  }

  // Método para obtener el color de la barra según la nota
  Color _getBarColor(double nota) {
    if (nota >= 90) return Colors.green[600]!;
    if (nota >= 80) return Colors.blue[600]!;
    if (nota >= 70) return Colors.orange[600]!;
    if (nota >= 60) return Colors.yellow[700]!;
    return Colors.red[600]!;
  }

  // Método para obtener el texto del nivel según la nota
  String _getGradeLevel(double nota) {
    if (nota >= 90) return 'Excelente';
    if (nota >= 80) return 'Muy Bueno';
    if (nota >= 70) return 'Bueno';
    if (nota >= 60) return 'Regular';
    return 'Insuficiente';
  }

  // Método para truncar texto
  String _truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // Widget para la leyenda
  Widget _buildLegend() {
    final legendItems = [
      {'color': Colors.green[600]!, 'label': 'Excelente (90-100)'},
      {'color': Colors.blue[600]!, 'label': 'Muy Bueno (80-89)'},
      {'color': Colors.orange[600]!, 'label': 'Bueno (70-79)'},
      {'color': Colors.yellow[700]!, 'label': 'Regular (60-69)'},
      {'color': Colors.red[600]!, 'label': 'Insuficiente (<60)'},
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Text(
            'Escala de Calificación',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: SingleChildScrollView(
              child: Wrap(
                spacing: 8,
                runSpacing: 4,
                alignment: WrapAlignment.center,
                children: legendItems.map((item) {
                  return Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: item['color'] as Color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        item['label'] as String,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}