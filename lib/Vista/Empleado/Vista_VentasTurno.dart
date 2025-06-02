import 'package:app/Controlador/Ventas.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class VistaVentasturno extends StatefulWidget {
  final String usuarioId;
  final String username;

  const VistaVentasturno({super.key, required this.usuarioId,required this.username,});

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
                } else if (!snapshot.hasData || snapshot.data == null) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text('Caja: \$0',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 81, 81, 81),
                          )),
                    ),
                  );
                } else {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Text(
                          'Caja: \$${snapshot.data!['apertura']!.toDate()}',
                          style: GoogleFonts.montserrat(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 81, 81, 81),
                          )),
                    ),
                  );
                }
              },
            ),
          ),
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
        final IDcaja = fechasSnapshot.data!['IDcaja'];

        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('ventas')
              .where('cajaId', isEqualTo: IDcaja) // 👈 corregido
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

            return ListView.builder(
              itemCount: ventasList.length,
              itemBuilder: (context, index) {
                final venta = ventasList[index];
                final DateTime fechaParseada = DateTime.parse(venta.fecha);
                return SizedBox(
                  height: 100,
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
                    color: const Color.fromARGB(255, 211, 234, 250),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '#${venta.IDventa.toString()}',
                            style: GoogleFonts.montserrat(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '\$${venta.total.toStringAsFixed(2)}',
                            style: GoogleFonts.montserrat(
                                fontSize: 25,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                          Column(
                            children: [
                              Text(
                                DateFormat("dd/MM/yyyy", 'es_ES')
                                    .format(fechaParseada),
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                DateFormat("hh:mm a", 'es_ES')
                                    .format(fechaParseada),
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }
}
