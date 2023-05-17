import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 1)
class Proveedor extends HiveObject {
  @HiveField(0)
  String nombre;
  @HiveField(1)
  String numerotel;
  @HiveField(3)
  String idproveedor;

  Proveedor({
    required this.nombre,
    required this.numerotel,
    required this.idproveedor,
  }) {}
  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'numerotel': numerotel,
      'idproveedor': idproveedor,
    };
  }

  @override
  String toString() {
    return 'Proveedor{nombre: $nombre, numerotel: $numerotel, idproveedor:$idproveedor}';
  }
}

class ProveedorAdapter extends TypeAdapter<Proveedor> {
  @override
  Proveedor read(BinaryReader reader) {
    return Proveedor(
      nombre: reader.read(),
      numerotel: reader.read(),
      idproveedor: reader.read(),
    );
  }

  @override
  // TODO: implement typeId
  int get typeId => 1;

  @override
  void write(BinaryWriter writer, Proveedor obj) {
    writer.write(obj.nombre);
    writer.write(obj.numerotel);
    writer.write(obj.idproveedor);
  }
}
