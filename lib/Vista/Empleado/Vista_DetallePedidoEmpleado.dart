import 'package:app/Controlador/Pedidos.dart';
import 'package:app/Vista/Administrador/Vista_Pedidos.dart';
import 'package:app/Vista/Empleado/Vista_PedidosEmpleado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaDetallespedidoEmpleado extends StatefulWidget {
  final String pedidoId;
  final String usuarioId;
  final String username;
  const VistaDetallespedidoEmpleado({
    super.key,
    required this.pedidoId,
    required this.usuarioId,
    required this.username,
  });

  @override
  State<VistaDetallespedidoEmpleado> createState() =>
      _VistaDetallespedidoEmpleadoState();
}

class _VistaDetallespedidoEmpleadoState
    extends State<VistaDetallespedidoEmpleado> {
  List<Pedidos> pedidosList = [];
  void pedidos() {
    setState(() {});
  }

  void entregarPedido() async {
    final pedidoDoc = await FirebaseFirestore.instance
        .collection('pedidos')
        .doc(widget.pedidoId)
        .get();

    final pedidoData = pedidoDoc.data() as Map<String, dynamic>;

    // 1. Obtener caja abierta del usuario
    final cajaAbierta = await FirebaseFirestore.instance
        .collection('cajas')
        .where('estado', isEqualTo: 'abierta')
        .limit(1)
        .get();

    if (cajaAbierta.docs.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No hay una caja abierta")),
      );
      return;
    }

    final cajaData = cajaAbierta.docs.first.data();
    final usuarioId = cajaData['usuarioId'];
    final IDcaja = cajaAbierta.docs.first.id;

    // 2. Crear lista de productos desde el pedido
    final productos = [
      {
        'nombre': pedidoData['descripcion'],
        'cantidad': 1,
        'precio': pedidoData['precio'],
      }
    ];

    // 3. Registrar la venta
    await FirebaseFirestore.instance.collection('ventas').add({
      'usuarioId': usuarioId,
      'ventaId': DateTime.now().millisecondsSinceEpoch,
      'productos': productos,
      'total': pedidoData['precio'],
      'fecha': Timestamp.now(),
      'IDcaja': IDcaja,
      'desdePedido': true,
      'pedidoId': widget.pedidoId,
      'cliente': pedidoData['cliente'], 
      'descripcion':pedidoData['descripcion']
    });

    // 4. Marcar el pedido como entregado
    await FirebaseFirestore.instance
        .collection('pedidos')
        .doc(widget.pedidoId)
        .update({'isEntregado': true});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Pedido entregado y venta registrada")),
    );

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 209, 219, 250),
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
                  builder: (context) => VistaPedidosEmpleado(
                        usuarioId: widget.usuarioId,
                        username: widget.username,
                      )),
            );
          },
        ),
        title: Center(
          child: Text(
            "Detalles",
            style: GoogleFonts.montserrat(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 81, 81, 81)),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor:
                  MaterialStateProperty.all(Color.fromARGB(255, 168, 209, 172)),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            onPressed: () {
              entregarPedido();
            },
            child: Text(
              'Entregar',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: cuerpo(context),
    );
  }

  Widget cuerpo(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('pedidos')
          .doc(widget.pedidoId)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("Pedido no encontrado"));
        }

        final pedido = Pedidos.fromFirestore(snapshot.data!);

        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pedido.cliente,
                        style: GoogleFonts.montserrat(
                            fontSize: 25,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Fecha de entrega: ",
                            style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            pedido.fecha,
                            style: GoogleFonts.montserrat(
                                fontSize: 18,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        width: double.infinity,
                        height: 200,
                        child: Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Colors.grey[200],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: SingleChildScrollView(
                            child: Text(
                              pedido.descripcion,
                              style: GoogleFonts.montserrat(
                                  fontSize: 18,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Divider(thickness: 2, color: Colors.black),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total",
                      style: GoogleFonts.montserrat(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "\$${pedido.precio}",
                      style: GoogleFonts.montserrat(
                          fontSize: 22,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
