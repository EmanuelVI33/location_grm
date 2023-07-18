import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_body.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/floating_mark_location.dart';

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
    return Scaffold(
      body: MapaBody(),
      floatingActionButton: FloatingMarkLocation(
        onPressed: () {},
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
    );
  }
}
