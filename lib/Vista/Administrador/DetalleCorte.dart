import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class DetalleCorte extends StatelessWidget {
  final String cajaId;

  const DetalleCorte({super.key, required this.cajaId});

  @override
  Widget build(BuildContext context) {
    final format = DateFormat('dd/MM/yyyy hh:mm a');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(160, 133, 203, 144),
        title: Center(
          child: Text(
            'Ventas del corte',
            style: GoogleFonts.montserrat(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 81, 81, 81),
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color.fromARGB(255, 81, 81, 81),
            size: 35,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future:
            FirebaseFirestore.instance.collection('cajas').doc(cajaId).get(),
        builder: (context, snapshotCaja) {
          if (snapshotCaja.hasError) {
            return Center(child: Text('Error: ${snapshotCaja.error}'));
          }

          if (!snapshotCaja.hasData || !snapshotCaja.data!.exists) {
            return const Center(child: Text('Cargando...'));
          }

          final dataCaja = snapshotCaja.data!.data() as Map<String, dynamic>;

          final inicio = dataCaja['inicioCaja'] ?? 0;
          final cierre = dataCaja['cierreCaja'] ?? 0;
          final fechaApertura =
              (dataCaja['fechaApertura'] as Timestamp).toDate();
          final fechaCierre = (dataCaja['fechaCierre'] as Timestamp).toDate();

          return Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Caja: \$${inicio}",
                        style: GoogleFonts.montserrat(fontSize: 18)),
                    Text("Corte: \$${cierre}",
                        style: GoogleFonts.montserrat(fontSize: 18)),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('ventas')
                      .where('usuarioId', isEqualTo: dataCaja['usuarioId'])
                      .where('fecha', isGreaterThanOrEqualTo: fechaApertura)
                      .where('fecha', isLessThanOrEqualTo: fechaCierre)
                      .orderBy('fecha')
                      .snapshots(),
                  builder: (context, snapshotVentas) {
                    if (snapshotVentas.hasError) {
                      return Center(
                          child: Text('Error: ${snapshotVentas.error}'));
                    }

                    if (!snapshotVentas.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final ventas = snapshotVentas.data!.docs;
                    double total = ventas.fold(0.0, (suma, venta) {
                      final data = venta.data() as Map<String, dynamic>;
                      final monto = (data['total'] ?? 0).toDouble();
                      return suma + monto;
                    });

                    return Column(
                      children: [
                        Expanded(
                          child: ListView.builder(
                            itemCount: ventas.length,
                            itemBuilder: (context, index) {
                              final venta =
                                  ventas[index].data() as Map<String, dynamic>;
                              final monto = (venta['total'] ?? 0).toDouble();
                              final fecha =
                                  (venta['fecha'] as Timestamp).toDate();
                              total += monto;

                              return SizedBox(
                                height: 100,
                                child: Card(
                                  color:
                                      const Color.fromARGB(146, 225, 225, 225),
                                  margin: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text(
                                        venta['desdePedido'] == true &&
                                                venta['cliente'] != null
                                            ? 'Pedido de ${venta['cliente']}'
                                            : '#${index + 1}',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 20,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      Text(
                                        '\$${monto.toStringAsFixed(2)}',
                                        style: GoogleFonts.montserrat(
                                            fontSize: 24,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        format.format(fecha),
                                        style: GoogleFonts.montserrat(
                                            fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: const BoxDecoration(
                              border: Border(
                                  top: BorderSide(
                                      color: Colors.black, width: 1))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Total',
                                  style: GoogleFonts.montserrat(fontSize: 20)),
                              Text('\$${total.toStringAsFixed(2)}',
                                  style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
