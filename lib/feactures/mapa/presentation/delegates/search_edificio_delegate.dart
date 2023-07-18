import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_grm/feactures/mapa/domain/entities/edificio.dart';
import 'package:animate_do/animate_do.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/delegate/item_edificio.dart';

typedef SearchEdificioCallback = Future<List<Edificio?>> Function(
    {String? descripcion, String? localidad});

class SearchEdifioDelegate extends SearchDelegate<Edificio?> {
  final String label;
  final SearchEdificioCallback searchEdificio;
  // final void Function(LatLng) addMarker;

  SearchEdifioDelegate({
    required this.label,
    required this.searchEdificio,
    // required this.addMarker,
  });

  @override
  String get searchFieldLabel => label;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      FadeIn(
          animate: query.isNotEmpty,
          child: IconButton(
              onPressed: () => query = '', icon: const Icon(Icons.clear)))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () => close(context, null),
        icon: const Icon(Icons.arrow_back_ios_new_outlined));
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text('resultados');
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder(
      future: searchEdificio(descripcion: query),
      builder: (context, snapshot) {
        final edificios = snapshot.data ?? [];

        return ListView.builder(
          itemCount: edificios.length,
          itemBuilder: (context, index) {
            final edificio = edificios[index];

            return ItemEdificio(
              edificio: edificio!,
              close: close,
              // addMarker: addMarker,
            );
          },
        );
      },
    );
  }
}
