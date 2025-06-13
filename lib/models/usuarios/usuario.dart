import 'docente.dart';

class Usuario {
  final int id;
  final String username;
  final String password; //no se si es necesario
  final String rol;
  final Docente? docente_id;

  Usuario({
    required this.id,
    required this.username,
    required this.password,
    required this.rol,
    this.docente_id,
  });
}