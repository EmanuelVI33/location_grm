import 'package:flutter/material.dart';

import 'package:dio/dio.dart';

import '../../../../../httpInstance.dart';

class ListaPeticionesModel extends ChangeNotifier {
  ///  State fields for stateful widgets in this page.
  String? nro;
  String? latUser;
  String? lngUser;
  String? latScene;
  String? lngScene;
  String? address;
  String? photo;
  String? video;
  String? descripcion;
  int? victimsNum;
  String? status;
  String? entityName;
  String? entityCoordenada;
  String? createAt;
  List<ListaPeticionesModel>? procesado;
  ListaPeticionesModel(
      {this.nro,
      this.latUser,
      this.lngUser,
      this.latScene,
      this.lngScene,
      this.address,
      this.video,
      this.descripcion,
      this.victimsNum,
      this.photo,
      this.status,
      this.entityName,
      this.entityCoordenada,
      this.createAt});
  final Dio dio = ApiClient.getDioInstance();

  Future<void> fetchApiSolicitud() async {
    try {
      nro = "5276a769-1175-4966-ab4b-047924ab655a";
      print(nro);
      final response = await dio.get('/requests/${nro}');
      print(response.data);
      final List<Map<String, dynamic>> apiDataList = List.from(response.data);
      this.procesado = apiDataList.map((data) {
        // Parsear la cadena de fecha a un objeto DateTime
        DateTime createAtDateTime = DateTime.parse(data['createAt']);

        // Formatear la fecha como deseas (en este caso, yyyy-mm-dd hh:mm)
        String formattedCreateAt =
            '${createAtDateTime.year}-${_twoDigits(createAtDateTime.month)}-${_twoDigits(createAtDateTime.day)} ${_twoDigits(createAtDateTime.hour)}:${_twoDigits(createAtDateTime.minute)}';

        return ListaPeticionesModel(
          nro: data['nro'],
          latUser: data['latUser'],
          lngUser: data['lngUser'],
          latScene: data['latScene'],
          lngScene: data['lngScene'],
          address: data['address'],
          photo: data['photo'],
          video: data['video'],
          descripcion: data['descripcion'],
          victimsNum: data['victimsNum'],
          status: data['status'],
          entityName: data['entityName'],
          entityCoordenada: data['entityCoordenada'],
          createAt: formattedCreateAt,
        );
      }).toList();
    } catch (error) {
      // Manejar el error de la solicitud HTTP
      print('ERROR fetchApiSolicitud() : $error');
    }
  }

  String _twoDigits(int n) {
    // Añade un cero al principio si el número es menor que 10
    return n.toString().padLeft(2, '0');
  }

  void initState(BuildContext context) {}

  void dispose() {}
}
