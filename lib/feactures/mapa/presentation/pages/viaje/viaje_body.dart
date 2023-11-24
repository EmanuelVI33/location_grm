import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/camera_position_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/map_controller_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/viaje/polyline_travel_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/viaje/route_provider.dart';

class ViajeBody extends ConsumerStatefulWidget {
  static const String routeName = 'viaje';
  const ViajeBody({super.key});

  @override
  ViajeBodyState createState() => ViajeBodyState();
}

class ViajeBodyState extends ConsumerState<ViajeBody> {
  BitmapDescriptor markerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);

  @override
  Widget build(BuildContext context) {
    final cameraPosition = ref.watch(cameraPositionProvider);
    final route = ref.watch(routeProvider);
    final polylines = ref.watch(polylineTravelProvider);
    ref
        .read(polylineTravelProvider.notifier)
        .addPolyline(route.origen!, route.destino!);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, // Color de la barra de navegación
      ),
      body: Stack(
        children: [
          SizedBox(
            child: GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: cameraPosition,
              onMapCreated: (controller) => ref
                  .read(mapCreatedProvider.notifier)
                  .setMapController(controller),
              markers: {
                if (route.origen != null)
                  Marker(
                    markerId: const MarkerId("0"),
                    position: route.origen!,
                    icon: markerIcon, // Cambia el icono del marcador
                  ),
                if (route.destino != null)
                  Marker(
                    markerId: const MarkerId("1"),
                    position: route.destino!,
                    icon: markerIcon, // Cambia el icono del marcador
                  ),
              },
              polylines: {polylines},
              // Personaliza la apariencia del mapa
              // Ejemplo: `theme: MapStyle.darkMapStyle`
              // Esto requiere tener un estilo personalizado previamente definido
              // Verifica la documentación para más detalles sobre MapStyle.
            ),
          ),
        ],
      ),
    );
  }

  Future<String> getAddress(LatLng point) async {
    final placemarks = await placemarkFromCoordinates(
      point.latitude,
      point.longitude,
      localeIdentifier: 'es',
    );

    String ubicacion = placemarks.first.thoroughfare ?? '';

    return placemarks.first.thoroughfare == '' ? 'Ubicación actual' : ubicacion;
  }
}
