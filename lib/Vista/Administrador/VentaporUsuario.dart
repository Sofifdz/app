
import 'package:app/Vista/Administrador/DetalleCorte.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(160, 133, 203, 144),
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
        title: Center(
          child: Text(
            'Cortes de ${widget.nombreUsuario}',
            style: GoogleFonts.montserrat(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 81, 81, 81),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('cajas')
            .where('usuarioId', isEqualTo: widget.userId)
            .where('estado', isEqualTo: 'cerrada')
            .orderBy('fechaCierre', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final cajas = snapshot.data!.docs;
          print('Cajas encontradas: ${cajas.length}');

          print('userId: ${widget.userId}');

          if (cajas.isEmpty) {
            return Center(
              child: Text(
                'No hay cajas para este usuario',
                style: GoogleFonts.montserrat(fontSize: 20, color: Colors.red),
              ),
            );
          }

          return ListView.builder(
            itemCount: cajas.length,
            itemBuilder: (context, index) {
              final data = cajas[index].data() as Map<String, dynamic>;

              final fechaApertura = data['fechaApertura'] != null
                  ? (data['fechaApertura'] as Timestamp).toDate()
                  : null;

              final fechaCierre = data['fechaCierre'] != null
                  ? (data['fechaCierre'] as Timestamp).toDate()
                  : null;

              final inicio = data['inicioCaja'] ?? 0;
              final cierre = data['cierreCaja'] ?? 0;

              final format = DateFormat('dd/MM/yyyy hh:mm a');

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetalleCorte(cajaId: cajas[index].id),
                    ),
                  );
                },
                child: SizedBox(
                  height: 100,
                  child: Card(
                    color: const Color.fromARGB(146, 225, 225, 225),
                    margin: const EdgeInsets.all(10.0),
                    child: ListTile(
                      title: Center(
                        child: Text(
                          fechaCierre != null
                              ? "Cierre: ${format.format(fechaCierre)}"
                              : "Sin fecha de cierre",
                          style: GoogleFonts.montserrat(
                              fontWeight: FontWeight.w500, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
