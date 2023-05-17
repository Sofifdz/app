import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive/hive.dart';
import 'package:app/producto.dart';

// import 'package:intl/intl.dart';

class Carrito extends StatefulWidget {
  const Carrito({super.key});

  @override
  State<StatefulWidget> createState() {
    return CarritoState();
  }
//   void initState() {
// _timeString = _formatTime(DateTime.now());

// Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTimeString());
// super.initState();
// }
// _getTimeString() {
// final DateTime now = DateTime.now();
// final String formattedTime = _formatTime(now);

// setState(() {
//   _timeString = formattedTime;
// });
// }
// String _formatTime(DateTime dateTime) {
// return DateFormat('hh:mm:ss').format(dateTime);
// }
}

class CarritoState extends State<Carrito> {
  List<Producto> productos = [];
  TextEditingController codigoController = TextEditingController();
  TextEditingController cantidadController = TextEditingController();
  TextEditingController nombreController = TextEditingController();
  TextEditingController totalController = TextEditingController();

  double sumatotal = 0.0;

  String _scanBarcode = '';

  void addProduct() {
    var codigoBarras = codigoController.text;
    var bproductos = Hive.openBox('productos');
    var box = Hive.box('productos');
    for (Producto producto in box.values) {
      if (producto.codigo == codigoBarras) {
        //añadir mi producto
        productos.add(producto);
        setState(() {});
        break;
      }
    }
  }

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
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });
  }

  // void verProducts() {
  //   var box = Hive.box('productos');
  //   print(box.values);
  // }

  @override
  Widget build(BuildContext context) {
    codigoController.text = _scanBarcode;
    var box = Hive.box('productos');
    print(box.values);

    //DateTime now = DateTime.now();
    // dynamic currentTime = DateFormat.jm().format(DateTime.now());
    // var productos = Hive.openBox('productos');
    // var boxproductos = Hive.box('productos').values.toList();
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 70,
          backgroundColor: Colors.teal[400],
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value!.isNotEmpty) {
                            return 'Escribe el precio de compra';
                          }
                          return null;
                        },
                        controller: codigoController,
                        decoration: InputDecoration(
                          hintText: 'Código de barras',
                        ),
                      ),
                    ),
                    FloatingActionButton(
                      backgroundColor: Colors.teal,
                      onPressed: () {
                        addProduct();
                      },
                      child: Icon(Icons.add),
                    ),
                  ],
                ),
              ]),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Numero de Venta:",
                    style: GoogleFonts.fredokaOne(fontSize: 15),
                  ),
                  SizedBox(
                    height: 30,
                  ),
                  Text(
                    "Fecha: ",
                    style: GoogleFonts.fredokaOne(fontSize: 15),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                IconButton(
                  icon: Icon(
                    Icons.barcode_reader,
                  ),
                  onPressed: () {
                    scanBarcodeNormal();
                  },
                ),
              ]),
              SizedBox(
                height: 30,
              ),
              DataTable(
                  columns: const <DataColumn>[
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Id",
                      style: TextStyle(fontSize: 20),
                    ))),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Nombre",
                      style: TextStyle(fontSize: 20),
                    ))),
                    DataColumn(
                        label: Expanded(
                            child: Text(
                      "Total",
                      style: TextStyle(fontSize: 20),
                    ))),
                  ],
                  rows: productos.map((producto) {
                    sumatotal = sumatotal + producto.precio;
                    return DataRow(
                      cells: <DataCell>[
                        DataCell(Text(
                          producto.codigo,
                          style: TextStyle(fontSize: 20),
                        )),
                        DataCell(Text(
                          producto.nombre,
                          style: TextStyle(fontSize: 20),
                        )),
                        DataCell(Text(
                          producto.precio.toString(),
                          style: TextStyle(fontSize: 20),
                        )),
                      ],
                    );
                  }).toList()),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("Total " + sumatotal.toString(),
                      style: GoogleFonts.fredokaOne(fontSize: 15))
                ],
              ),
              SizedBox(
                height: 50,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      'Pagar',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ],
          ),
        ));
  }
}
