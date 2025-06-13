class Alumno {
  final int id;
  final String codigo;
  final DateTime fecha_nacimiento;
  final String direccion;
  final String username;
  final String email;
  final String first_name;
  final String last_name;
  final String rol;
  final String ci;
  final String telefono;
  final String genero;
  final String estado;
  final int curso_id;
  final String curso_nombre;
  final int? padre_id;
  
  Alumno({
    required this.id,
    required this.codigo,
    required this.fecha_nacimiento,
    required this.direccion,
    required this.username,
    required this.email,
    required this.first_name,
    required this.last_name,
    required this.rol,
    required this.ci,
    required this.telefono,
    required this.genero,
    required this.estado,
    required this.curso_id,
    required this.curso_nombre,
    this.padre_id,
  });

  String get nombre_completo => '$first_name $last_name';

  int get edad {
    final now = DateTime.now();
    int edad = now.year - fecha_nacimiento.year;
    if (now.month < fecha_nacimiento.month ||
        (now.month == fecha_nacimiento.month &&
            now.day < fecha_nacimiento.day)) {
      edad--;
    }
    return edad;
  }

  factory Alumno.fromJson(Map<String, dynamic> json) {
    return Alumno(
      id: json['id'],
      codigo: json['codigo'] ?? '',
      fecha_nacimiento: DateTime.parse(json['fecha_nacimiento']),
      direccion: json['direccion'] ?? '',
      username: json['username'] ?? '',
      email: json['email'] ?? '',
      first_name: json['first_name'] ?? '',
      last_name: json['last_name'] ?? '',
      rol: json['rol'] ?? '',
      ci: json['ci'],
      telefono: json['telefono'] ?? '',
      genero: json['genero'] ?? '',
      estado: json['estado'] ?? '',
      curso_id: json['curso_id'] ?? 0,
      curso_nombre: json['curso_nombre'] ?? '',
      padre_id: json['padre_id'] ?? 0,
    );
  }
}
