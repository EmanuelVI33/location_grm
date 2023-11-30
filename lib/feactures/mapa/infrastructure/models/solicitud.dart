import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

enum Status {
  pendiente,
  enviada,
  error,
}

class Solicitud {
  final String? id;
  final String data;
  final Status estado;

  Solicitud({this.id, required this.data, required this.estado});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'data': data,
      'estado': estado.index, // Guarda el índice del enum como entero
    };
  }

  factory Solicitud.fromMap(Map<String, dynamic> map) {
    return Solicitud(
      id: map['id'],
      data: map['data'],
      estado: Status.values[map['estado']], // Recupera el enum desde el índice almacenado
    );
  }
}