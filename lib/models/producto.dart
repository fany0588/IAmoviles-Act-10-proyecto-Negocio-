class Producto {
  String id;
  String nombre;
  String precio;
  String stock;
  String imagen;

  Producto({
    required this.id,
    required this.nombre,
    required this.precio,
    required this.stock,
    required this.imagen,
  });

  factory Producto.fromMap(
    Map<String, dynamic> data,
    String id,
  ) {
    return Producto(
      id: id,
      nombre: data["nombre"],
      precio: data["precio"],
      stock: data["stock"],
      imagen: data["imagen"],
    );
  }
}