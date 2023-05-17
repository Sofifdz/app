import 'package:app/ventanas/crear_producto.dart';
import 'package:app/ventanas/editar_producto.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:app/producto.dart';
import 'package:hive_flutter/adapters.dart';

class Ver_productos extends StatefulWidget {
  const Ver_productos({super.key});

  @override
  State<StatefulWidget> createState() {
    return Ver_productosState();
  }
}

class Ver_productosState extends State<Ver_productos> {
  var productobox = Hive.box('productos').values.toList();
  List<dynamic> productos = [];
  var box = Hive.box('productos');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          title: Text(
            'Productos',
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
                      return CrearProducto();
                    },
                  ),
                ).then(
                  (value) {
                    if (value != null) productos.add(value);
                    if (value != null) {
                      var producto = value;
                      var box = Hive.box('productos');
                      box.add(producto);
                    }
                  },
                );
              },
            ),
          ],
        ),
        body: ListView.builder(
            itemCount: productobox.length,
            itemBuilder: (context, index) {
              final producto = productobox[index];

              var v = box.getAt(index);
              return Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  color: Color.fromARGB(255, 193, 196, 203),
                  child: ListTile(
                      title: Text(productobox[index].nombre,
                          style: TextStyle(fontSize: 20)),
                      subtitle: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Column(children: [
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
                                    productobox[index].codigo,
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
                                      "Precio: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  Text(
                                    productobox[index].precio.toString(),
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
                                      "Categoria: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  Text(
                                    productobox[index].categoria,
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
                                      "Cantidad: ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 17),
                                    ),
                                  ),
                                  Text(
                                    productobox[index].cantidad,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            ]),
                            ButtonBar(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit),
                                  onPressed: () {
                                    //  List<Producto> productos = [];
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) {
                                          return Editar_producto();
                                        },
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                ),
                                Builder(
                                    builder: (context) => IconButton(
                                          icon: Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            Hive.box('productos');
                                            box.deleteAll(productobox[index]);
                                            setState(() {});
                                          },
                                        ))
                              ],
                            )
                          ])));
            }));
  }
}
