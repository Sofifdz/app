import 'package:app/ventanas/carrito.dart';
import 'package:flutter/material.dart';
import 'package:app/producto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:hive/hive.dart';

class Ventas extends StatefulWidget {
  const Ventas({super.key});

  @override
  State<StatefulWidget> createState() {
    return VentasState();
  }
}

class VentasState extends State<Ventas> {
  List<Producto> productos = [];
  TextEditingController codigoController = TextEditingController();
  String _scanBarcode = '';
  int cantidad = 0;

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

  // void verProducts() {
  //   var box = Hive.box('productos');
  //   print(box.values);
  // }

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
    var box = Hive.box('productos').values.toList();
    codigoController.text = _scanBarcode;
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        title: const Text(''),
        backgroundColor: Colors.teal[400],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: codigoController,
                    decoration: InputDecoration(
                      hintText: 'Código de barras',
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: () {
                    addProduct();
                  },
                  child: Icon(Icons.search),
                  backgroundColor: Colors.teal,
                ),
                FloatingActionButton(
                  onPressed: () {
                    scanBarcodeNormal();
                  },
                  child: Icon(Icons.barcode_reader),
                  backgroundColor: Colors.teal,
                ),
              ],
            ),
            Column(
              children: productos
                  .map(
                    (producto) => Container(
                        color: Color.fromARGB(255, 152, 184, 193),
                        child: Column(
                          children: <Widget>[
                            ListTile(
                              title: Text(producto.nombre,
                                  style: TextStyle(fontSize: 20)),
                              subtitle: Row(
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
                                    producto.codigo,
                                    style: TextStyle(fontSize: 17),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )),
                  )
                  .toList(),
            ),
            Text('$cantidad'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                cantidad++;
                print('cantidad:$cantidad');
                return Carrito();
              },
            ),
          );
        },
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
      ),
    );
  }
}
