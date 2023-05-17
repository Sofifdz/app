import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 0)
class Producto extends HiveObject {
  @HiveField(0)
  String codigo = '';
  @HiveField(1)
  String nombre = '';
  @HiveField(2)
  double precio = 0.0;
  @HiveField(3)
  String categoria = '';
  @HiveField(4)
  String cantidad = '';

  Producto({
    required this.codigo,
    required this.nombre,
    required this.precio,
    required this.categoria,
    required this.cantidad,
  }) {}

  Map<String, dynamic> toMap() {
    return {
      'codigo': codigo,
      'nombre': nombre,
      'precio': precio,
      'categoria': categoria,
      'cantidad': cantidad,
    };
  }

  @override
  String toString() {
    return 'Producto{codigo: $codigo, nombre: $nombre, precio: $precio,categoria: $categoria,cantidad: $cantidad}';
  }
}

class ProductoAdapter extends TypeAdapter<Producto> {
  @override
  Producto read(BinaryReader reader) {
    return Producto(
      codigo: reader.read(),
      nombre: reader.read(),
      precio: reader.read(),
      categoria: reader.read(),
      cantidad: reader.read(),
    );
  }

  @override
  // TODO: implement typeId
  int get typeId => 0;

  @override
  void write(BinaryWriter writer, Producto obj) {
    writer.write(obj.codigo);
    writer.write(obj.nombre);
    writer.write(obj.precio);
    writer.write(obj.categoria);
    writer.write(obj.cantidad);
  }
}
