import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//models
import 'package:aula_virtual/models/evaluaciones/evaluacion.dart';
import 'package:aula_virtual/models/evaluaciones/nota_evaluacion.dart';
import 'package:aula_virtual/models/colegio/materia.dart';
//providers
import 'package:aula_virtual/providers/evaluaciones/evaluacion_provider.dart';
import 'package:aula_virtual/providers/evaluaciones/nota_evaluacion_provider.dart';
import 'package:aula_virtual/providers/colegio/materia_provider.dart';
//services
import 'package:aula_virtual/services/api_service.dart';
//Screens
import 'package:aula_virtual/screens/alumno/student_home_screen.dart';
import 'package:aula_virtual/screens/alumno/student_profile_screen.dart';

class TaskWithDetails {
  final Evaluacion evaluacion;
  final NotaEvaluacion? nota;
  final Materia materia;

  TaskWithDetails({required this.evaluacion, this.nota, required this.materia});

  bool get isPending => nota == null || nota?.nota == null;
  String get status => nota?.nota != null ? 'Entregada' : 'Pendiente';
  Color get statusColor => nota?.nota != null ? Colors.green : Colors.orange;
}

class StudentTasksScreen extends StatefulWidget {
  final int alumnoId;

  const StudentTasksScreen({Key? key, required this.alumnoId})
    : super(key: key);

  @override
  State<StudentTasksScreen> createState() => _StudentTasksScreenState();
}

class _StudentTasksScreenState extends State<StudentTasksScreen> {
  String selectedSubject = 'Todas';
  String selectedStatus = 'Todas';
  TextEditingController searchController = TextEditingController();
  int _selectedIndex = 1; // Índice de la pestaña seleccionada (1 = Tareas)
  bool _isLoading = true;

  List<Materia> get materias =>
      Provider.of<MateriaProvider>(context, listen: false).materias;
  List<Evaluacion> get evaluaciones =>
      Provider.of<EvaluacionProvider>(context, listen: false).evaluaciones;
  List<NotaEvaluacion> get notasEvaluacion =>
      Provider.of<NotaEvaluacionProvider>(context, listen: false).notas;

  late List<TaskWithDetails> tasks;

  @override
  void initState() {
    super.initState();
    _initializeTestData();
  }

  void _initializeTestData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final evaluacionProvider = Provider.of<EvaluacionProvider>(
        context,
        listen: false,
      );
      final notaProvider = Provider.of<NotaEvaluacionProvider>(
        context,
        listen: false,
      );
      final materiaProvider = Provider.of<MateriaProvider>(
        context,
        listen: false,
      );

      await Future.wait([
        materiaProvider.fetchMaterias(),
        evaluacionProvider.fetchAlumnoData(
          widget.alumnoId,
        ), // Usa el método existente
      ]);

