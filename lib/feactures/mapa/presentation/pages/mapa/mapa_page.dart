import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_body.dart';

class MapaPage extends ConsumerStatefulWidget {
  const MapaPage({super.key});

  @override
  MapaPageState createState() => MapaPageState();
}

class MapaPageState extends ConsumerState<MapaPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: MapaBody(),
      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.indigo,
      //   onPressed: () {},
      //   child: const Icon(Icons.my_location),
      // ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
