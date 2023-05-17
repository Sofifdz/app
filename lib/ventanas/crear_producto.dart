import 'package:app/categoria.dart';
import 'package:flutter/services.dart';
import 'package:app/producto.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:hive_flutter/adapters.dart';

class CrearProducto extends StatefulWidget {
  CrearProducto({super.key});

  @override
  State<CrearProducto> createState() => _CrearProductoState();
}

class _CrearProductoState extends State<CrearProducto> {
  String _scanBarcode = '';
  ////
  //final _myBox = Hive.openBox('productos');

  final TextEditingController codigoController = TextEditingController();

  final TextEditingController nombreController = TextEditingController();

  final TextEditingController precioController = TextEditingController();

  final TextEditingController categoriaController = TextEditingController();

  final TextEditingController cantidadController = TextEditingController();
  String? selectedValue;
  bool _error = false;
  final _formKey = GlobalKey<FormState>();
  List<Categoria> categorias = [];

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

  @override
  Widget build(BuildContext context) {
    var boxcategorias = Hive.box('categorias').values.toList();
    var boxp = Hive.box('productos').values.toList();
    codigoController.text = _scanBarcode;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.teal[400],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),

              Row(),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return 'Escribe el precio de compra';
                  }
                  return null;
                },
                controller: codigoController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Código',
                    icon: Icon(
                      Icons.code,
                      color: Colors.black,
                    )),
              ),

              ElevatedButton(
                onPressed: () {
                  scanBarcodeNormal();
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
              TextField(
                controller: nombreController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Nombre',
                  icon: Icon(
                    Icons.drive_file_rename_outline,
                    color: Colors.black,
                  ),
                  errorText: _error ? 'tu texto esta mal' : null,
                ),
                onChanged: (value) {
                  setState(() {
                    if (value.contains('null'))
                      _error = true;
                    else
                      _error = false;
                  });
                },
              ),
              const SizedBox(
                height: 20,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return 'Escribe el precio de compra';
                  }
                  return null;
                },
                controller: precioController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Precio',
                  icon: Icon(
                    Icons.local_atm,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              // Row(
              //   children: [
              //     DropdownMenu<Categoria>(
              //       initialSelection: Colors.green,
              //       controller: categoriaController,
              //       label: const Text('Color'),
              //       dropdownMenuEntries: colorEntries,
              //       onSelected: (ColorLabel? color) {
              //         setState(() {
              //           selectedColor = color;
              //         });
              //       },
              //     ),
              //   ],
              // ),
              SizedBox(
                height: 20,
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
              TextFormField(
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value!.isNotEmpty) {
                    return 'Escribe el precio de compra';
                  }
                  return null;
                },
                controller: cantidadController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Cantidad',
                  icon: Icon(
                    Icons.ac_unit,
                    color: Colors.black,
                  ),
                ),
              ),
              ElevatedButton(
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
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                ),
                child: const Text('Guardar'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromARGB(255, 0, 0, 0),
                ),
                child: const Text(
                  'Cancelar',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ));
  }
}
