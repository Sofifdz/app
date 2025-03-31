import 'package:app/Controlador/ServiciosFirebase.dart';
import 'package:app/Controlador/Usuarios.dart';
import 'package:app/Vista/Administrador/Vista_AgregarPersonal.dart';
import 'package:app/Vista/Administrador/Vista_EditarPersonal.dart';
import 'package:app/Vista/Componentes/Component_ShowDeteleDialog.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaPersonal extends StatefulWidget {
  const VistaPersonal({
    Key? key,
  }) : super(key: key);
  @override
  State<VistaPersonal> createState() => _VistaPersonalState();
}

class _VistaPersonalState extends State<VistaPersonal> {
  int expandedIndex = -1;

  List<Usuarios> empleadosList = [];

  bool isLoading = true;

  String username = "Cargando..."; 

  @override
  void initState() {
    super.initState();
    obtenerUsername(); 
  }
  void empleados() {
    setState(() {
      isLoading = true;
    });
    obtenerUsername(); 
  }

  void obtenerUsername() async {
    String nombre = await ServiciosFirebasePersonal.getUsername();
    setState(() {
      username = nombre;
    });
  }

  void expansion(int index) {
    setState(() {
      if (expandedIndex == index) {
        expandedIndex = -1;
      } else {
        expandedIndex = index;
      }
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
                      builder: (context) => Vista_AgregarPersonal()));
              /*Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Vista_AgregarPersonal(
                          insertUser: widget.insertUser,
                          deleteUser: deleteUser))).then((_) {
                empleados();
              });*/
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
      drawer: DrawerConfig.administradorDrawer(context),
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

        // Convierte los documentos en objetos Usuarios
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
                    onDelete: empleados,
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
                      expansion(index);
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
                        if (expandedIndex == index)
                          expansionn(context, usuario),
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

  Widget expansionn(BuildContext context, Usuarios usuario) {
    return Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(146, 194, 194, 194),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(vertical: 0.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.edit,
                    color: Color.fromARGB(255, 59, 59, 59), size: 20),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VistaEditarpersonal(
                        user: usuario,
                        updateUser: (Usuarios updatedUser) async {
                          // esto me actualiza el usuario en Firestore
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(updatedUser.id)
                              .update(updatedUser.toFirestore());
                        },
                      ),
                    ),
                  ).then((_) => empleados());
                },
              ),
              Text("Editar",
                  style: GoogleFonts.roboto(
                      color: Color.fromARGB(255, 59, 59, 59))),
            ],
          ),
          Column(
            children: [
              IconButton(
                icon: const Icon(Icons.delete,
                    color: Color.fromARGB(255, 59, 59, 59), size: 20),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        content: Text(
                          "¿Está seguro de eliminar a ${usuario.username}?",
                          style: GoogleFonts.montserrat(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: const Color.fromARGB(255, 81, 81, 81),
                          ),
                        ),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => Navigator.pop(context, 'Cancel'),
                            child: Text('Cancelar',
                                style: GoogleFonts.montserrat(fontSize: 15)),
                          ),
                          TextButton(
                            onPressed: () async {
                              await ServiciosFirebasePersonal.deleteUser(
                                  usuario.id, empleados);
                              Navigator.pop(context);
                            },
                            child: Text('Eliminar',
                                style: GoogleFonts.montserrat(fontSize: 15)),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              Text("Eliminar",
                  style: GoogleFonts.roboto(
                      color: Color.fromARGB(255, 59, 59, 59))),
            ],
          ),
        ],
      ),
    );
  }
}
