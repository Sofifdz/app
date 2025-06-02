import 'package:app/Controlador/Usuarios.dart';
import 'package:app/Vista/Administrador/Vista_AgregarPersonal.dart';
import 'package:app/Vista/Administrador/Vista_EditarPersonal.dart';
import 'package:app/Vista/Componentes/Component_ShowDeteleDialog.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaPersonal extends StatefulWidget {
  final String usuarioId;
  final String username;
  const VistaPersonal({
    Key? key,
    required this.usuarioId,
    required this.username,
  });

  @override
  State<VistaPersonal> createState() => _VistaPersonalState();
}

class _VistaPersonalState extends State<VistaPersonal> {
  @override
  void initState() {
    super.initState();
  }

  void actualizarEmpleados() {
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(160, 133, 203, 144),
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
        actions: [
          IconButton(
            icon: Icon(
              Icons.person_add_alt_1_rounded,
              color: Color.fromARGB(255, 81, 81, 81),
              size: 35,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Vista_AgregarPersonal(
                            usuarioId: widget.usuarioId,
                            username: widget.username,
                          )));
            },
          )
        ],
        title: Center(
          child: Text(
            "Personal",
            style: GoogleFonts.montserrat(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: const Color.fromARGB(255, 81, 81, 81),
            ),
          ),
        ),
      ),
      drawer: DrawerConfig.administradorDrawer(
          context, widget.usuarioId, widget.username),
      body: cuerpo(context),
    );
  }

  Widget cuerpo(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('users').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No hay empleados registrados",
              style: GoogleFonts.montserrat(fontSize: 20, color: Colors.red),
            ),
          );
        }

        final empleadosList = snapshot.data!.docs
            .map((doc) => Usuarios.fromFirestore(doc))
            .toList();

        return Padding(
          padding: const EdgeInsets.all(10.0),
          child: ListView.builder(
            itemCount: empleadosList.length,
            itemBuilder: (context, index) {
              final usuario = empleadosList[index];

              return Dismissible(
                key: Key(usuario.id),
                direction: DismissDirection.endToStart,
                confirmDismiss: (direction) async {
                  return await DeleteDialog.showDeleteDialog(
                    item: usuario,
                    context: context,
                    itemName: usuario.username,
                    onDelete: actualizarEmpleados,
                  );
                },
                background: Container(
                  color: Colors.red,
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                child: Card(
                  color: const Color.fromARGB(146, 225, 225, 225),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VistaEditarpersonal(
                            usuarioId: widget.usuarioId,
                            username: widget.username,
                            user: usuario,
                            updateUser: (Usuarios updatedUser) async {
                              // Esto me actualiza el usuario en Firestore
                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(updatedUser.id)
                                  .update(updatedUser.toFirestore());
                            },
                          ),
                        ),
                      ).then((_) => actualizarEmpleados());
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 100,
                          child: Center(
                            child: ListTile(
                              leading: const Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.black,
                              ),
                              title: Text(
                                "Nombre",
                                style: GoogleFonts.montserrat(
                                  fontSize: 15,
                                  color: Colors.black,
                                ),
                              ),
                              subtitle: Text(
                                usuario.username,
                                style: GoogleFonts.montserrat(
                                  fontSize: 20,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
