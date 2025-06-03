import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ServiciosFirebasePersonal {
  static Future<void> deleteUser(
      String userId, VoidCallback onEmpleadosUpdate) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      await db.collection('users').doc(userId).delete();

      print("Usuario eliminado de Firestore.");
    } catch (e) {
      print("Error al eliminar el usuario: $e");
    } finally {
      onEmpleadosUpdate();
    }
  }

  static Future<String> getUsuarioId() async {
    String usuarioId = '';

    try {
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        usuarioId = user.uid;
      }
    } catch (e) {
      print("Error al obtener el usuario ID: $e");
    }

    return usuarioId;
  }

  static Future<String> getUsername(String userId) async {
    if (userId.isEmpty) return '';

    final userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();
    if (userDoc.exists) {
      return userDoc.data()?['username'] ?? '';
    }
    return '';
  }
}

class ServiciosFirebaseProductos {
  static Future<String> getProduct() async {
    User? producto = FirebaseAuth.instance.currentUser;
    String product = 'Producto';

    if (producto != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('productos')
            .doc(producto.uid)
            .get();

        if (userSnapshot.exists) {
          product = userSnapshot.get('product') ?? 'Producto';
        }
      } catch (e) {
        print("Error al obtener el producto: $e");
      }
    }
    return product;
  }

  static Future<void> deleteProduct(
      String productId, VoidCallback onProductosUpdate) async {
    try {
      FirebaseFirestore db = FirebaseFirestore.instance;

      // Eliminar el producto de Firestore
      await db.collection('productos').doc(productId).delete();

      print("Producto eliminado correctamente");
    } catch (e) {
      print("Error al eliminar el producto: $e");
    } finally {
      onProductosUpdate();
    }
  }
}

class serviciosPedidos {
  static Future<String> getPedido() async {
    User? pedido = FirebaseAuth.instance.currentUser;
    String pedidoo = 'Pedido';

    if (pedido != null) {
      try {
        DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('pedidos')
            .doc(pedido.uid)
            .get();

        if (userSnapshot.exists) {
          pedidoo = userSnapshot.get('pedido') ?? 'pedido';
        }
      } catch (e) {
        print("Error al obtener el pedido: $e");
      }
    }
    return pedidoo;
  }
}

class ServiciosfirebaseVentas {}
