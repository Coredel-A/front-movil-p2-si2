import 'package:aula_virtual/providers/usuarios/auth_provider.dart';
import 'package:aula_virtual/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Imports de los archivos separados
import 'package:aula_virtual/models/usuarios/padre.dart';
import 'package:aula_virtual/models/usuarios/alumno.dart';
import 'package:aula_virtual/models/info_item.dart';

import 'package:aula_virtual/providers/usuarios/padre_provider.dart';
import 'package:aula_virtual/providers/usuarios/alumno_provider.dart';

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

// Widget para mostrar tarjeta del padre
class ParentCard extends StatelessWidget {
  final Padre padre;

  const ParentCard({Key? key, required this.padre}) : super(key: key);

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
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white,
              child: Icon(
                Icons.person,
                size: 60,
                color: Colors.blue.shade600,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${padre.firstName} ${padre.lastName}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                padre.ocupacion,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.family_restroom,
                  color: Colors.white.withOpacity(0.9),
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${padre.alumnos.length} hijo${padre.alumnos.length != 1 ? 's' : ''} vinculado${padre.alumnos.length != 1 ? 's' : ''}',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
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

// Widget para mostrar lista de hijos
class ChildrenSection extends StatelessWidget {
  final List<Alumno> hijos;

  const ChildrenSection({Key? key, required this.hijos}) : super(key: key);

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
              'Hijos Vinculados',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 16),
            if (hijos.isEmpty)
              const Text(
                'No hay hijos vinculados',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              )
            else
              ...hijos.map(
                (hijo) => Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blue.shade100,
                        child: Icon(
                          Icons.person,
                          color: Colors.blue.shade600,
                          size: 30,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hijo.nombre_completo,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Código: ${hijo.codigo}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Curso: ${hijo.curso_nombre.isNotEmpty ? hijo.curso_nombre : 'No asignado'}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: hijo.estado == 'activo'
                                    ? Colors.green.shade100
                                    : Colors.red.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                hijo.estado,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: hijo.estado == 'activo'
                                      ? Colors.green.shade700
                                      : Colors.red.shade700,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.grey.shade400,
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

// Pantalla de perfil del padre
class ParentProfileScreen extends StatefulWidget {
  final int padreId;

  const ParentProfileScreen({Key? key, required this.padreId})
      : super(key: key);

  @override
  State<ParentProfileScreen> createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  bool _isLoading = true;
  String? _error;
  List<Alumno> _hijos = [];

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

      final padreProvider = Provider.of<PadreProvider>(
        context,
        listen: false,
      );
      final alumnoProvider = Provider.of<AlumnoProvider>(
        context,
        listen: false,
      );

      // Cargar datos del padre usando el padreId pasado como parámetro
      await padreProvider.getPadreById(widget.padreId);

      // Cargar datos de los hijos
      final padre = padreProvider.selectedPadre;
      if (padre != null && padre.alumnos.isNotEmpty) {
        _hijos = [];
        for (int alumnoId in padre.alumnos) {
          try {
            await alumnoProvider.getAlumnoById(alumnoId);
            final alumno = alumnoProvider.currentAlumno;
            if (alumno != null) {
              _hijos.add(alumno);
            }
          } catch (e) {
            print('Error al cargar alumno $alumnoId: $e');
          }
        }
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

  void _logout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    
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
              onPressed: () async {
                Navigator.of(context).pop();
                await authProvider.logout();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => LoginScreen()),
                  (route) => false,
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Sesión cerrada exitosamente'),
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

  List<InfoItem> _buildPersonalInfo(Padre padre) {
    return [
      InfoItem(
        label: 'Cédula de Identidad',
        value: padre.ci,
        icon: Icons.badge,
      ),
      InfoItem(
        label: 'Usuario',
        value: padre.username,
        icon: Icons.account_circle,
      ),
      InfoItem(
        label: 'Género',
        value: padre.genero == 'M' ? 'Masculino' : 'Femenino',
        icon: Icons.person,
      ),
      InfoItem(
        label: 'Ocupación',
        value: padre.ocupacion,
        icon: Icons.work,
      ),
      InfoItem(
        label: 'Estado',
        value: padre.estado,
        icon: Icons.verified_user,
      ),
    ];
  }

  List<InfoItem> _buildContactInfo(Padre padre) {
    return [
      InfoItem(
        label: 'Teléfono',
        value: padre.telefono.isNotEmpty ? padre.telefono : 'No registrado',
        icon: Icons.phone,
      ),
      InfoItem(
        label: 'Correo Electrónico',
        value: padre.email.isNotEmpty ? padre.email : 'No registrado',
        icon: Icons.email,
      ),
    ];
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
              : Consumer<PadreProvider>(
                  builder: (context, padreProvider, child) {
                    final padre = padreProvider.selectedPadre;

                    if (padre == null) {
                      return const Center(
                        child: Text(
                          'No se pudo cargar la información del padre',
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
                            // Tarjeta principal del padre
                            ParentCard(padre: padre),

                            const SizedBox(height: 20),

                            // Información personal
                            InfoSection(
                              title: 'Información Personal',
                              items: _buildPersonalInfo(padre),
                            ),

                            const SizedBox(height: 20),

                            // Información de contacto
                            InfoSection(
                              title: 'Información de Contacto',
                              items: _buildContactInfo(padre),
                            ),

                            const SizedBox(height: 20),

                            // Lista de hijos vinculados
                            ChildrenSection(hijos: _hijos),

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
    );
  }
}