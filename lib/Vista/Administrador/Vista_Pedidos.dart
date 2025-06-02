import 'package:app/Controlador/Pedidos.dart';
import 'package:app/Controlador/ServiciosFirebase.dart';
import 'package:app/Vista/Administrador/Vista_AgregarPedidoA.dart';
import 'package:app/Vista/Administrador/Vista_DetallesPedido.dart';
import 'package:app/Vista/Componentes/Component_ShowDeteleDialog.dart';
import 'package:app/Vista/Componentes/Component_date.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaPedidos extends StatefulWidget {
  final String usuarioId;
  final String username;

  const VistaPedidos({super.key, required this.usuarioId, required this.username});

  @override
  State<VistaPedidos> createState() => _VistaPedidosState();
}

class _VistaPedidosState extends State<VistaPedidos> {
  String usuarioId = ''; 
  String username = 'Cargando...'; 
  List<Pedidos> pedidosList = [];
  bool isLoading = true;
  bool entregados = false;

  DateTime? fechaSeleccionada;

  void pedidos() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    inicializarDatos();
  }

  void inicializarDatos() async {
  String id = await ServiciosFirebasePersonal.getUsuarioId();
  
  String nombre = await ServiciosFirebasePersonal.getUsername(id);


  setState(() {
    usuarioId = id;
    username = nombre;
  });
}


  void obtenerUsername() async {
    String nombre = await ServiciosFirebasePersonal.getUsername(usuarioId);
    setState(() {
      username = nombre;
    });
  }

  void obtenerUsuarioId() async {
    String id = await ServiciosFirebasePersonal
        .getUsuarioId(); // Asegúrate de que este método exista
    setState(() {
      usuarioId = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(160, 133, 203, 144),
        leading: Builder(builder: (context) {
          return IconButton(
            icon: const Icon(Icons.menu,
                color: Color.fromARGB(255, 81, 81, 81), size: 35),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          );
        }),
        title: Center(
          child: Text(
            "Pedidos",
            style: GoogleFonts.montserrat(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 81, 81, 81)),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline_outlined,
              color: Color.fromARGB(255, 81, 81, 81),
              size: 35,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Vista_AgregarPedidoA(
                        username: username,
                        usuarioId: usuarioId,
                      )));
            },
          )
        ],
      ),
      drawer: username == 'Cargando...'
          ? const Drawer(child: Center(child: CircularProgressIndicator()))
          : DrawerConfig.administradorDrawer(context, usuarioId, username),
      body: cuerpo(context),
    );
  }

  Widget cuerpo(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('pedidos').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                "No hay pedidos registrados",
                style: GoogleFonts.montserrat(fontSize: 20, color: Colors.red),
              ),
            );
          }

          final pedidosList = snapshot.data!.docs
              .map((doc) => Pedidos.fromFirestore(doc))
              .toList();

          /*final pedidosFiltrados = pedidosList
              .where((pedido) => pedido.isEntregado || !entregados)
              .toList();*/

          final pedidosFiltrados = pedidosList.where((pedido) {
            final isFechaOk = () {
              if (fechaSeleccionada == null) return true;
              try {
                final partes = pedido.fecha.split(' ');
                final fecha = partes[0]; // "01/04/2025"
                final partesFecha = fecha.split('/');

                final day = int.parse(partesFecha[0]);
                final month = int.parse(partesFecha[1]);
                final year = int.parse(partesFecha[2]);

                final pedidoDate = DateTime(year, month, day);

                return pedidoDate.year == fechaSeleccionada!.year &&
                    pedidoDate.month == fechaSeleccionada!.month &&
                    pedidoDate.day == fechaSeleccionada!.day;
              } catch (e) {
                print("Error de fecha: ${pedido.fecha}");
                return false;
              }
            };

            if (entregados) {
              return pedido.isEntregado && isFechaOk();
            } else {
              return isFechaOk();
            }
          }).toList();
          pedidosFiltrados.sort((a, b) {
            if (!a.isEntregado && b.isEntregado) {
              return -1; // a va primero
            } else if (a.isEntregado && !b.isEntregado) {
              return 1; // b va primero
            } else if (a.isEntregado && b.isEntregado) {
              return b.fecha.compareTo(a.fecha); // orden por fecha
            }
            return 0;
          });

          return Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      entregados ? "Entregados" : "Todos", //cambia el texto
                      style: GoogleFonts.montserrat(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    Spacer(),
                    Switch(
                      activeColor: Colors.green,
                      value: entregados,
                      onChanged: (bool value) {
                        setState(() {
                          entregados = value;
                        });
                      },
                    ),
                    IconButton(
                      onPressed: () async {
                        final picked = await Component_date.show(
                          context: context,
                          initialDate: fechaSeleccionada,
                        );

                        setState(() {
                          fechaSeleccionada = picked;
                        });
                      },
                      icon: Icon(Icons.calendar_month, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Expanded(
                    child: ListView.builder(
                        itemCount: pedidosFiltrados.length,
                        itemBuilder: (context, index) {
                          if (index >= pedidosFiltrados.length)
                            return SizedBox();
                          final pedido = pedidosFiltrados[index];
                          //final pedido = pedidosList[index];

                          return Dismissible(
                              key: Key(pedido.NoPedido),
                              direction: DismissDirection.endToStart,
                              confirmDismiss: (direction) async {
                                return await DeleteDialog.showDeleteDialog(
                                    item: pedido,
                                    context: context,
                                    itemName: pedido.cliente,
                                    onDelete: pedidos);
                              },
                              background: Container(
                                color: Colors.red,
                                alignment: Alignment.centerRight,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              VistaDetallespedido(
                                                  pedidoId: pedido.NoPedido,
                                                  username: username,
                                                  usuarioId: usuarioId,)));
                                },
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 100,
                                      padding: const EdgeInsets.all(16.0),
                                      decoration: BoxDecoration(
                                        color:
                                            _obtenerColor(pedido.isEntregado),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            pedido.cliente,
                                            style: GoogleFonts.montserrat(
                                                fontSize: 25,
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                "Fecha de entrega:",
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 18,
                                                  color: Colors.black,
                                                ),
                                              ),
                                              Text(
                                                pedido.fecha,
                                                style: GoogleFonts.montserrat(
                                                    fontSize: 18,
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              ));
                        })),
              ],
            ),
          );
        });
  }

  Color _obtenerColor(bool isEntregado) {
    if (!isEntregado) {
      return const Color.fromARGB(255, 150, 150, 150);
    }
    return Color.fromARGB(146, 165, 190, 169);
  }
}
