import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Providers
import 'package:aula_virtual/providers/usuarios/alumno_provider.dart';
import 'package:aula_virtual/providers/colegio/curso_provider.dart';
import 'package:aula_virtual/providers/evaluaciones/evaluacion_provider.dart';

// Models
import 'package:aula_virtual/models/evaluaciones/nota_evaluacion.dart';

// Widgets
import 'package:aula_virtual/widgets/alumno/simple_evaluacion_card.dart';
import 'package:aula_virtual/widgets/alumno/simple_nota_card.dart';

// Screens - Asegúrate de importar tus otras pantallas
import 'package:aula_virtual/screens/alumno/student_task_screen.dart';
import 'package:aula_virtual/screens/alumno/student_profile_screen.dart';

class StudentHomeScreen extends StatefulWidget {
  final int alumnoId; // ID del alumno logueado
  
  const StudentHomeScreen({
    Key? key, 
    required this.alumnoId,
  }) : super(key: key);

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  bool _isLoading = true;
  int _selectedIndex = 0; // Índice de la pestaña seleccionada
  
  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final alumnoProvider = Provider.of<AlumnoProvider>(context, listen: false);
      final cursoProvider = Provider.of<CursoProvider>(context, listen: false);
      final evaluacionProvider = Provider.of<EvaluacionProvider>(context, listen: false);

      // Cargar datos del alumno
      await alumnoProvider.getAlumnoById(widget.alumnoId);
      
      // Obtener el alumno cargado
      final alumno = alumnoProvider.currentAlumno;
      
      if (alumno != null) {
        // Cargar curso del alumno
        await cursoProvider.fetchCursoById(alumno.curso_id);
        
        // Cargar todos los datos del alumno (evaluaciones y notas)
        await evaluacionProvider.fetchAlumnoData(widget.alumnoId);
      }
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      // Mostrar error al usuario
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar datos: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  // Función para manejar la navegación
  void _onItemTapped(int index) {
    if (index == _selectedIndex) return; // No hacer nada si ya está en la pestaña actual
    
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Ya estamos en Home, no hacer nada
        break;
      case 1:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentTasksScreen(alumnoId: widget.alumnoId),
          ),
        );

        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentProfileScreen(alumnoId: widget.alumnoId),
          ),
        );
    }
  }

  Widget _buildHomeContent() {
    return Consumer3<AlumnoProvider, CursoProvider, EvaluacionProvider>(
      builder: (context, alumnoProvider, cursoProvider, evaluacionProvider, child) {
        final alumno = alumnoProvider.currentAlumno;
        final curso = cursoProvider.currentCurso;
        
        // Si no hay datos, mostrar mensaje de error
        if (alumno == null) {
          return const Center(
            child: Text(
              'No se pudieron cargar los datos del estudiante',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }

        // Obtener datos del provider de evaluaciones
        final tareasPendientes = evaluacionProvider.getTareasPendientes();
        final ultimasCalificaciones = evaluacionProvider.getUltimasCalificaciones(limit: 5);
        final evaluacionesTotales = evaluacionProvider.fetchEvaluacionesTotales();

        return RefreshIndicator(
          onRefresh: _loadData,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bienvenida y datos del estudiante
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade600, Colors.blue.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Hola, ${alumno.first_name}!',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Código: ${alumno.codigo}${curso != null ? ' • ${curso.nombre}' : ''}',
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      if (curso != null) ...[
                        Text(
                          '${curso.nivel} - Turno ${curso.turno}',
                          style: const TextStyle(color: Colors.white70, fontSize: 14),
                        ),
                      ],
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  Text(
                                    'Total Evaluaciones Recientes',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                    '$evaluacionesTotales',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                children: [
                                  const Text(
                                    'Pendientes',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${tareasPendientes.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Evaluaciones pendientes
                const Text(
                  'Evaluaciones Pendientes',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                if (tareasPendientes.isEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          size: 48,
                          color: Colors.green.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'No tienes evaluaciones pendientes',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '¡Buen trabajo!',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  ...tareasPendientes.map((evaluacion) {
                    final notaEvaluacion = evaluacionProvider.getNotaForEvaluacion(evaluacion.id);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: SimpleEvaluacionCard(
                        evaluacion: evaluacion,
                        notaEvaluacion: notaEvaluacion ?? NotaEvaluacion(
                          id: 0,
                          nota: null, 
                          alumno_id: widget.alumnoId,
                          alumno_nombre: '',
                          evaluacion_id: evaluacion.id,
                          evaluacion_nombre: evaluacion.nombre,
                          tipo_evaluacion: evaluacion.tipo,
                        ),
                      ),
                    );
                  }),
                ],

                const SizedBox(height: 24),

                // Últimas calificaciones
                const Text(
                  'Últimas Calificaciones',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 16),
                if (ultimasCalificaciones.isEmpty) ...[
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 48,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Aún no tienes calificaciones',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Las calificaciones aparecerán aquí una vez que los docentes las publiquen',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ] else ...[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: ultimasCalificaciones.length,
                      separatorBuilder: (context, index) => 
                          Divider(color: Colors.grey.shade200, height: 1),
                      itemBuilder: (context, index) {
                        final item = ultimasCalificaciones[index];
                        final notaEvaluacion = item['nota'] as NotaEvaluacion;
                        
                        return SimpleNotaCard(
                          notaEvaluacion: notaEvaluacion,
                        );
                      },
                    ),
                  ),
                ],

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Aula Virtual'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Aula Virtual'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _buildHomeContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue.shade600,
        unselectedItemColor: Colors.grey.shade600,
        selectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
        ),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_outlined),
            activeIcon: Icon(Icons.assignment),
            label: 'Tareas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}