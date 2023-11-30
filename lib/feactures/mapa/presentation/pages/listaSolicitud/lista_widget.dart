import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'lista_model.dart';

import 'package:flutter/material.dart';

class ListaPeticiones extends StatefulWidget {
  const ListaPeticiones({Key? key}) : super(key: key);
  static const routeName = 'peticiones';

  @override
  _ListaPeticionesState createState() => _ListaPeticionesState();
}

class _ListaPeticionesState extends State<ListaPeticiones> {
  late ListaPeticionesModel _model;

  void initState() {
    super.initState();
    _model = ListaPeticionesModel();
    _loadData();
  }

  Future<void> _loadData() async {
    await _model.fetchApiSolicitud();
    // Una vez que se ha completado la carga de datos, se vuelve a construir el widget
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Registro de Asistencias',
          style: TextStyle(fontFamily: 'Roboto', fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.pink,
        elevation: 0,
      ),
      body: _model.procesado != null
          ? ListView.builder(
              itemCount: _model.procesado!.length,
              itemBuilder: (context, index) {
                return _buildAsistenciaCard(_model.procesado![index]);
              },
            )
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  Widget _buildAsistenciaCard(ListaPeticionesModel peticion) {
    return Card(
      elevation: 5,
      margin: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        title: Text(
          'Status: ${peticion.status}',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Fecha: ${peticion.createAt}'),
            Text('Dirección: ${peticion.address}'),
          ],
        ),
      ),
    );
  }
}
