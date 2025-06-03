import 'dart:async';

import 'package:app/Controlador/ProductoCantidad.dart';
import 'package:app/Controlador/Productos.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:app/Vista/Empleado/Cards_pan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaVentas extends StatefulWidget {
  final String usuarioId;
  final String username;
  const VistaVentas(
      {super.key, required this.usuarioId, required this.username});

  @override
  State<VistaVentas> createState() => _VistaVentasState();
}

class _VistaVentasState extends State<VistaVentas> {
  Map<String, int> cantidadesPan = {
    "Pan 10": 0,
    "Pan 9": 0,
    "Pan 5": 0,
  };

  TextEditingController codigoController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<ProductoConCantidad> productosEscaneados = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  double calcularTotal() {
    return productosEscaneados.fold(
      0,
      (total, pc) => total + (pc.producto.precio.toDouble() * pc.cantidad),
    );
  }

  Future<void> guardarVenta() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || productosEscaneados.isEmpty) return;

    final userId = user.uid;

   
    final cajasAbiertasSnapshot = await FirebaseFirestore.instance
        .collection('cajas')
        .where('usuarioId', isEqualTo: userId)
        .where('estado', isEqualTo: 'abierta')
        .limit(1)
        .get();

    if (cajasAbiertasSnapshot.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No hay caja abierta para registrar ventas.')));
      return;
    }

    final userVentasSnapshot = await FirebaseFirestore.instance
        .collection('ventas')
        .where('usuarioId', isEqualTo: userId)
        .get();
    final IDventa = userVentasSnapshot.docs.length + 1;

    
    final venta = {
      'usuarioId': userId,
      'ventaId': IDventa,
      'productos': productosEscaneados.map((pc) {
        final p = pc.producto.toFirestore();
        p['cantidad'] = pc.cantidad;
        return p;
      }).toList(),
      'total': calcularTotal(),
      'fecha': Timestamp.now(),
      'IDventa': IDventa,
    };

    await FirebaseFirestore.instance.collection('ventas').add(venta);

    final batch = FirebaseFirestore.instance.batch();
    for (var pc in productosEscaneados) {
      final docRef = FirebaseFirestore.instance
          .collection('productos')
          .doc(pc.producto.id);

      final doc = await docRef.get();
      if (doc.exists) {
        final currentStock =
            (doc.data() as Map<String, dynamic>)['existencias'] ?? 0;
        final newStock = currentStock - pc.cantidad;

        if (newStock < 0) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'No hay suficientes existencias de ${pc.producto.productoname}')));
          continue;
        }

        batch.update(docRef, {'existencias': newStock});
      }
    }

    await batch.commit();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Venta #$IDventa registrada con éxito')),
    );

    setState(() {
      productosEscaneados.clear();
    });
  }

  Future<void> buscarProducto(String input) async {
    if (input.isEmpty) return;

    // Regex para capturar código y cantidad: ej "12345*3"
    final regex = RegExp(r'^(.+?)(\*(\d+))?$');
    final match = regex.firstMatch(input);

    if (match == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Formato de código inválido')),
      );
      return;
    }

    String codigo = match.group(1)!; // código antes del '*'
    int cantidad = 1;

    if (match.group(3) != null) {
      cantidad = int.tryParse(match.group(3)!) ?? 1;
    }

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('productos')
        .doc(codigo)
        .get();

    if (doc.exists) {
      Productos producto = Productos.fromFirestore(doc);

      int index =
          productosEscaneados.indexWhere((p) => p.producto.id == producto.id);
      setState(() {
        if (index == -1) {
          productosEscaneados
              .add(ProductoConCantidad(producto: producto, cantidad: cantidad));
        } else {
          productosEscaneados[index].cantidad += cantidad;
        }
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Producto no encontrado')),
      );
    }

    codigoController.clear();
    FocusScope.of(context).requestFocus(focusNode);
  }

  Widget campoCodigo() {
    return TextField(
      controller: codigoController,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: "Escanear código de barras",
        border: OutlineInputBorder(),
      ),
      onSubmitted: buscarProducto,
    );
  }

  Widget productosList() {
    return Column(
      children: productosEscaneados.map((pc) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(pc.producto.productoname,
                style: GoogleFonts.roboto(fontSize: 15)),
            Text(
              "Precio: \$${pc.producto.precio}",
              style: GoogleFonts.roboto(fontSize: 15),
            ),
            Text("Cantidad: ${pc.cantidad}",
                style: GoogleFonts.roboto(fontSize: 15)),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: () {
                setState(() {
                  productosEscaneados.remove(pc);
                });
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 209, 219, 250),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu,
                color: Color.fromARGB(255, 81, 81, 81), size: 35),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        actions: [
          ElevatedButton(
            onPressed: () {
              guardarVenta();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 168, 209, 172),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              "Pagar",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
        title: Center(
          child: Text(
            "Nueva Venta",
            style: GoogleFonts.montserrat(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 81, 81, 81)),
          ),
        ),
      ),
      drawer: DrawerConfig.empleadoDrawer(
        context,
        widget.usuarioId,
        widget.username,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      CardsPan(
                        codigoController: codigoController,
                        onAgregar: (nombre, precio, cantidad) {
                          int index = productosEscaneados.indexWhere(
                              (p) => p.producto.productoname == nombre);
                          setState(() {
                            if (index == -1) {
                              productosEscaneados.add(ProductoConCantidad(
                                producto: Productos(
                                  id: 'id_generado',
                                  productoname: nombre,
                                  precio: precio.toInt(),
                                  existencias: 0,
                                ),
                                cantidad: cantidad,
                              ));
                            } else {
                              productosEscaneados[index].cantidad += cantidad;
                            }
                          });
                          codigoController.clear();
                          FocusScope.of(context).requestFocus(focusNode);
                        },
                        onEliminar: (nombre) {
                          setState(() {
                            int index = productosEscaneados.indexWhere(
                                (pc) => pc.producto.productoname == nombre);
                            if (index != -1) {
                              if (productosEscaneados[index].cantidad > 1) {
                                productosEscaneados[index].cantidad--;
                              } else {
                                productosEscaneados.removeAt(index);
                              }
                            }
                          });
                        },
                      ),

                    ],
                  ),
                ),
                const SizedBox(height: 20),
                campoCodigo(),
                const SizedBox(height: 20),
                titleproductos(),
                const SizedBox(height: 10),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: SingleChildScrollView(
                    child: productosList(),
                  ),
                ),
                const Divider(thickness: 2, color: Colors.black),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Total:",
                        style: GoogleFonts.montserrat(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                    Text("\$${calcularTotal().toStringAsFixed(2)}",
                        style: GoogleFonts.montserrat(
                            fontSize: 24, fontWeight: FontWeight.bold)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget titleproductos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Productos",
            style: GoogleFonts.montserrat(
                fontSize: 25, fontWeight: FontWeight.bold)),
      ],
    );
  }
}
