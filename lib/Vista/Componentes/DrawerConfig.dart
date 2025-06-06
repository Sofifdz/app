import 'package:app/Vista/Administrador/Vista_Almacen.dart';
import 'package:app/Vista/Administrador/Vista_Pedidos.dart';
import 'package:app/Vista/Administrador/Vista_Personal.dart';
import 'package:app/Vista/Administrador/vistaAdmin.dart';
import 'package:app/Vista/Componentes/Component_Drawer.dart';
import 'package:app/Vista/Componentes/ShowDialogCaja.dart';
import 'package:app/Vista/Empleado/Vista_PedidosEmpleado.dart';
import 'package:app/Vista/Empleado/Vista_Ventas.dart';
import 'package:app/Vista/Empleado/Vista_VentasTurno.dart';
import 'package:app/Vista/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DrawerConfig {
  // En el método administradorDrawer y empleadoDrawer
  static ComponentDrawer administradorDrawer(
      BuildContext context, String usuarioId, String username) {
    return ComponentDrawer(
      usuarioId: usuarioId, // ← Nuevo campo que debes pasar
      username: username,
      colorr: Color.fromARGB(160, 133, 203, 144),
      items: ['Ventas', 'Almacen', 'Personal', 'Pedidos', 'Salir'],
      iconos: [
        Icons.shopping_basket,
        Icons.inventory,
        Icons.person,
        Icons.list_alt,
        Icons.exit_to_app
      ],
      onTaps: [
        // Asegúrate de que el username esté disponible al hacer clic
        () {Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Vistaadmin(usuarioId: usuarioId, username: username)),
          );},
        () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    VistaAlmacen(usuarioId: usuarioId, username: username)),
          );
        },
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VistaPersonal(
                  usuarioId: usuarioId,
                  username: username,
                ),
              ));
        },
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VistaPedidos(
                     usuarioId: usuarioId,
      username: username,
                ),
              ));
        },
        () {
          _logOut(context);
        },
      ],
      typeUser: 'Administrador',
    );
  }

  static ComponentDrawer empleadoDrawer(
      BuildContext context, String usuarioId, String username) {
    return ComponentDrawer(
      usuarioId: usuarioId, // ← Nuevo campo que debes pasar
      username: username,
      colorr: Color.fromARGB(255, 209, 219, 250),
      items: [
        'Nueva Venta',
        'Ventas del turno',
        'Pedidos',
        'Corte de caja',
        'Salir'
      ],
      iconos: [
        Icons.add_shopping_cart,
        Icons.shopping_basket_rounded,
        Icons.list_alt,
        Icons.money_off,
        Icons.exit_to_app
      ],
      onTaps: [
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VistaVentas(
                  usuarioId: usuarioId,
                  username: username,
                ),
              ));
        },
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VistaVentasturno(
                      usuarioId: usuarioId, username: username)));
        },
        () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => VistaPedidosEmpleado(
                        username: username,
                        usuarioId: usuarioId,
                      )));
        },
        () {
          corteDeCaja(context, usuarioId, username);
        },
        () {
          _logOut(context);
        },
      ],
      typeUser: 'Empleado',
    );
  }

  static Future<void> _logOut(BuildContext context) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    try {
      await _auth.signOut();
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      print('Error al cerrar sesión: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al cerrar sesión: $e')),
      );
    }
  }

  static Future<void> corteDeCaja(
      BuildContext context, String usuarioId, String username) async {
    await ShowDialogCaja.show(
      context: context,
      usuarioId: usuarioId,
      username: username,
      abroOcierro: 'Cierro con',
      txtBoton: 'Cerrar',
      tipoOperacion: "cerrar",
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }
}
