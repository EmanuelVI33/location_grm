import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_grm/feactures/mapa/domain/entities/edificio.dart';

class ItemEdificio extends ConsumerWidget {
  final Edificio edificio;
  final void Function(BuildContext context, Edificio? result) close;
  // final void Function(LatLng) addMarker;

  const ItemEdificio(
      {super.key,
      required this.edificio,
      // required this.addMarker,
      required this.close});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
        title: Text(edificio.descripcion),
        subtitle: Text(edificio.localidad),
        onTap: () {
          close(context, edificio);
        });
  }
}
