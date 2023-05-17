import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:app/producto.dart';
import 'package:hive_flutter/adapters.dart';

class Editar_producto extends StatefulWidget {
  Editar_producto({super.key});

  @override
  State<Editar_producto> createState() => _EditarProductoState();
}

class _EditarProductoState extends State<Editar_producto> {
  final TextEditingController codigoController = TextEditingController();

  final TextEditingController nombreController = TextEditingController();

  final TextEditingController precioController = TextEditingController();

  final TextEditingController categoriaController = TextEditingController();

  final TextEditingController cantidadController = TextEditingController();
  String? selectedValue;
  bool _error = false;
  String _scanBarcode = '';

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  Widget build(BuildContext context) {
    var boxcategorias = Hive.box('categorias').values.toList();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: Text(
          "Editar producto",
          style: GoogleFonts.ptSerif(fontWeight: FontWeight.bold, fontSize: 28),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[400],
      ),
      body: Form(
        child: ListView(children: <Widget>[
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe el código de barras';
                }
                return null;
              },
              controller: codigoController,
              decoration: InputDecoration(
                hintText: 'Escribe el código',
                labelText: "Código de barras",
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              scanBarcodeNormal();
              codigoController.text = _scanBarcode;
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.teal,
            ),
            child: const Text('Codigo de barras'),
          ),
          // Text('Scan result : $_scanBarcode\n', style: TextStyle(fontSize: 20)),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe la descripción';
                }
                return null;
              },
              controller: nombreController,
              decoration: InputDecoration(
                hintText: 'Escribe el nombre',
                labelText: "Nombre",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe el precio de compra';
                }
                return null;
              },
              controller: precioController,
              decoration: InputDecoration(
                hintText: 'Escribe el precio de compra',
                labelText: "Precio de compra",
              ),
            ),
          ),
          Row(
            children: [
              Padding(padding: EdgeInsets.all(4)),
              Expanded(
                child: DropdownButtonFormField(
                    hint: Text('Categoria'),
                    onChanged: (value) {
                      categoriaController.text = value.toString();
                    },
                    items: boxcategorias
                        .map(
                          (categorias) => DropdownMenuItem(
                            value: categorias.nombre.toString(),
                            child: Text(categorias.nombre.toString()),
                          ),
                        )
                        .toList()),
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: TextFormField(
              keyboardType: TextInputType.number,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Escribe la existencia';
                }
                return null;
              },
              controller: cantidadController,
              decoration: InputDecoration(
                hintText: 'Escribe la existencia',
                labelText: "Existencia",
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () {
                  Navigator.pop(
                      context,
                      Producto(
                        nombre: nombreController.text,
                        codigo: codigoController.text,
                        precio: double.parse(precioController.text),
                        categoria: categoriaController.text,
                        cantidad: cantidadController.text,
                      ));
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Producto Actualizado'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text('Guardar'),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
