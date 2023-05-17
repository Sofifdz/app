import 'package:app/categoria.dart';
import 'package:app/ventanas/crear_categoria.dart';
import 'package:app/ventanas/editar_categoria.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:app/categoria.dart';
import 'package:hive_flutter/adapters.dart';

class Ver_categorias extends StatefulWidget {
  const Ver_categorias({super.key});

  @override
  State<StatefulWidget> createState() {
    return Ver_categoriasState();
  }
}

class Ver_categoriasState extends State<Ver_categorias> {
  late final List<Categoria> categorias;

  @override
  Widget build(BuildContext context) {
    var boxcategorias = Hive.box('categorias').values.toList();
    var box = Hive.box('categorias');
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: Text(
            'Categorias',
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
                        return Crearcategoria();
                      },
                    ),
                  ).then(
                    (value) {
                      if (value != null) categorias.add(value);
                      if (value != null) {
                        var categoria = value;
                        var box = Hive.box('categorias');
                        box.add(categoria);
                      }
                      ;
                    },
                  );
                })
          ],
        ),
        body: ListView.builder(
            itemCount: boxcategorias.length,
            itemBuilder: (context, index) {
              var producto = boxcategorias[index];
              var v = box.getAt(index);
              return Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                color: Color.fromARGB(255, 193, 196, 203),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    ListTile(
                      title: Text(boxcategorias[index].nombre,
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
                                  "Id: ",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17),
                                ),
                              ),
                              Text(
                                boxcategorias[index].idCategoria,
                                style: TextStyle(fontSize: 17),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                    ButtonBar(
                      children: <Widget>[
                        IconButton(
                          icon: Icon(
                            Icons.edit,
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) {
                                  return Editar_categoria();
                                },
                              ),
                            );
                          },
                        ),
                        Builder(
                            builder: (context) => IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () {
                                    Hive.box('categorias');
                                    box.deleteAll(boxcategorias[index]);
                                    setState(() {});
                                  },
                                ))
                      ],
                    )
                  ],
                ),
              );
            }));
  }
}
