import 'package:app/ventanas/crear_producto.dart';
import 'package:flutter/material.dart';
import 'package:app/ventanas/opciones.dart';
import 'package:app/ventanas/ventas.dart';
import 'package:app/ventanas/ver_proveedor.dart';
import 'package:app/ventanas/ver_categorias.dart';
import 'package:app/ventanas/ver_productos.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int currenTab = 0;
  final List<Widget> screens = [
    Ventas(),
    Ver_productos(),
    Ver_categorias(),
    Ver_proveedores(
      proveedores: [],
    ),
    CrearProducto(),
    opciones()
  ];

  final PageStorageBucket bucket = PageStorageBucket();
  Widget currentScreen = Ventas();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        child: currentScreen,
        bucket: bucket,
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 0,
        child: Container(
          height: 80,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Ventas();
                        currenTab = 0;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.local_mall,
                          color:
                              currenTab == 0 ? Colors.teal[400] : Colors.grey,
                        ),
                        Text(
                          'Ventas',
                          style: TextStyle(
                            color:
                                currenTab == 0 ? Colors.teal[400] : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Ver_productos();
                        currenTab = 1;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory,
                          color:
                              currenTab == 1 ? Colors.teal[400] : Colors.grey,
                        ),
                        Text(
                          'Productos',
                          style: TextStyle(
                            color:
                                currenTab == 1 ? Colors.teal[400] : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Ver_categorias();
                        currenTab = 2;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category,
                          color:
                              currenTab == 2 ? Colors.teal[400] : Colors.grey,
                        ),
                        Text(
                          'Categorias',
                          style: TextStyle(
                            color:
                                currenTab == 2 ? Colors.teal[400] : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  ),
                  MaterialButton(
                    minWidth: 40,
                    onPressed: () {
                      setState(() {
                        currentScreen = Ver_proveedores(
                          proveedores: [],
                        );
                        currenTab = 3;
                      });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.group,
                          color:
                              currenTab == 3 ? Colors.teal[400] : Colors.grey,
                        ),
                        Text(
                          'Proveedores',
                          style: TextStyle(
                            color:
                                currenTab == 3 ? Colors.teal[400] : Colors.grey,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
