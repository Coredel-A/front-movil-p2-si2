class LoginResponse {
  final String accessToken;
  final String refreshToken;
  final int userId;
  final String rol;
  final String username;
  final String nombreCompleto;
  final int? alumnoId;
  final int? cursoId;
  final int? profesorId;
  final int? directorId;
  final int? padreId;
  final String? fechaNacimiento;

  LoginResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.userId,
    required this.rol,
    required this.username,
    required this.nombreCompleto,
    this.alumnoId,
    this.cursoId,
    this.profesorId,
    this.directorId,
    this.padreId,
    this.fechaNacimiento,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      accessToken: json['access'],
      refreshToken: json['refresh'],
      userId: json['user_id'],
      rol: json['rol'],
      username: json['username'],
      nombreCompleto: json['nombre_completo'],
      alumnoId: json['alumno_id'],
      cursoId: json['curso_id'],
      profesorId: json['profesor_id'],
      directorId: json['director_id'],
      padreId: json['padre_id'],
      fechaNacimiento: json['fecha_nacimiento'],
    );
  }
}
