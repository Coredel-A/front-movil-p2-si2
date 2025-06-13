import 'package:aula_virtual/providers/usuarios/auth_provider.dart';
import 'package:aula_virtual/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de los archivos necesarios
import 'package:aula_virtual/models/usuarios/docente.dart';
import 'package:aula_virtual/models/colegio/materia.dart';
import 'package:aula_virtual/models/colegio/curso.dart';
import 'package:aula_virtual/models/info_item.dart';
import 'package:aula_virtual/providers/usuarios/docente_provider.dart';
import 'package:aula_virtual/providers/colegio/materia_provider.dart';
import 'package:aula_virtual/providers/colegio/curso_provider.dart';
import 'package:aula_virtual/screens/docentes/teacher_home_screen.dart'; // Importa tu home screen

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

// Widget para mostrar las materias asignadas
class MateriasSection extends StatelessWidget {
  final List<Materia> materias;

  const MateriasSection({Key? key, required this.materias}) : super(key: key);

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
            const Text(
              'Materias Asignadas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (materias.isEmpty)
              const Text(
                'No hay materias asignadas',
                style: TextStyle(fontSize: 14, color: Colors.grey),
              )
            else
              ...materias.map(
                (materia) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue.shade200),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.book,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              materia.nombre,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade800,
                              ),
                            ),
                          ),
                        ],
                      ),
                      if (materia.descripcion.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text(
                          materia.descripcion,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade700,
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Icon(
                            Icons.class_,
                            color: Colors.grey.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Curso: ${materia.curso_nombre}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis, // 👈 opcional
                            ),
                          ),
                          const SizedBox(width: 16),
                          Icon(
                            Icons.calendar_today,
                            color: Colors.grey.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Gestión: ${materia.gestion_anio}',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade700,
                              ),
                              overflow: TextOverflow.ellipsis, // 👈 opcional
                            ),
                          ),
                        ],
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

// Tarjeta principal del docente
class TeacherCard extends StatelessWidget {
  final Docente docente;

  const TeacherCard({Key? key, required this.docente}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Círculo con inicial del nombre
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 2,
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  docente.nombre.isNotEmpty
                      ? docente.nombre[0].toUpperCase()
                      : 'D',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Nombre completo
            Text(
              '${docente.nombre} ${docente.apellido}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            // Especialidad
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                docente.especialidad,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pantalla de perfil del docente
class TeacherProfileScreen extends StatefulWidget {
  final int? docenteId; // ID del docente a mostrar, si es null usa el docente actual

  const TeacherProfileScreen({Key? key, this.docenteId}) : super(key: key);

  @override
  State<TeacherProfileScreen> createState() => _TeacherProfileScreenState();
}

class _TeacherProfileScreenState extends State<TeacherProfileScreen> {
  bool _isLoading = true;
  String? _error;
  int _selectedIndex = 1; // Índice 1 para perfil (ya que estamos en perfil)

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

      final docenteProvider = Provider.of<DocenteProvider>(
        context,
        listen: false,
      );
      final materiaProvider = Provider.of<MateriaProvider>(
        context,
        listen: false,
      );

      // Cargar datos del docente
      if (widget.docenteId != null) {
        await docenteProvider.fetchDocenteById(widget.docenteId!);
      } else {
        await docenteProvider.getCurrentDocente();
      }

      // Cargar todas las materias para filtrar las del docente
      await materiaProvider.fetchMaterias();

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

  List<InfoItem> _buildPersonalInfo(Docente docente) {
    return [
      InfoItem(
        label: 'Especialidad',
        value: docente.especialidad,
        icon: Icons.school,
      ),
      InfoItem(
        label: 'Correo Electrónico',
        value: docente.email.isNotEmpty ? docente.email : 'No registrado',
        icon: Icons.email,
      ),
      InfoItem(
        label: 'Teléfono',
        value: docente.telefono.isNotEmpty ? docente.telefono : 'No registrado',
        icon: Icons.phone,
      ),
    ];
  }

  List<Materia> _getMateriasDelDocente(
    List<Materia> todasLasMaterias,
    int docenteId,
  ) {
    return todasLasMaterias
        .where((materia) => materia.docente_id == docenteId)
        .toList();
  }

  Set<String> _getCursosUnicos(List<Materia> materias) {
    return materias
        .map((materia) => materia.curso_nombre)
        .where((nombre) => nombre.isNotEmpty)
        .toSet();
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
      ),
      body: _isLoading
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
              : Consumer2<DocenteProvider, MateriaProvider>(
                  builder: (context, docenteProvider, materiaProvider, child) {
                    final docente = docenteProvider.currentdocente;

                    if (docente == null) {
                      return const Center(
                        child: Text(
                          'No se pudo cargar la información del docente',
                        ),
                      );
                    }

                    final materiasDelDocente = _getMateriasDelDocente(
                      materiaProvider.materias,
                      docente.id,
                    );
                    final cursosUnicos = _getCursosUnicos(materiasDelDocente);

                    return RefreshIndicator(
                      onRefresh: _refreshData,
                      child: SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // Tarjeta principal del docente
                            TeacherCard(docente: docente),

                            const SizedBox(height: 20),

                            // Información personal
                            InfoSection(
                              title: 'Información Personal',
                              items: _buildPersonalInfo(docente),
                            ),

                            const SizedBox(height: 20),

                            // Información de cursos a cargo
                            if (cursosUnicos.isNotEmpty) ...[
                              InfoSection(
                                title: 'Cursos a Cargo',
                                items: [
                                  InfoItem(
                                    label: 'Cantidad de Cursos',
                                    value: cursosUnicos.length.toString(),
                                    icon: Icons.class_,
                                  ),
                                  InfoItem(
                                    label: 'Cursos',
                                    value: cursosUnicos.join(', '),
                                    icon: Icons.list,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                            ],

                            // Materias asignadas
                            MateriasSection(materias: materiasDelDocente),

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
      // Barra de navegación inferior
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 0) { // Índice 0 corresponde al botón "Inicio"
            // Navegar al home del docente
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherHomeScreen(docenteId: widget.docenteId),
              ),
            );
          }
          // Si index == 1 (Perfil), ya estamos aquí, no hacer nada
        },
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.blue[600],
        unselectedItemColor: Colors.grey[400],
        elevation: 0,
        selectedLabelStyle: const TextStyle(fontSize: 12),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Inicio'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}