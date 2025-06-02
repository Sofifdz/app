import 'package:app/Controlador/ServiciosFirebase.dart';
import 'package:app/Controlador/Usuarios.dart';
import 'package:app/Controlador/Pedidos.dart'; // Agregamos la importación de Pedidos
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DeleteDialog {
  static Future<bool?> showDeleteDialog<T>({
    required BuildContext context,
    required T item,
    required String itemName,
    required Function onDelete,
  }) async {
    // Verifica si el item es un usuario
    if (item is Usuarios) {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "¿Estás seguro de que deseas eliminar a ${item.username}?",
              style: GoogleFonts.montserrat(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 81, 81, 81),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 81, 81, 81),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await ServiciosFirebasePersonal.deleteUser(item.id, () => onDelete());
                  Navigator.pop(context, true);
                },
                child: Text(
                  "Eliminar",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: Colors.red,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }

    // Verifica si el item es un pedido
    if (item is Pedidos) {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(

            content: Text(
              "¿Estás seguro de que deseas eliminar el pedido de ${item.cliente}?",
              style: GoogleFonts.montserrat(fontSize: 17),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  "Cancelar",
                  style: GoogleFonts.montserrat(fontSize: 15, color: Colors.grey),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await FirebaseFirestore.instance
                      .collection('pedidos')
                      .doc(item.NoPedido)
                      .delete()
                      .then((_) => onDelete());

                  Navigator.pop(context, true);
                },
                child: Text(
                  "Eliminar",
                  style: GoogleFonts.montserrat(fontSize: 15, color: Colors.red),
                ),
              ),
            ],
          );
        },
      );
    }

    return null;
  }
}
