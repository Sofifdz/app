import 'package:app/Controlador/Productos.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class vistaempleado extends StatefulWidget {
  const vistaempleado({Key? key}) : super(key: key);

  @override
  State<vistaempleado> createState() => _vistaempleadoState();
}

class _vistaempleadoState extends State<vistaempleado> {
  TextEditingController codigoController = TextEditingController();
  FocusNode focusNode = FocusNode();
  List<Productos> productosEscaneados = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(focusNode);
    });
  }

  double calcularTotal() {
    return productosEscaneados.fold(
        0, (total, prod) => total + prod.precio.toDouble());
  }

  Future<void> guardarVenta() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || productosEscaneados.isEmpty) return;

    final venta = {
      'usuarioId': user.email ?? user.uid,
      'productos': productosEscaneados.map((p) => p.toFirestore()).toList(),
      'total': calcularTotal(),
      'fecha': Timestamp.now(),
    };

    await FirebaseFirestore.instance.collection('ventas').add(venta);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Venta registrada con éxito')),
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

      int index = productosEscaneados.indexWhere((p) => p.id == producto.id);
      if (index == -1) {
        setState(() {
          productosEscaneados.add(producto);
        });
      }
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
        labelText: "Escanear código de barras",
        border: OutlineInputBorder(),
      ),
      onSubmitted: buscarProducto,
    );
  }

  Widget productosList() {
    return Column(
      children: productosEscaneados.map((producto) {
        return ListTile(
          title: Text("${producto.productoname}"),
          subtitle: Text("Precio: \$${producto.precio}"),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () {
              setState(() {
                productosEscaneados.remove(producto);
              });
            },
          ),
        );
      }).toList(),
    );
  }

  Widget titleproductos() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text("Productos",
            style: GoogleFonts.montserrat(
                fontSize: 25, fontWeight: FontWeight.bold)),
        Icon(Icons.qr_code_scanner),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Venta", style: GoogleFonts.montserrat()),
        backgroundColor: const Color.fromARGB(255, 209, 219, 250),
        actions: [
          ElevatedButton(
            onPressed: guardarVenta,
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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            campoCodigo(),
            SizedBox(height: 20),
            titleproductos(),
            SizedBox(height: 10),
            Expanded(child: productosList()),
            Divider(thickness: 2),
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
}
