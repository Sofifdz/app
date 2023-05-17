import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

@HiveType(typeId: 2)
class Categoria extends HiveObject {
  @HiveField(0)
  String nombre = '';
  @HiveField(1)
  String idCategoria = '';

  Categoria({
    required this.nombre,
    required this.idCategoria,
  }) {}

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'idCategoria': idCategoria,
    };
  }

  @override
  String toString() {
    return 'Categoria{nombre: $nombre, idCategoria: $idCategoria}';
  }
}

class CategoriaAdapter extends TypeAdapter<Categoria> {
  @override
  Categoria read(BinaryReader reader) {
    return Categoria(
      nombre: reader.read(),
      idCategoria: reader.read(),
    );
  }

  @override
  // TODO: implement typeId
  int get typeId => 2;

  @override
  void write(BinaryWriter writer, Categoria obj) {
    writer.write(obj.nombre);
    writer.write(obj.idCategoria);
  }
}
