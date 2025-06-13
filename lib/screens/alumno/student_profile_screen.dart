import 'package:aula_virtual/providers/usuarios/auth_provider.dart';
import 'package:aula_virtual/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de los archivos separados
import 'package:aula_virtual/models/usuarios/alumno.dart';
import 'package:aula_virtual/models/colegio/curso.dart';
import 'package:aula_virtual/models/info_item.dart';

import 'package:aula_virtual/providers/usuarios/alumno_provider.dart';
import 'package:aula_virtual/providers/colegio/curso_provider.dart';

import 'package:aula_virtual/utils/date_formatter.dart';
import 'package:aula_virtual/widgets/alumno/student_card.dart';

// Screens - Imports para navegación
import 'package:aula_virtual/screens/alumno/student_home_screen.dart';
import 'package:aula_virtual/screens/alumno/student_task_screen.dart';

// Widget para mostrar información detallada
class InfoSection extends StatelessWidget {
  final String title;
  final List<InfoItem> items;

  const InfoSection({Key? key, required this.title, required this.items})
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            ...items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(item.icon, size: 20, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.label,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item.value,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de perfil del estudiante
class StudentProfileScreen extends StatefulWidget {
  final int
  alumnoId; // Cambiado para que sea requerido como en StudentHomeScreen

  const StudentProfileScreen({Key? key, required this.alumnoId})
    : super(key: key);

  @override
  State<StudentProfileScreen> createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 2; // Índice 2 para Perfil

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final alumnoProvider = Provider.of<AlumnoProvider>(
        context,
        listen: false,
      );
      final cursoProvider = Provider.of<CursoProvider>(context, listen: false);

      // Cargar datos del alumno usando el alumnoId pasado como parámetro
      await alumnoProvider.getAlumnoById(widget.alumnoId);

      // Cargar datos del curso si el alumno tiene un curso asignado
      final alumno = alumnoProvider.currentAlumno;
      if (alumno != null && alumno.curso_id > 0) {
        await cursoProvider.fetchCursoById(alumno.curso_id);
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _error = 'Error al cargar los datos: ${e.toString()}';
      });
    }
  }

  Future<void> _refreshData() async {
    await _loadData();
  }

  // Función para manejar la navegación
  void _onItemTapped(int index) {
    if (index == _selectedIndex)
      return; // No hacer nada si ya está en la pestaña actual

    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentHomeScreen(alumnoId: widget.alumnoId),
          ),
        );
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
        // Ya estamos en Perfil, no hacer nada
        break;
    }
  }

  void _showSettings() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Funcionalidad de configuración próximamente'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Cerrar Sesión'),
          content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
                // Aquí irá la lógica de logout
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Cerrando sesión...'),
                    duration: Duration(seconds: 2),
                  ),
                );
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cerrar Sesión'),
            ),
          ],
        );
      },
    );
  }

  List<InfoItem> _buildPersonalInfo(Alumno alumno) {
    return [
      InfoItem(
        label: 'Cédula de Identidad',
        value: alumno.ci,
        icon: Icons.badge,
      ),
      InfoItem(
        label: 'Código de Estudiante',
        value: alumno.codigo,
        icon: Icons.qr_code,
      ),
      InfoItem(
        label: 'Fecha de Nacimiento',
        value:
            '${DateFormatter.formatDateToSpanish(alumno.fecha_nacimiento)} (${alumno.edad} años)',
        icon: Icons.cake,
      ),
      InfoItem(label: 'Género', value: alumno.genero, icon: Icons.person),
      InfoItem(
        label: 'Teléfono',
        value: alumno.telefono.isNotEmpty ? alumno.telefono : 'No registrado',
        icon: Icons.phone,
      ),
      InfoItem(
        label: 'Correo Electrónico',
        value: alumno.email.isNotEmpty ? alumno.email : 'No registrado',
        icon: Icons.email,
      ),
      InfoItem(
        label: 'Dirección',
        value: alumno.direccion.isNotEmpty ? alumno.direccion : 'No registrada',
        icon: Icons.location_on,
      ),
      InfoItem(
        label: 'Estado',
        value: alumno.estado,
        icon: Icons.verified_user,
      ),
    ];
  }

  List<InfoItem> _buildAcademicInfo(Alumno alumno, Curso? curso) {
    List<InfoItem> items = [];

    // Si tenemos datos del curso desde el provider
    if (curso != null) {
      items.addAll([
        InfoItem(
          label: 'Curso Actual',
          value: curso.nombre,
          icon: Icons.school,
        ),
        InfoItem(
          label: 'Descripción del Curso',
          value: curso.descripcion,
          icon: Icons.description,
        ),
        InfoItem(label: 'Nivel', value: curso.nivel, icon: Icons.grade),
        InfoItem(label: 'Turno', value: curso.turno, icon: Icons.schedule),
      ]);
    } else if (alumno.curso_nombre.isNotEmpty) {
      // Si no tenemos el curso completo pero sí el nombre desde el alumno
      items.add(
        InfoItem(
          label: 'Curso Actual',
          value: alumno.curso_nombre,
          icon: Icons.school,
        ),
      );
    } else {
      items.add(
        InfoItem(
          label: 'Curso Actual',
          value: 'No asignado',
          icon: Icons.school,
        ),
      );
    }

    return items;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        backgroundColor: Colors.blue.shade600,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _refreshData),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _error != null
              ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Colors.red.shade400,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      _error!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.red.shade600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshData,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              )
              : Consumer2<AlumnoProvider, CursoProvider>(
                builder: (context, alumnoProvider, cursoProvider, child) {
                  final alumno = alumnoProvider.currentAlumno;
                  final curso = cursoProvider.currentCurso;

                  if (alumno == null) {
                    return const Center(
                      child: Text(
                        'No se pudo cargar la información del alumno',
                      ),
                    );
                  }

                  return RefreshIndicator(
                    onRefresh: _refreshData,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          // Tarjeta principal del estudiante
                          StudentCard(alumno: alumno, curso: curso),

                          const SizedBox(height: 20),

                          // Información personal
                          InfoSection(
                            title: 'Información Personal',
                            items: _buildPersonalInfo(alumno),
                          ),

                          const SizedBox(height: 20),

                          // Información académica
                          InfoSection(
                            title: 'Información Académica',
                            items: _buildAcademicInfo(alumno, curso),
                          ),

                          const SizedBox(height: 20),

                          // Botones de configuración
                          Container(
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
                                  const Text(
                                    'Configuración',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: OutlinedButton.icon(
                                          onPressed: _logout,
                                          icon: const Icon(Icons.logout),
                                          label: const Text('Cerrar Sesión'),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: Colors.red,
                                            padding: const EdgeInsets.symmetric(
                                              vertical: 12,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          const SizedBox(height: 32),
                        ],
                      ),
                    ),
                  );
                },
              ),
      // Barra de navegación agregada
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
