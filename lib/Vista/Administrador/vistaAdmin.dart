import 'package:app/Vista/Componentes/DrawerConfig.dart';
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
            context, widget.usuarioId, widget.username));
  }
}
