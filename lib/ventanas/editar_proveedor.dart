import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:app/producto.dart';
import 'package:hive_flutter/adapters.dart';

import '../proveedor.dart';

class Editar_proveedor extends StatefulWidget {
  Editar_proveedor({super.key});

  @override
  State<Editar_proveedor> createState() => _EditarproveedorState();
}

class _EditarproveedorState extends State<Editar_proveedor> {
  final TextEditingController idController = TextEditingController();

  final TextEditingController nombreController = TextEditingController();

  final TextEditingController numController = TextEditingController();

  String? selectedValue;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Editar proveedor",
          style: GoogleFonts.ptSerif(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[400],
      ),
      body: Form(
        child: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe el id proveedor';
                }
                return null;
              },
              controller: idController,
              decoration: InputDecoration(
                hintText: 'Escribe el id proveedor',
                labelText: "Id Proveedor",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe el nombre';
                }
                return null;
              },
              controller: nombreController,
              decoration: InputDecoration(
                hintText: 'Escribe el nombre',
                labelText: "Nombre",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe el numero de telefono';
                }
                return null;
              },
              controller: numController,
              decoration: InputDecoration(
                hintText: 'Escribe el numero de telefono',
                labelText: "Numero telefonico",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      Proveedor(
                        nombre: nombreController.text,
                        idproveedor: idController.text,
                        numerotel: numController.text,
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Proveedor Actualizado'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                ),
                child: const Text('Guardar'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
