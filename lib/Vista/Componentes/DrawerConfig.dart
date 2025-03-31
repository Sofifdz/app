import 'package:app/Vista/Administrador/Vista_Almacen.dart';
import 'package:app/Vista/Administrador/Vista_Pedidos.dart';
import 'package:app/Vista/Administrador/Vista_Personal.dart';
import 'package:app/Vista/Administrador/prueba_Vpedidos.dart';
import 'package:app/Vista/Componentes/Component_Drawer.dart';
import 'package:app/Vista/Login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';


class DrawerConfig {
  
  /// Drawer para Administradores
  static ComponentDrawer administradorDrawer(BuildContext context) {
    
    return ComponentDrawer(
      items: ['Ventas', 'Almacen', 'Personal', 'Pedidos', 'Salir'],
      iconos: [
        Icons.shopping_basket,
        Icons.inventory,
        Icons.person,
        Icons.list_alt,
        Icons.exit_to_app
      ],
      onTaps: [
        () {
        
        },
        () {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VistaAlmacen()),
          );
        },
        () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VistaPersonal(),
          ));
        },
        () {
         Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => VistaPedidos
            (),
          ));
        },
        () {
          _logOut(context);
        },
      ],
      typeUser: 'Administrador',
    );
  }

  static ComponentDrawer empleadoDrawer(BuildContext context) {
    return ComponentDrawer(
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
          
        },
        () {
         
        },
        () {
          
        },
        () {
          
        },
        (){
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
}
