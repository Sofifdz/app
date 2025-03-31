import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class vistaempleado extends StatefulWidget {
 
  const vistaempleado({Key? key, }) : super(key: key);

  @override
  State<vistaempleado> createState() => _vistaempleadoState();
}

class _vistaempleadoState extends State<vistaempleado> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(160, 133, 203, 144),
          leading: Builder(builder: (context) {
            return IconButton(
              icon: const Icon(
                Icons.menu,
                color: Colors.black,
                size: 35,
              ),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          }),
          title: Center(
            child: Text(
              "empleado",
              style: GoogleFonts.montserrat(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
        ),
        drawer: DrawerConfig.empleadoDrawer(context));
  }
  
}