      _initializeTasksList();
      
      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error al cargar tareas: $e'),
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
        // Navegar a Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentHomeScreen(alumnoId: widget.alumnoId),
          ),
        );
        break;
      case 1:
        // Ya estamos en Tareas, no hacer nada
        break;
      case 2:
        // Navegar a Perfil
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentProfileScreen(alumnoId: widget.alumnoId),
          ),
        );
        break;
    }
  }

  void _initializeTasksList() {
    tasks = evaluaciones.map((evaluacion) {
      // Buscar materia por ID
      final materia = materias.firstWhere(
        (m) => m.id == evaluacion.materia_id,
        orElse: () => Materia(
          id: evaluacion.materia_id,
          nombre: evaluacion.materia_nombre.isNotEmpty
              ? evaluacion.materia_nombre
              : 'Materia desconocida',
          descripcion: '',
          curso_id: null,
          docente_id: null,
          gestion_id: evaluacion.gestion_id,
          curso_nombre: '',
          docente_nombre: '',
          gestion_anio: evaluacion.gestion_anio,
        ),
      );

      // Buscar nota correspondiente
      final nota = notasEvaluacion
              .where((n) => n.evaluacion_id == evaluacion.id)
              .isNotEmpty
          ? notasEvaluacion.firstWhere(
              (n) => n.evaluacion_id == evaluacion.id,
            )
          : null;

      return TaskWithDetails(
        evaluacion: evaluacion,
        nota: nota,
        materia: materia,
      );
    }).toList();

    // Ordenar por ID (más recientes primero, asumiendo que ID mayor = más reciente)
    tasks.sort((a, b) => b.evaluacion.id.compareTo(a.evaluacion.id));
  }

  List<TaskWithDetails> get filteredTasks {
    return tasks.where((task) {
      // Filtro por materia
      if (selectedSubject != 'Todas' &&
          task.materia.nombre != selectedSubject) {
        return false;
      }

      // Filtro por estado
      if (selectedStatus == 'Pendientes' && !task.isPending) {
        return false;
      }
      if (selectedStatus == 'Entregadas' && task.isPending) {
        return false;
      }

      // Filtro por búsqueda
      if (searchController.text.isNotEmpty) {
        final query = searchController.text.toLowerCase();
        return task.evaluacion.nombre.toLowerCase().contains(query) ||
            task.materia.nombre.toLowerCase().contains(query);
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.grey.shade50,
        appBar: AppBar(
          title: const Text('Mis Tareas'),
          backgroundColor: Colors.blue.shade600,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
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

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Mis Tareas'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeTestData,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFiltersSection(),
          _buildSearchBar(),
          _buildTasksStats(),
          Expanded(child: _buildTasksListWidget()),
        ],
      ),
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

  Widget _buildFiltersSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      color: Colors.blue[50],
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: _buildSubjectFilter()),
              const SizedBox(width: 16),
              Expanded(child: _buildStatusFilter()),
            ],
          ),
          const SizedBox(height: 12),
          _buildSubjectChips(),
        ],
      ),
    );
  }

  Widget _buildSubjectFilter() {
    final subjects = ['Todas', ...materias.map((m) => m.nombre).toSet()];

    return DropdownButtonFormField<String>(
      value: selectedSubject,
      decoration: InputDecoration(
        labelText: 'Materia',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: subjects
          .map(
            (subject) =>
                DropdownMenuItem(value: subject, child: Text(subject)),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedSubject = value!;
        });
      },
    );
  }

  Widget _buildStatusFilter() {
    return DropdownButtonFormField<String>(
      value: selectedStatus,
      decoration: InputDecoration(
        labelText: 'Estado',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      items: ['Todas', 'Pendientes', 'Entregadas']
          .map(
            (status) =>
                DropdownMenuItem(value: status, child: Text(status)),
          )
          .toList(),
      onChanged: (value) {
        setState(() {
          selectedStatus = value!;
        });
      },
    );
  }

  Widget _buildSubjectChips() {
    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: materias.length,
        itemBuilder: (context, index) {
          final materia = materias[index];
          final isSelected = selectedSubject == materia.nombre;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: SubjectChip(
              label: materia.nombre,
              isSelected: isSelected,
              onTap: () {
                setState(() {
                  selectedSubject = isSelected ? 'Todas' : materia.nombre;
                });
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: TextField(
        controller: searchController,
        decoration: InputDecoration(
          hintText: 'Buscar tareas...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(25)),
          filled: true,
          fillColor: Colors.grey[100],
        ),
        onChanged: (value) {
          setState(() {});
        },
      ),
    );
  }

  Widget _buildTasksStats() {
    final pendingCount = tasks.where((t) => t.isPending).length;
    final completedCount = tasks.where((t) => !t.isPending).length;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[600],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem(
            'Pendientes',
            pendingCount,
            Icons.schedule,
            Colors.orange,
          ),
          Container(width: 1, height: 40, color: Colors.white54),
          _buildStatItem(
            'Entregadas',
            completedCount,
            Icons.check_circle,
            Colors.green,
          ),
          Container(width: 1, height: 40, color: Colors.white54),
          _buildStatItem('Total', tasks.length, Icons.assignment, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, int count, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(height: 4),
        Text(
          count.toString(),
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildTasksListWidget() {
    final filtered = filteredTasks;

    if (filtered.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No se encontraron tareas',
              style: TextStyle(fontSize: 18, color: Colors.grey[600]),
            ),
            const SizedBox(height: 8),
            Text(
              'Prueba cambiando los filtros',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        return TaskItem(
          task: filtered[index],
          onTap: () => _showTaskDetails(filtered[index]),
        );
      },
    );
  }

  void _showTaskDetails(TaskWithDetails task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => TaskDetailsSheet(task: task),
    );
  }
}

class TaskItem extends StatelessWidget {
  final TaskWithDetails task;
  final VoidCallback onTap;

  const TaskItem({Key? key, required this.task, required this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      task.evaluacion.nombre,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  _buildStatusChip(),
                ],
              ),
              const SizedBox(height: 8),
              const SizedBox(height: 12),
              Row(
                children: [
                  SubjectChip(
                    label: task.materia.nombre,
                    isSelected: false,
                    onTap: () {},
                    isSmall: true,
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      task.evaluacion.tipo,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.blue[100],
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  const Spacer(),
                  if (task.nota?.nota != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getGradeColor(task.nota!.nota!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${task.nota!.nota!.toStringAsFixed(0)}/100',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 4),
                  Text(
                    'Trimestre: ${task.evaluacion.trimestre}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const Spacer(),
                  if (task.evaluacion.porcentaje != null)
                    Text(
                      'Ponderación: ${task.evaluacion.porcentaje}%',
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: task.statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: task.statusColor, width: 1),
      ),
      child: Text(
        task.status,
        style: TextStyle(
          color: task.statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Color _getGradeColor(double grade) {
    if (grade >= 80) return Colors.green;
    if (grade >= 60) return Colors.orange;
    return Colors.red;
  }
}

class SubjectChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool isSmall;

  const SubjectChip({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.isSmall = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: isSmall ? 8 : 12,
          vertical: isSmall ? 4 : 8,
        ),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[600] : Colors.grey[200],
          borderRadius: BorderRadius.circular(16),
          border: isSelected ? null : Border.all(color: Colors.grey[400]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontSize: isSmall ? 12 : 14,
            fontWeight: isSelected ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}

class TaskDetailsSheet extends StatelessWidget {
  final TaskWithDetails task;

  const TaskDetailsSheet({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  task.evaluacion.nombre,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Materia', task.materia.nombre),
          _buildDetailRow('Tipo', task.evaluacion.tipo),
          _buildDetailRow('Dimensión', task.evaluacion.dimension),
          if (task.evaluacion.porcentaje != null)
            _buildDetailRow('Ponderación', '${task.evaluacion.porcentaje}%'),
          _buildDetailRow('Trimestre', task.evaluacion.trimestre.toString()),
          _buildDetailRow('Estado', task.status),
          if (task.nota?.nota != null)
            _buildDetailRow(
              'Calificación',
              '${task.nota!.nota!.toStringAsFixed(1)}/100',
            ),
          _buildDetailRow('Gestión', task.evaluacion.gestion_anio.toString()),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}