import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Importar los archivos separados que ya creaste
import 'package:aula_virtual/widgets/alumno/grade_card.dart';
import 'package:aula_virtual/widgets/alumno/performance_chart.dart';
import 'package:aula_virtual/providers/grades_provider.dart';
import 'package:aula_virtual/providers/colegio/materia_provider.dart';

// Pantalla principal de notas del estudiante
class StudentGradesScreen extends StatefulWidget {
  final int alumnoId;
  const StudentGradesScreen({Key? key, required this.alumnoId}) : super(key: key);
  
  @override
  _StudentGradesScreenState createState() => _StudentGradesScreenState();
}

class _StudentGradesScreenState extends State<StudentGradesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gradesProvider = Provider.of<GradesProvider>(context, listen: false);
      final materiaProvider = Provider.of<MateriaProvider>(context, listen: false);
      
      gradesProvider.loadGrades(widget.alumnoId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mis Notas'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Consumer<GradesProvider>(
        builder: (context, gradesProvider, child) {
          if (gradesProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (gradesProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    gradesProvider.errorMessage!,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => gradesProvider.refreshGrades(widget.alumnoId),
                    child: Text('Reintentar'),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () => gradesProvider.refreshGrades(widget.alumnoId),
            child: SingleChildScrollView(
              physics: AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtros
                  _buildFilters(gradesProvider),

                  // Promedio General
                  _buildGeneralAverage(gradesProvider),

                  // Gráfico de Rendimiento
                  if (gradesProvider.trimestrales.isNotEmpty) ...[
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Gráfico de Rendimiento',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(16),
                      child: Consumer<MateriaProvider>(
                        builder: (context, materiaProvider, child) {
                          return PerformanceChart(grades: gradesProvider.trimestrales);
                        },
                      ),
                    ),
                  ],

                  // Lista de Notas por Materia
                  _buildGradesList(gradesProvider),

                  SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFilters(GradesProvider gradesProvider) {
    return Container(
      color: Colors.blue[50],
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: DropdownButtonFormField<int>(
              value: gradesProvider.selectedTrimestre,
              decoration: InputDecoration(
                labelText: 'Trimestre',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: [1, 2, 3].map((trimestre) {
                return DropdownMenuItem(
                  value: trimestre,
                  child: Text('Trimestre $trimestre'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  gradesProvider.setTrimestre(value, widget.alumnoId);
                }
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: DropdownButtonFormField<int>(
              value: gradesProvider.selectedGestion,
              decoration: InputDecoration(
                labelText: 'Gestión',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              items: [2023, 2024, 2025].map((gestion) {
                return DropdownMenuItem(
                  value: gestion,
                  child: Text('$gestion'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  gradesProvider.setGestion(value, widget.alumnoId);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGeneralAverage(GradesProvider gradesProvider) {
    return Container(
      margin: EdgeInsets.all(16),
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Promedio General',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'Trimestre ${gradesProvider.selectedTrimestre}',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          Text(
            gradesProvider.promedioGeneral > 0
                ? '${gradesProvider.promedioGeneral.toStringAsFixed(1)}'
                : '--',
            style: TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradesList(GradesProvider gradesProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Notas por Materia',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 8),
        
        // Cards de notas o mensaje cuando no hay datos
        if (gradesProvider.trimestrales.isEmpty)
          Container(
            height: 200,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.school_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No hay notas disponibles',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Trimestre ${gradesProvider.selectedTrimestre} - ${gradesProvider.selectedGestion}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...gradesProvider.trimestrales.map((libreta) => 
            GradeCard(libreta: libreta)
          ),
      ],
    );
  }
}

// Clase principal de la app - ejemplo de uso
class StudentGradesApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => GradesProvider()),
        ChangeNotifierProvider(create: (context) => MateriaProvider()),
      ],
      child: MaterialApp(
        title: 'Aula Virtual - Notas',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: StudentGradesScreen(alumnoId: 1), // ID de ejemplo
      ),
    );
  }
}