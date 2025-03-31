import 'package:cloud_firestore/cloud_firestore.dart';

class Pedidos {
  String NoPedido; 
  String cliente;
  String descripcion;
  int precio;
  String fecha;

  Pedidos({
    required this.NoPedido,
    required this.cliente,
    required this.descripcion,
    required this.precio,
    required this.fecha
  });

  factory Pedidos.fromFirestore(DocumentSnapshot doc)
  {
    Map<String, dynamic> data = doc.data() as Map<String,dynamic>;
    return Pedidos(
      NoPedido: doc.id,
      cliente: data['cliente'] ?? '', 
      descripcion: data['descripcion'] ?? '',
      precio:(data['precio'] ?? 0).toInt(),
      fecha: data['fecha'] ?? '',
    );
  }

  Map <String, dynamic> toFirestore()
  {
    return{
      'cliente':cliente,
      'descripcion': descripcion,
      'precio':precio,
      'fecha': fecha
    };
  }
}