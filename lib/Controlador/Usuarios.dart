import 'package:cloud_firestore/cloud_firestore.dart';

class Usuarios {
  String id;
  String email;
  String username;
  String password;
  String role;

  Usuarios({
    required this.id,
    required this.email,
    required this.username,
    required this.password,
    required this.role,
  });

  // Método para convertir desde Firestore
  factory Usuarios.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return Usuarios(
      id: doc.id, // Se usa el ID del documento en Firestore
      email: data['email'] ?? '',
      username: data['username'] ?? '',
      password: data['password'] ?? '',
      role: data['role'] ?? 'Empleado',
    );
  }

  // Método para convertir a un mapa (para guardar en Firestore)
  Map<String, dynamic> toFirestore() {
    return {
      'email': email,
      'username': username,
      'password': password,
      'role': role,
    };
  }
}
