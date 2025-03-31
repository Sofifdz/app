import 'package:app/Controlador/Productos.dart';
import 'package:app/Controlador/ServiciosFirebase.dart';
import 'package:app/Vista/Administrador/Vista_AgregarProducto.dart';
import 'package:app/Vista/Administrador/Vista_EditarPersonal.dart';
import 'package:app/Vista/Administrador/Vista_EditarProducto.dart';
import 'package:app/Vista/Componentes/Component_Filtre.dart';
import 'package:app/Vista/Componentes/Component_ShowDeteleDialog.dart';
import 'package:app/Vista/Componentes/DrawerConfig.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VistaAlmacen extends StatefulWidget {
  const VistaAlmacen({super.key});

  @override
  State<VistaAlmacen> createState() => _VistaAlmacenState();
}

class _VistaAlmacenState extends State<VistaAlmacen> {
  TextEditingController _searchController = TextEditingController();

  List<DocumentSnapshot> _searchResults = [];

  int expandedIndex = -1;

  List _allResults = [];
  List _resultList = [];
  getProductStream() async {
    var data = await FirebaseFirestore.instance
        .collection('productos')
        .orderBy('productoname')
        .get();
    
    print('Productos recuperados: ${data.docs.length}'); 

    setState(() {
      _allResults = data.docs;
    });
    searchResultList();
  }

  @override
  void initState() {
    super.initState();
    getProductStream();
    _searchController.addListener(_onSearchChanged);
  }

  _onSearchChanged() {
    print(_searchController.text);
    searchResultList();
  }

  searchResultList() {
    var showResults = [];

    if (_searchController.text.trim().isNotEmpty) {
      for (var productSnapShot in _allResults) {
        var name = productSnapShot['productoname'].toString().toLowerCase();
        if (name.contains(_searchController.text.toLowerCase())) {
          showResults.add(productSnapShot);
        }
      }
    } else {
      showResults = List.from(_allResults);
    }
    print('Resultados de la búsqueda: ${showResults.length}');
    setState(() {
      _resultList = showResults;
    });
  }

  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void productos() {
    setState(() {});
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
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle_outline,
                color: Color.fromARGB(255, 81, 81, 81), size: 35),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => VistaAgregarproducto()));
            },
          )
        ],
        title: Center(
          child: Text(
            "Almacén",
            style: GoogleFonts.montserrat(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 81, 81, 81)),
          ),
        ),
      ),
      drawer: DrawerConfig.administradorDrawer(context),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: () {
                                 setState(() {
                                  _searchController.clear();
                                  searchResultList();
                                });
                              },
                            )
                          : null,
                    ),
                    //onChanged: _query,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    /* showModalBottomSheet(
                      context: context,
                      builder: (BuildContext context) {
                        return Component_Filtre(
                          onFilterChanged:
                              _applyFilter, // Recibe (orderBy, descending)
                        );
                      },
                    );*/
                  },
                  icon: Icon(Icons.filter_alt,
                      size: 35, color: const Color.fromARGB(255, 81, 81, 81)),
                ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            body(context)
          ],
        ),
      ),
    );
  }

  Widget body(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('productos').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return Center(
            child: Text(
              "No hay productos registrados",
              style: GoogleFonts.montserrat(fontSize: 20, color: Colors.red),
            ),
          );
        }
        print('productos: ${snapshot.data!.docs.length}');

        final productosList = snapshot.data!.docs
            .map((doc) => Productos.fromFirestore(doc))
            .toList();

        return Expanded(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: ListView.builder(
              itemCount: productosList.length,
              itemBuilder: (context, index) {
                final producto = productosList[index];

                return Dismissible(
                  key: Key(producto.id),
                  direction: DismissDirection.endToStart,
                  confirmDismiss: (direction) async {
                    return await DeleteDialogProducts.showDeleteDialog(
                      item: producto,
                      context: context,
                      itemName: producto.productoname,
                      onDelete: productos,
                    );
                  },
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  child: Card(
                    color: _obtenerColor(producto.existencias),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => VistaEditarproducto(
                              producto: producto,
                              updateProduct: (Productos updateProduct) async {
                                // esto me actualiza el usuario en Firestore
                                await FirebaseFirestore.instance
                                    .collection('productos')
                                    .doc(updateProduct.id)
                                    .update(updateProduct.toFirestore());
                              },
                            ),
                          ),
                        ).then((_) => productos());
                      },
                      child: Column(
                        children: [
                          SizedBox(
                              height: 100,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                      child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Producto',
                                          style: GoogleFonts.montserrat(
                                            fontSize: 22,
                                            color: const Color.fromARGB(
                                                255, 81, 81, 81),
                                          ),
                                        ),
                                        Text(
                                          producto.productoname,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 22,
                                            fontWeight: FontWeight.bold,
                                            color: const Color.fromARGB(
                                                255, 81, 81, 81),
                                          ),
                                        )
                                      ],
                                    ),
                                  )),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Existencias',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 22,
                                          color: const Color.fromARGB(
                                              255, 81, 81, 81),
                                        ),
                                      ),
                                      Text(
                                        producto.existencias.toString(),
                                        style: GoogleFonts.montserrat(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 81, 81, 81),
                                        ),
                                      )
                                    ],
                                  )),
                                  Expanded(
                                      child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Precio',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 22,
                                          color: const Color.fromARGB(
                                              255, 81, 81, 81),
                                        ),
                                      ),
                                      Text(
                                        '\$${producto.precio.toString()}',
                                        style: GoogleFonts.montserrat(
                                          fontSize: 22,
                                          fontWeight: FontWeight.bold,
                                          color: const Color.fromARGB(
                                              255, 81, 81, 81),
                                        ),
                                      )
                                    ],
                                  ))
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }

  Color _obtenerColor(int existencia) {
    if (existencia < 20) {
      return const Color.fromARGB(255, 255, 150, 142);
    }
    return Color.fromARGB(146, 225, 225, 225);
  }
}

class DeleteDialogProducts {
  static Future<bool?> showDeleteDialog<T>({
    required BuildContext context,
    required T item,
    required String itemName,
    required VoidCallback onDelete,
  }) async {
    if (item is Productos) {
      return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              "¿Estás seguro de que deseas eliminar ${item.productoname}?",
              style: GoogleFonts.montserrat(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: const Color.fromARGB(255, 81, 81, 81),
              ),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancelar',
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 81, 81, 81),
                  ),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await ServiciosFirebaseProductos.deleteProduct(
                      item.id, onDelete);

                  Navigator.pop(context);
                },
                child: Text(
                  "Eliminar",
                  style: GoogleFonts.montserrat(
                    fontSize: 15,
                    color: const Color.fromARGB(255, 81, 81, 81),
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
    return null;
  }
}
