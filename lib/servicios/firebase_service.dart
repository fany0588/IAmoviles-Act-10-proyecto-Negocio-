import 'package:cloud_firestore/cloud_firestore.dart';

FirebaseFirestore db = FirebaseFirestore.instance;

/* ===========================
        PRODUCTOS
=========================== */

Future<List> obtenerProductos() async {
  List productos = [];

  CollectionReference collectionReference =
      db.collection('productos');

  QuerySnapshot queryProductos =
      await collectionReference.get();

  for (var documento in queryProductos.docs) {
    productos.add({
      "id": documento.id,
      ...documento.data() as Map<String, dynamic>
    });
  }

  return productos;
}

Future<void> agregarProducto(
    String nombre,
    String precio,
    String stock,
    String imagen) async {
  await db.collection("productos").add({
    "nombre": nombre,
    "precio": precio,
    "stock": stock,
    "imagen": imagen,
  });
}

Future<void> actualizarProducto(
    String id,
    String nombre,
    String precio,
    String stock,
    String imagen) async {
  await db.collection("productos").doc(id).set({
    "nombre": nombre,
    "precio": precio,
    "stock": stock,
    "imagen": imagen,
  });
}

Future<void> eliminarProducto(String id) async {
  await db.collection("productos").doc(id).delete();
}

/* ===========================
        USUARIOS
=========================== */

Future<List> obtenerUsuarios() async {
  List usuarios = [];

  CollectionReference collectionReference =
      db.collection('usuarios');

  QuerySnapshot queryUsuarios =
      await collectionReference.get();

  for (var documento in queryUsuarios.docs) {
    usuarios.add({
      "id": documento.id,
      ...documento.data() as Map<String, dynamic>
    });
  }

  return usuarios;
}

Future<void> agregarUsuario(
    String nombre,
    String apellido,
    String correo) async {
  await db.collection("usuarios").add({
    "nombre": nombre,
    "apellido": apellido,
    "correo": correo,
  });
}

Future<void> actualizarUsuario(
    String id,
    String nombre,
    String apellido,
    String correo) async {
  await db.collection("usuarios").doc(id).set({
    "nombre": nombre,
    "apellido": apellido,
    "correo": correo,
  });
}

Future<void> eliminarUsuario(String id) async {
  await db.collection("usuarios").doc(id).delete();
}