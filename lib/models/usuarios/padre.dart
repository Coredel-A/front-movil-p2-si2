class Padre {
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String rol;
  final String ci;
  final String telefono;
  final String genero;
  final String estado;
  final String ocupacion;
  final List<int> alumnos;

  Padre({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.rol,
    required this.ci,
    required this.telefono,
    required this.genero,
    required this.estado,
    required this.ocupacion,
    required this.alumnos,
  });

  factory Padre.fromJson(Map<String, dynamic> json) {
    return Padre(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      rol: json['rol'],
      ci: json['ci'],
      telefono: json['telefono'],
      genero: json['genero'],
      estado: json['estado'],
      ocupacion: json['ocupacion'],
      alumnos: List<int>.from(json['alumnos']),
    );
  }
}
