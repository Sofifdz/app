import 'package:app/Vista/Administrador/VentaporUsuario.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Vistaadmin extends StatefulWidget {
  final String usuarioId;
  final String username;

  const Vistaadmin({
    super.key,
    required this.usuarioId,
    required this.username,
  });

  @override
  State<Vistaadmin> createState() => _VistaadminState();
}

class _VistaadminState extends State<Vistaadmin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(160, 133, 203, 144),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Color.fromARGB(255, 81, 81, 81),
                size: 35,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          title: Center(
            child: Text(
              "Ventas",
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 81, 81, 81),
              ),
            ),
          ),
        ),
        drawer: DrawerConfig.administradorDrawer(
            context, widget.usuarioId, widget.username),
        body: cuerpo(
            context) 
        );
  }

  Widget cuerpo(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'Empleado')
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());

        final empleados = snapshot.data!.docs;

        if (empleados.isEmpty) {
          return Center(
            child: Text(
              'No hay empleados registrados',
              style: GoogleFonts.montserrat(fontSize: 20, color: Colors.red),
            ),
          );
        }

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: empleados.length,
            itemBuilder: (context, index) {
              final empleado = empleados[index];
              final empleadoId = empleado.id;
              final username = empleado['username'];

              return FutureBuilder<QuerySnapshot>(
                future: FirebaseFirestore.instance
                    .collection('ventas')
                    .where('usuarioId',
                        isEqualTo: empleadoId) // ✅ ID en lugar de username
                    .orderBy('fecha', descending: true)
                    .limit(1)
                    .get(),
                builder: (context, snapshotVenta) {
                  String total = "Cargando...";

                  if (snapshotVenta.hasData &&
                      snapshotVenta.data!.docs.isNotEmpty) {
                    final venta = snapshotVenta.data!.docs.first.data()
                        as Map<String, dynamic>;
                    total = venta['total'].toString();
                  } else if (snapshotVenta.connectionState ==
                      ConnectionState.done) {
                    total = "Sin ventas";
                  } else if (snapshotVenta.hasError) {
                    total = "Error";
                  }

                  return Card(
                    color: const Color.fromARGB(146, 225, 225, 225),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VentasPorUsuario(
                              userId:
                                  empleado.id, 
                              nombreUsuario: empleado['username'],
                            ),
                          ),
                        );
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 130,
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Ventas de ${empleado['username']}",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Total del último corte: $total",
                                    style: GoogleFonts.montserrat(
                                      fontSize: 20,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
