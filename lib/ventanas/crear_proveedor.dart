import 'package:flutter/material.dart';
import 'package:app/proveedor.dart';
import 'package:google_fonts/google_fonts.dart';

class CrearProveedor extends StatefulWidget {
  CrearProveedor({super.key});

  @override
  State<CrearProveedor> createState() => _CrearProveedorState();
}

class _CrearProveedorState extends State<CrearProveedor> {
//  final _myBox = Hive.openBox('myBox');

  final TextEditingController nombreController = TextEditingController();

  final TextEditingController numController = TextEditingController();

  final TextEditingController idproveedorController = TextEditingController();
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
              SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return 'Escribe el num';
                  }
                  return null;
                },
                controller: numController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Numero telefonico',
                    icon: Icon(
                      Icons.phone,
                      color: Colors.black,
                    )),
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return 'Escribe el id';
                  }
                  return null;
                },
                controller: idproveedorController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Id Proveedor',
                  icon: Icon(
                    Icons.code,
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
                      Proveedor(
                          nombre: nombreController.text,
                          numerotel: numController.text,
                          idproveedor: idproveedorController.text));
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
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
