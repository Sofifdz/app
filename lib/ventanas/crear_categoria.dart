import 'package:flutter/material.dart';
import 'package:app/categoria.dart';
import 'package:google_fonts/google_fonts.dart';

class Crearcategoria extends StatefulWidget {
  Crearcategoria({super.key});

  @override
  State<Crearcategoria> createState() => _CrearCategoriaState();
}

class _CrearCategoriaState extends State<Crearcategoria> {
  final TextEditingController nombreController = TextEditingController();

  final TextEditingController idCategoriaController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _error = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.teal[400],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  icon: Icon(
                    Icons.drive_file_rename_outline,
                    color: Colors.black,
                  ),
                  errorText: _error ? 'tu texto esta mal' : null,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.contains('null'))
                      _error = true;
                    else
                      _error = false;
                  });
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return 'Escribe el precio de compra';
                  }
                  return null;
                },
                controller: idCategoriaController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'id Categoria',
                  icon: Icon(
                    Icons.category,
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      Categoria(
                        nombre: nombreController.text,
                        idCategoria: idCategoriaController.text,
                      ));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text('Guardar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
