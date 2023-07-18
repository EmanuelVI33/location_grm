import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/camera_position_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/storage/edificios_provider.dart';

class MapaBody extends ConsumerStatefulWidget {
  const MapaBody({super.key});

  @override
  MapaBodyState createState() => MapaBodyState();
}

class MapaBodyState extends ConsumerState<MapaBody> {
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    ref.read(edificioProvider.notifier).getEdificio();
  }

  @override
  Widget build(BuildContext context) {
    final edificios = ref.watch(edificioProvider);
    final edificio = edificios.first;
    final lanlog = LatLng(edificio.latitud, edificio.longitud);

    return Stack(
      children: [
        GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => mapController,
            initialCameraPosition: ref.watch(cameraPosition(lanlog))),
      ],
    );
  }
}
