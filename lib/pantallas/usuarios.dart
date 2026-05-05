import 'package:flutter/material.dart';
import '../servicios/firebase_service.dart';

class Usuarios extends StatefulWidget {
  const Usuarios({super.key});

  @override
  State<Usuarios> createState() => _UsuariosState();
}

class _UsuariosState extends State<Usuarios> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF131A22),

      appBar: AppBar(
  title: const Text("Usuarios"),
  backgroundColor: const Color(0xFF232F3E),
  elevation: 0,

  // ✅ TEXTO BLANCO
  titleTextStyle: const TextStyle(
    color: Colors.white,
    fontSize: 20,
    fontWeight: FontWeight.bold,
  ),

  // ✅ FLECHA BLANCA
  iconTheme: const IconThemeData(
    color: Colors.white,
  ),
),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(
          Icons.person_add,
          color: Colors.black,
        ),
        onPressed: () {
          mostrarFormulario();
        },
      ),

      body: FutureBuilder(
        future: obtenerUsuarios(),
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
                "No hay usuarios 👤",
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
              return tarjetaUsuario(
                snapshot.data![index],
              );
            },
          );
        },
      ),
    );
  }

  // 💎 TARJETA MODERNA
  Widget tarjetaUsuario(usuario) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(15),
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
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.orange.withOpacity(0.2),
                child: const Icon(
                  Icons.person,
                  color: Colors.orange,
                  size: 35,
                ),
              ),

              const SizedBox(width: 15),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${usuario["nombre"]} ${usuario["apellido"]}",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      usuario["correo"],
                      style: const TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
                    usuario: usuario,
                  );
                },
              ),
              IconButton(
                icon: const Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () async {
                  await eliminarUsuario(
                    usuario["id"],
                  );
                  setState(() {});
                },
              ),
            ],
          )
        ],
      ),
    );
  }

  // 🧾 FORMULARIO
  void mostrarFormulario({usuario}) {
    TextEditingController nombre =
        TextEditingController(
      text: usuario != null
          ? usuario["nombre"]
          : "",
    );

    TextEditingController apellido =
        TextEditingController(
      text: usuario != null
          ? usuario["apellido"]
          : "",
    );

    TextEditingController correo =
        TextEditingController(
      text: usuario != null
          ? usuario["correo"]
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
            usuario == null
                ? "Agregar Usuario"
                : "Editar Usuario",
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                campo(nombre, "Nombre",
                    Icons.person),
                const SizedBox(height: 10),
                campo(apellido, "Apellido",
                    Icons.badge),
                const SizedBox(height: 10),
                campo(correo, "Correo",
                    Icons.email),
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
                if (usuario == null) {
                  await agregarUsuario(
                    nombre.text,
                    apellido.text,
                    correo.text,
                  );
                } else {
                  await actualizarUsuario(
                    usuario["id"],
                    nombre.text,
                    apellido.text,
                    correo.text,
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
            ),
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