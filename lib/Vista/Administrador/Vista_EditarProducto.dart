import 'package:app/Controlador/Productos.dart';
import 'package:app/Vista/Administrador/Vista_Almacen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class VistaEditarproducto extends StatefulWidget {
  final Productos producto;
  final Future<void> Function(Productos) updateProduct;
  final String usuarioId;
  final String username;

  const VistaEditarproducto({
    super.key,
    required this.producto,
    required this.updateProduct,
    required this.usuarioId,
    required this.username,
  });

  @override
  State<VistaEditarproducto> createState() => _VistaEditarproductoState();
}

class _VistaEditarproductoState extends State<VistaEditarproducto> {
  var idcontroller;
  var productonameController;
  var existenciaController;
  var precioController;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    idcontroller = TextEditingController(text: widget.producto.id.toString());
    productonameController =
        TextEditingController(text: widget.producto.productoname);
    existenciaController =
        TextEditingController(text: widget.producto.existencias.toString());
    precioController =
        TextEditingController(text: widget.producto.precio.toString());
  }

  Future<void> _updateProduct() async {
    if (formKey.currentState!.validate()) {
      try {
        await FirebaseFirestore.instance
            .collection('productos')
            .doc(widget.producto.id)
            .update({
          'id': idcontroller.text,
          'productoname': productonameController.text,
          'existencias': existenciaController.text,
          'precio': precioController.text
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Producto editado correctamente")),
        );
        Navigator.pop(context);
      } catch (e) {
        print("Error al editar producto: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Falla al editar producto")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(160, 133, 203, 144),
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
                          usuarioId: widget.usuarioId,
                          username: widget.username,
                        )),
              );
            },
          ),
          actions: [EditarProducto_(context)],
        ),
        body: Padding(
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
                              enabled: false,
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
                          Expanded(
                              child: IconButton(
                                  onPressed: () {},
                                  icon: Icon(
                                    Icons.barcode_reader,
                                    size: 35,
                                    color:
                                        const Color.fromARGB(255, 81, 81, 81),
                                  )))
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
                              controller: precioController,
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
                  )),
            )));
  }

  Widget EditarProducto_(BuildContext context) {
    return IconButton(
      onPressed: () async {
        if (formKey.currentState!.validate()) {
          final editProduct = Productos(
              id: widget.producto.id, 
              productoname: productonameController.text,
              precio: int.parse(precioController.text),
              existencias: int.parse(existenciaController.text));
          try {
            await widget.updateProduct(editProduct);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Producto editado correctamente")),
            );
            Navigator.pop(context);
          } catch (e) {
            print("Error al editar producto: $e");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Falla al editar producto")),
            );
          }
        }
      },
      icon: Icon(Icons.check, size: 35, color: Colors.green),
    );
  }
}
