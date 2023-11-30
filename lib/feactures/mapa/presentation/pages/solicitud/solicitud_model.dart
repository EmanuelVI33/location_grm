import 'package:flutter/material.dart';

class SolicitudModel {
  int nroregistro;
  String password;

  SolicitudModel({required this.nroregistro, required this.password});

  TextEditingController correoController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void dispose() {
    correoController.dispose();
    passwordController.dispose();
  }

  /// Additional helper methods are added here.
}
