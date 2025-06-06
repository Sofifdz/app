import 'package:app/Vista/Componentes/Component_date.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VentasPorUsuario extends StatefulWidget {
  final String userId;
  final String nombreUsuario;

  const VentasPorUsuario({
    required this.userId,
    required this.nombreUsuario,
    super.key,
  });

  @override
  State<VentasPorUsuario> createState() => _VentasPorUsuarioState();
}

class _VentasPorUsuarioState extends State<VentasPorUsuario> {
  DateTime? fechaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(160, 133, 203, 144),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Color.fromARGB(255, 81, 81, 81),
              size: 35,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          );
        }),
        title: Center(
          child: Text(
            'Ventas de ${widget.nombreUsuario}',
            style: GoogleFonts.montserrat(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 81, 81, 81),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.calendar_month,
              color: Color.fromARGB(255, 81, 81, 81),
              size: 30,
            ),
            onPressed: () async {
              final fecha = await Component_date.show(
                context: context,
                initialDate: fechaSeleccionada,
              );

              setState(() {
                fechaSeleccionada = fecha;
              });
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('ventas')
            .where('usuarioId', isEqualTo: widget.userId)
            .orderBy('fecha', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final ventas = snapshot.data!.docs;

          // Filtrar por fecha si se seleccionó una
          final ventasFiltradas = ventas.where((venta) {
            if (fechaSeleccionada == null) return true;
            if (venta['fecha'] is! Timestamp) return false;

            final fecha = (venta['fecha'] as Timestamp).toDate();
            return fecha.year == fechaSeleccionada!.year &&
                fecha.month == fechaSeleccionada!.month &&
                fecha.day == fechaSeleccionada!.day;
          }).toList();

          if (ventasFiltradas.isEmpty) {
            return Center(
              child: Text(
                'No hay ventas registradas para esta fecha.',
                style: GoogleFonts.montserrat(fontSize: 20, color: Colors.red),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
                itemCount: ventasFiltradas.length,
                itemBuilder: (context, index) {
                  final venta = ventasFiltradas[index];
                  final data = venta.data() as Map<String, dynamic>;

                  String fechaFormateada = '';
                  if (data['fecha'] is Timestamp) {
                    final fecha = (data['fecha'] as Timestamp).toDate();
                    fechaFormateada =
                        DateFormat('dd/MM/yyyy\nhh:mm a').format(fecha);
                  }

                  final bool esDesdePedido = data.containsKey('desdePedido') &&
                      data['desdePedido'] == true;

                  return Card(
                    color: const Color.fromARGB(146, 225, 225, 225),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: SizedBox(
                      height: 80,
                      child: Center(
                          child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              esDesdePedido
                                  ? 'Pedido ${data['pedidoId']}'
                                  : '#${data['IDventa']}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 20,
                                color: const Color.fromARGB(255, 34, 34, 34),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              '\$${data['total']}',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 23,
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              fechaFormateada,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.montserrat(
                                fontSize: 15,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      )),
                    ),
                  );
                }),
          );
        },
      ),
    );
  }
}
