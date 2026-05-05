import 'package:flutter/material.dart';
import '../servicios/firebase_service.dart';

class Productos extends StatefulWidget {
  const Productos({super.key});

  @override
  State<Productos> createState() => _ProductosState();
}

class _ProductosState extends State<Productos> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131A22),

      appBar: AppBar(
  title: const Text("Productos"),
  backgroundColor: const Color(0xFF232F3E),
  elevation: 0,

  // ✅ TEXTO EN BLANCO
  titleTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),

  // ✅ FLECHA EN BLANCO
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add, color: Colors.black),
        onPressed: () {
          mostrarFormulario();
        },
      ),

      body: FutureBuilder(
        future: obtenerProductos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                "No hay productos 🛒",
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              return tarjetaProducto(
                  snapshot.data![index]);
            },
          );
        },
      ),
    );
  }

  // 💎 TARJETA MODERNA
  Widget tarjetaProducto(producto) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          // 🖼 IMAGEN
          ClipRRect(
            borderRadius:
                const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
            child: Image.network(
              producto["imagen"]
                  .toString()
                  .trim(),
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,

              errorBuilder: (_, __, ___) {
                return Container(
                  height: 200,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(Icons.image,
                        size: 50),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(15),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  producto["nombre"],
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "\$${producto["precio"]}",
                  style: const TextStyle(
                    fontSize: 22,
                    color: Colors.green,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  "Stock: ${producto["stock"]}",
                  style: const TextStyle(
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 15),

                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit,
                        color: Colors.blue,
                      ),
                      onPressed: () {
                        mostrarFormulario(
                          producto: producto,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                      onPressed: () async {
                        await eliminarProducto(
                          producto["id"],
                        );
                        setState(() {});
                      },
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // 🧾 FORMULARIO
  void mostrarFormulario({producto}) {
    TextEditingController nombre =
        TextEditingController(
      text: producto != null
          ? producto["nombre"]
          : "",
    );

    TextEditingController precio =
        TextEditingController(
      text: producto != null
          ? producto["precio"]
          : "",
    );

    TextEditingController stock =
        TextEditingController(
      text: producto != null
          ? producto["stock"]
          : "",
    );

    TextEditingController imagen =
        TextEditingController(
      text: producto != null
          ? producto["imagen"]
          : "",
    );

    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(20),
          ),
          title: Text(
            producto == null
                ? "Agregar Producto"
                : "Editar Producto",
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                campo(nombre, "Nombre",
                    Icons.shopping_bag),
                const SizedBox(height: 10),
                campo(precio, "Precio",
                    Icons.attach_money),
                const SizedBox(height: 10),
                campo(stock, "Stock",
                    Icons.inventory),
                const SizedBox(height: 10),
                campo(imagen, "URL Imagen",
                    Icons.link),
              ],
            ),
          ),

          actions: [
            ElevatedButton(
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    Colors.orange,
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          10),
                ),
              ),
              onPressed: () async {
                if (producto == null) {
                  await agregarProducto(
                    nombre.text,
                    precio.text,
                    stock.text,
                    imagen.text,
                  );
                } else {
                  await actualizarProducto(
                    producto["id"],
                    nombre.text,
                    precio.text,
                    stock.text,
                    imagen.text,
                  );
                }

                Navigator.pop(context);
                setState(() {});
              },
              child: const Text(
                "Guardar",
                style: TextStyle(
                  color: Colors.black,
                ),
              ),
            )
          ],
        );
      },
    );
  }

  // ✨ CAMPO reutilizable
  Widget campo(
      TextEditingController controller,
      String texto,
      IconData icono) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: texto,
        prefixIcon: Icon(icono),
        border: OutlineInputBorder(
          borderRadius:
              BorderRadius.circular(15),
        ),
      ),
    );
  }
}