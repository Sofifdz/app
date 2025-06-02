import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowDialogCaja {
  static Future<void> show({
    required BuildContext context,
    required String usuarioId,
    required String username,
    required String abroOcierro,
    required String txtBoton,
    required String tipoOperacion,
  }) async {
    TextEditingController montoController = TextEditingController();

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          backgroundColor: const Color(0xFFD0E3ED),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.close,
                        size: 25,
                      ))
                ],
              ),
              Text(
                "Hola $username!",
                style: GoogleFonts.montserrat(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                abroOcierro,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: montoController,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  hintText: "\$0",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 116, 181, 119),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                  ),
                  onPressed: () async {
                    double monto = double.tryParse(montoController.text) ?? 0;
                    FirebaseFirestore db = FirebaseFirestore.instance;

                    if (tipoOperacion == "abrir") {
                      QuerySnapshot cajasAbiertas = await db
                          .collection('cajas')
                          .where('usuarioId', isEqualTo: usuarioId)
                          .where('estado', isEqualTo: 'abierta')
                          .limit(1)
                          .get();

                      if (cajasAbiertas.docs.isEmpty) {
                        await db.collection('cajas').add({
                          'usuarioId': usuarioId,
                          'fechaApertura': FieldValue.serverTimestamp(),
                          'inicioCaja': monto,
                          'cierreCaja': null,
                          'fechaCierre': null,
                          'estado': 'abierta',
                        });
                      } else {
                        print("Ya hay una caja abierta.");
                      }
                    } else if (tipoOperacion == "cerrar") {
                      QuerySnapshot cajasAbiertas = await db
                          .collection('cajas')
                          .where('usuarioId', isEqualTo: usuarioId)
                          .where('estado', isEqualTo: 'abierta')
                          .limit(1)
                          .get();

                      if (cajasAbiertas.docs.isNotEmpty) {
                        String cajaId = cajasAbiertas.docs.first.id;

                        await db.collection('cajas').doc(cajaId).update({
                          'cierreCaja': monto,
                          'fechaCierre': FieldValue.serverTimestamp(),
                          'estado': 'cerrada',
                        });
                      }
                    }

                    Navigator.pop(context);
                  },
                  child: Text(
                    txtBoton,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ],
          ),
        );
      },
    );
  }
}
