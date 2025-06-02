import 'dart:async';

import 'package:app/Controlador/ProductoCantidad.dart';
import 'package:app/Controlador/Productos.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
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

    // Obtener la caja abierta del usuario
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

    final cajaId = cajasAbiertasSnapshot.docs.first.id;

    // Obtener el número de ventas previas del usuario
    final userVentasSnapshot = await FirebaseFirestore.instance
        .collection('ventas')
        .where('usuarioId', isEqualTo: userId)
        .get();
    final IDventa = userVentasSnapshot.docs.length + 1;

    // Crear la venta
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
      'IDventa': IDventa, // Asociamos la venta con la caja actual
    };

    await FirebaseFirestore.instance.collection('ventas').add(venta);

    // Resto del código: actualizar existencias
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

  Future<void> buscarProducto(String codigoBarras) async {
    if (codigoBarras.isEmpty) return;

    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('productos')
        .doc(codigoBarras)
        .get();

    if (doc.exists) {
      Productos producto = Productos.fromFirestore(doc);

      int index =
          productosEscaneados.indexWhere((p) => p.producto.id == producto.id);
      setState(() {
        if (index == -1) {
          productosEscaneados.add(ProductoConCantidad(producto: producto));
        } else {
          productosEscaneados[index].cantidad++;
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  CardsPan("Pan 10", const Color.fromARGB(255, 173, 219, 175),
                      context),
                  CardsPan("Pan 9", const Color.fromARGB(255, 173, 199, 221),
                      context),
                  CardsPan("Pan 5", const Color.fromARGB(255, 173, 128, 128),
                      context),
                ],
              ),
            ),
            SizedBox(height: 20),
            campoCodigo(),
            SizedBox(height: 20),
            titleproductos(),
            SizedBox(height: 10),
            Expanded(child: productosList()),
            Divider(
              thickness: 2,
              color: Colors.black,
            ),
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
    );
  }

  Widget CardsPan(String title, Color color, BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth * 0.3;

    return Container(
      width: cardWidth,
      margin: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: color,
        border: Border.all(color: Colors.black, width: 1.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          height: 150,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold, fontSize: 25),
                ),
                Text(
                  '0',
                  style: GoogleFonts.roboto(fontSize: 25),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.remove,
                        color: Colors.red,
                        size: 35,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.add,
                        color: Colors.green,
                        size: 35,
                      ),
                    ),
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
