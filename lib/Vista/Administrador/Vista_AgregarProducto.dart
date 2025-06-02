import 'package:app/Controlador/Productos.dart';
import 'package:app/Controlador/ServiciosFirebase.dart';
import 'package:app/Vista/Administrador/Vista_Almacen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class VistaAgregarproducto extends StatefulWidget {
  const VistaAgregarproducto({super.key});

  @override
  State<VistaAgregarproducto> createState() => _VistaAgregarproductoState();
}

class _VistaAgregarproductoState extends State<VistaAgregarproducto> {
  String usuarioId = ''; // Variable para el usuario ID
  String username = ''; // Variable para el nombre de usuario
  final formKey = GlobalKey<FormState>();

  final idcontroller = TextEditingController();
  final productonameController = TextEditingController();
  final existenciaController = TextEditingController();
  final priceController = TextEditingController();
  void initState() {
    super.initState();
    obtenerUsername(); // Fetch username
    obtenerUsuarioId(); // Fetch usuarioId
  }

  void obtenerUsername() async {
    String nombre = await ServiciosFirebasePersonal.getUsername(usuarioId);

    setState(() {
      username = nombre;
    });
  }

  void obtenerUsuarioId() async {
    String id = await ServiciosFirebasePersonal
        .getUsuarioId(); // Asegúrate de que este método exista
    setState(() {
      usuarioId = id;
    });
  }

  Future<void> registrerProducto() async {
    try {
      await FirebaseFirestore.instance
          .collection('productos')
          .doc(idcontroller.text)
          .set({
        'id': idcontroller.text,
        'productoname': productonameController.text,
        'existencias': int.parse(existenciaController.text),
        'precio': int.parse(priceController.text),
      });

      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      print('Error al registrarse: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error: ${e.message}'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(160, 133, 203, 144),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: Color.fromARGB(255, 81, 81, 81),
            size: 35,
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VistaAlmacen(
                        username: username,
                        usuarioId: usuarioId,
                      )),
            );
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.save,
              color: Color.fromARGB(255, 81, 81, 81),
            ),
            onPressed: registrerProducto,
          ),
        ],
      ),
      body: body(context),
    );
  }

  Widget body(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 50.0, 20.0, 50.0),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: productonameController,
                decoration: InputDecoration(
                  labelText: "Nombre",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Nombre es requerido";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      controller: idcontroller,
                      decoration: InputDecoration(
                        labelText: "Codigo",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Codigo es requerido";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: existenciaController,
                      decoration: InputDecoration(
                        labelText: "Cantidad",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Cantidad es requerida";
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 25),
                  Expanded(
                    child: TextFormField(
                      controller: priceController,
                      decoration: InputDecoration(
                        labelText: "Precio",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Precio es requerido";
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
