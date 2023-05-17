import 'package:app/categoria.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Editar_categoria extends StatefulWidget {
  Editar_categoria({super.key});

  @override
  State<Editar_categoria> createState() => Editar_categoriaState();
}

class Editar_categoriaState extends State<Editar_categoria> {
  final TextEditingController idController = TextEditingController();

  final TextEditingController nombreController = TextEditingController();

  String? selectedValue;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Editar Categoria",
          style: GoogleFonts.ptSerif(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[400],
        toolbarHeight: 70,
      ),
      body: Form(
        child: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe el id Categoria';
                }
                return null;
              },
              controller: idController,
              decoration: InputDecoration(
                hintText: 'Escribe el id Categoria',
                labelText: "Id Categoria",
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
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      Categoria(
                        nombre: nombreController.text,
                        idCategoria: idController.text,
                      ));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Categoria Actualizada'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
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
