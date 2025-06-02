import 'package:app/Controlador/Pedidos.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:app/Vista/Empleado/Vista_AgregarPedido.dart';
import 'package:app/Vista/Empleado/Vista_DetallePedidoEmpleado.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaPedidosEmpleado extends StatefulWidget {
  final String usuarioId;
  final String username;
  const VistaPedidosEmpleado({
    super.key,
    required this.usuarioId,
    required this.username,
  });

  @override
  State<VistaPedidosEmpleado> createState() => _VistaPedidosEmpleadoState();
}

class _VistaPedidosEmpleadoState extends State<VistaPedidosEmpleado> {
  List<Pedidos> pedidosList = [];
  bool isLoading = true;

  void pedidos() {
    setState(() {});
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
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_outlined,
              color: Color.fromARGB(255, 81, 81, 81),
              size: 35,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VistaAgregarpedido(
                            usuarioId: widget.usuarioId,
                            username: widget.username,
                          )));
            },
          )
        ],
        title: Center(
          child: Text(
            "Pedidos",
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
      body: cuerpo(context),
    );
  }

  Widget cuerpo(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pedidos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No hay pedidos registrados",
                style: GoogleFonts.montserrat(fontSize: 20, color: Colors.red),
              ),
            );
          }

          /*final pedidosList = snapshot.data!.docs
              .map((doc) => Pedidos.fromFirestore(doc))
              .toList();*/

          final pedidosList = snapshot.data!.docs
              .map((doc) => Pedidos.fromFirestore(doc))
              .where((pedido) => !pedido.isEntregado)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pendientes",
                  style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: ListView.builder(
                        itemCount: pedidosList.length,
                        itemBuilder: (context, index) {
                          if (index >= pedidosList.length) return SizedBox();

                          final pedido = pedidosList[index];

                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          VistaDetallespedidoEmpleado(
                                            pedidoId: pedido.NoPedido,
                                            usuarioId: widget.usuarioId,
                                            username: widget.username,
                                          )));
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 100,
                                  padding: const EdgeInsets.all(16.0),
                                  decoration: BoxDecoration(
                                    color: _obtenerColor(pedido.isEntregado),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        pedido.cliente,
                                        style: GoogleFonts.montserrat(
                                            fontSize: 25,
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Fecha de entrega:",
                                            style: GoogleFonts.montserrat(
                                              fontSize: 18,
                                              color: Colors.black,
                                            ),
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
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          );
                        })),
              ],
            ),
          );
        });
  }

  Color _obtenerColor(bool isEntregado) {
    if (!isEntregado) {
      return const Color.fromARGB(255, 217, 217, 218);
    }
    return Color.fromARGB(146, 148, 184, 152);
  }
}
