import 'package:flutter/material.dart';
import '../servicios/auth_service.dart';
import 'productos.dart';
import 'usuarios.dart';
import 'login.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF232F3E), Color(0xFF131A22)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Column(
              children: [
                // 🔝 HEADER CON LOGOUT
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Amazon CRUD",
                      style: TextStyle(
                        color: Colors.orange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    IconButton(
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.orange,
                      ),
                      onPressed: () async {
                        await logout();

                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                const Login(),
                          ),
                          (route) => false,
                        );
                      },
                    )
                  ],
                ),

                const SizedBox(height: 40),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Bienvenido 👋",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "¿Qué quieres hacer hoy?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // 🧩 TARJETAS
                tarjetaMenu(
                  texto: "Gestionar Productos",
                  icono: Icons.store,
                  color: Colors.orange,
                  accion: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const Productos(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 20),

                tarjetaMenu(
                  texto: "Gestionar Usuarios",
                  icono: Icons.person,
                  color: Colors.blue,
                  accion: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const Usuarios(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // 💎 TARJETA
  Widget tarjetaMenu({
    required String texto,
    required IconData icono,
    required Color color,
    required VoidCallback accion,
  }) {
    return InkWell(
      onTap: accion,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 6),
            )
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(icono,
                  color: color, size: 28),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Text(
                texto,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const Icon(Icons.arrow_forward_ios,
                size: 18)
          ],
        ),
      ),
    );
  }
}