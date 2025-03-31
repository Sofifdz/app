import 'package:app/Controlador/ServiciosFirebase.dart';
import 'package:app/Controlador/Usuarios.dart';
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

                  Navigator.pop(context);
                },
                child: Text(
                  "Eliminar",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 81, 81, 81),
                  ),
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
