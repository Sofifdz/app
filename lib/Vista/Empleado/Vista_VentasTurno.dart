import 'package:app/Controlador/Ventas.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:app/Vista/Empleado/Ventana_ticket.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VistaVentasturno extends StatefulWidget {
  final String usuarioId;
  final String username;

  const VistaVentasturno({
    super.key,
    required this.usuarioId,
    required this.username,
  });

  @override
  State<VistaVentasturno> createState() => _VistaVentasturnoState();
}

class _VistaVentasturnoState extends State<VistaVentasturno> {
  @override
  void initState() {
    super.initState();
    print("usuarioId recibido en VistaVentasturno: ${widget.usuarioId}");
  }

  Future<Map<String, dynamic>> obtenerCajaActual(String usuarioId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('cajas')
        .where('usuarioId', isEqualTo: usuarioId)
        .where('estado', isEqualTo: 'abierta')
        .orderBy('fechaApertura', descending: true)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      final apertura = data['fechaApertura'] as Timestamp;
      final cierre = data['fechaCierre'] as Timestamp?;
      final cajaId = snapshot.docs.first.id;

      return {
        'fechaApertura': apertura,
        if (cierre != null) 'fechaCierre': cierre,
        'cajaId': cajaId,
        'inicioCaja': data['inicioCaja'] ?? 0,
      };
    }

    return {};
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
          Padding(
              padding: const EdgeInsets.only(right: 15),
              child: FutureBuilder<Map<String, dynamic>>(
                future: obtenerCajaActual(widget.usuarioId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2));
                  } else {
                    final inicioCaja = snapshot.data?['inicioCaja'];
                    final monto =
                        (inicioCaja is num) ? inicioCaja.toDouble() : 0.0;

                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Text(
                          'Caja: \$${monto.toStringAsFixed(2)}',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 81, 81, 81),
                          ),
                        ),
                      ),
                    );
                  }
                },
              )),
        ],
        title: Center(
          child: Text(
            "Ventas",
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
    return FutureBuilder<Map<String, dynamic>>(
      future: obtenerCajaActual(widget.usuarioId),
      builder: (context, fechasSnapshot) {
        if (fechasSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!fechasSnapshot.hasData || fechasSnapshot.data!.isEmpty) {
          return Center(
            child: Text(
              "No hay caja activa o no se encontraron fechas.",
              style: GoogleFonts.montserrat(fontSize: 20, color: Colors.red),
            ),
          );
        }
        final IDcaja = fechasSnapshot.data!['cajaId'];

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ventas')
              .where('IDcaja', isEqualTo: IDcaja)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(
                child: Text(
                  "No hay ventas registradas en este turno.",
                  style:
                      GoogleFonts.montserrat(fontSize: 20, color: Colors.red),
                ),
              );
            }

            final ventasList = snapshot.data!.docs
                .map((doc) => Ventas.fromFirestore(doc))
                .toList();

            double totalVentas = 0;
            for (var venta in ventasList) {
              totalVentas += venta.total;
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: ventasList.length,
                    itemBuilder: (context, index) {
                      final venta = ventasList[index];
                      final DateTime fechaParseada =
                          DateTime.parse(venta.fecha);
                      String ff = DateFormat('dd/MM/yyyy\nhh:mm a')
                          .format(fechaParseada);

                      return Card(
                        margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                        color: Colors.grey[200],
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => VentanaTicket(
                                          venta: venta,
                                        )));
                          },
                          child: SizedBox(
                              height: 100,
                              child: Center(
                                  child: venta.desdePedido == true
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Pedido ${venta.cliente}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 23),
                                            ),
                                            Text(
                                              '\$${venta.total.toStringAsFixed(2)}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 23),
                                            ),
                                            Text(
                                              ff,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 15),
                                            ),
                                          ],
                                        )
                                      : Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              '#${venta.IDventa.toString()}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 23),
                                            ),
                                            Text(
                                              '\$${venta.total.toStringAsFixed(2)}',
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 23),
                                            ),
                                            Text(
                                              ff,
                                              style: GoogleFonts.montserrat(
                                                  fontSize: 15),
                                            ),
                                          ],
                                        )

                                  )),
                        ),
                      );
                    },
                  ),
                ),
                const Divider(thickness: 1),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total",
                        style: GoogleFonts.montserrat(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "\$${totalVentas.toStringAsFixed(2)}",
                        style: GoogleFonts.montserrat(
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
