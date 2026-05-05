import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// 🔐 CERRAR SESIÓN
Future<void> logout() async {
  await FirebaseAuth.instance.signOut();
}

// 📝 REGISTRO
Future<String?> registrar(
  String correo,
  String password,
) async {
  try {
    UserCredential user =
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
      email: correo,
      password: password,
    );

    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user.user!.uid)
        .set({
      "correo": correo,
      "uid": user.user!.uid,
    });

    return null;
  } catch (e) {
    return e.toString();
  }
}

// 🔑 LOGIN
Future<String?> login(
  String correo,
  String password,
) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
      email: correo,
      password: password,
    );

    return null;
  } catch (e) {
    return e.toString();
  }
}