import 'package:flutter/material.dart';

class SolicitudScreen extends StatelessWidget {
  static const route = '/solicitud';
  const SolicitudScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: const Text('Solicitud'),
        ),
      ),
    );
  }
}
