import 'package:app/proveedor.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:app/producto.dart';
import 'package:app/ventanas/crear_producto.dart';
import 'package:app/ventanas/crear_categoria.dart';
import 'package:app/ventanas/crear_proveedor.dart';
import '../categoria.dart';

class opciones extends StatelessWidget {
  TextEditingController nombreproducto = TextEditingController();
  TextEditingController codigo = TextEditingController();
  TextEditingController precio = TextEditingController();
  List<Producto> productos = [];
  List<Proveedor> proveedores = [];
  List<Categoria> categorias = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Text('Agregar',
                textAlign: TextAlign.left,
                style: GoogleFonts.fredokaOne(
                  fontSize: 40,
                  fontWeight: FontWeight.w700,
                  color: Colors.black,
                  letterSpacing: 3,
                )),
            const SizedBox(
              height: 50,
            ),
            Row(
              children: [
                Expanded(
                  child: Image(
                    image: NetworkImage(
                        'https://static.vecteezy.com/system/resources/previews/005/165/303/original/add-to-cart-icon-style-add-product-in-trolley-vector.jpg'),
                    height: 200,
                    width: 50,
                  ),
                ),
              ],
            ),
            const SizedBox(
              width: 10,
              height: 10,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
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
              child: Text(
                'Ingresar Nuevo Producto',
                textAlign: TextAlign.start,
                style: GoogleFonts.josefinSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 3,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
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
              },
              child: Text(
                'Ingresar Nuevo Proveedor',
                textAlign: TextAlign.start,
                style: GoogleFonts.josefinSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 3,
                ),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
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
              },
              child: Text(
                'Ingresar Nueva Categoria',
                textAlign: TextAlign.start,
                style: GoogleFonts.josefinSans(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: 3,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
