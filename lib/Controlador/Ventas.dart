import 'package:cloud_firestore/cloud_firestore.dart';

class Ventas {
  String id; 
  String usuarioId;
  int IDventa; 
  List<Map<String, dynamic>> productos;
  double total;
  String fecha;
  String IDcaja;

  Ventas({
    required this.id,
    required this.usuarioId,
    required this.IDventa,
    required this.productos,
    required this.total,
    required this.fecha,
    required this.IDcaja
  });

  factory Ventas.fromFirestore(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Ventas(
      id: doc.id,
      usuarioId: data['usuarioId'] ?? '',
      IDventa: data['ventaId'] ?? 0,
      productos: List<Map<String, dynamic>>.from(data['productos'] ?? []),
      total: (data['total'] ?? 0).toDouble(),
      fecha: (data['fecha']).toDate().toString(),
      IDcaja: data['IDcaja'] ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'usuarioId': usuarioId,
      'ventaId': IDventa,
      'productos': productos,
      'total': total,
      'fecha': fecha,
      'IDcaja':IDcaja,
    };
  }
}
