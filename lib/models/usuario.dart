class Usuario {
  String id;
  String nombre;
  String apellido;
  String correo;

  Usuario({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.correo,
  });

  factory Usuario.fromMap(
    Map<String, dynamic> data,
    String id,
  ) {
    return Usuario(
      id: id,
      nombre: data["Nombre"],
      apellido: data["Apellido"],
      correo: data["Correo"],
    );
  }
}