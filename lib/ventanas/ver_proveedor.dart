import 'package:app/ventanas/crear_proveedor.dart';
import 'package:app/ventanas/editar_proveedor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/proveedor.dart';

class Ver_proveedores extends StatelessWidget {
  final List<Ver_proveedores> proveedores;
  const Ver_proveedores({
    super.key,
    required this.proveedores,
  });

  @override
  Widget build(BuildContext context) {
    var boxproveedores = Hive.box('proveedor').values.toList();
    var box = Hive.box('proveedor');
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: Text(
            'Proveedores',
            style:
                GoogleFonts.ptSerif(fontWeight: FontWeight.bold, fontSize: 28),
          ),
          centerTitle: true,
          backgroundColor: Colors.teal[400],
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add_circle_sharp,
                  size: 28,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return CrearProveedor();
                      },
                    ),
                  ).then(
                    (value) {
                      if (value != null) proveedores.add(value);
                      if (value != null) {
                        var proveedor = value;
                        var boxp = Hive.box('proveedor');
                        boxp.add(proveedor);
                      }
                    },
                  );
                })
          ],
        ),
        body: ListView.builder(
            itemCount: boxproveedores.length,
            itemBuilder: (context, index) {
              var proveedor = boxproveedores[index];
              var v = box.getAt(index);
              return Container(
                color: Color.fromARGB(255, 152, 184, 193),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(boxproveedores[index].nombre,
                          style: TextStyle(fontSize: 20)),
                      subtitle: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 0,
                                  top: 0,
                                  right: 5,
                                  bottom: 0,
                                ),
                                child: Text(
                                  "Id Proveedor: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              Text(
                                boxproveedores[index].idproveedor,
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                  left: 0,
                                  top: 0,
                                  right: 5,
                                  bottom: 0,
                                ),
                                child: Text(
                                  "Num. telefonico: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              Text(
                                boxproveedores[index].numerotel,
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        FilledButton(
                          child: Icon(
                            Icons.edit,
                            color: Colors.amber,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Editar_proveedor();
                                },
                              ),
                            );
                          },
                        ),
                        Builder(
                            builder: (context) => FilledButton(
                                  child: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {},
                                ))
                      ],
                    )
                  ],
                ),
              );
            }));
  }
}
