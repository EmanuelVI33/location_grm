import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:location_grm/feactures/mapa/presentation/providers/mapa/camera_position_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/map_controller_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/markers_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/microphone_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/search_destino.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/search_origen.dart';

import '../../providers/mapa/polylines_provider.dart';

class MapaBody extends ConsumerStatefulWidget {
  final TextEditingController textOriginController;
  const MapaBody({super.key, required this.textOriginController});

  @override
  MapaBodyState createState() =>
      MapaBodyState(origenController: textOriginController);
}

class MapaBodyState extends ConsumerState<MapaBody> {
  // // GoogleMapController? mapController;
  final TextEditingController origenController; // = TextEditingController();
  // final TextEditingController destinationController = TextEditingController();
  // FocusNode origenFocusNode = FocusNode();
  // FocusNode destinationFocusNode = FocusNode();
  MapaBodyState({required this.origenController});

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final markers = ref.watch(markersProvider);
    final cameraPosition = ref.watch(cameraPositionProvider);
    final showMicrophone = ref.watch(displayMicrophone);
    final rutaPolylines = ref.watch(mapPolylineProvider);
    Set<TravelMode> selected = {rutaPolylines.travelMode!};
    return Stack(
      children: [
        SizedBox(
          child: GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => ref
                .read(mapCreatedProvider.notifier)
                .setMapController(controller),
            onTap: (LatLng point) async {
              ref.read(markersProvider.notifier).addDestino(point);
              ref.read(mapPolylineProvider.notifier).ocultar();
              origenController.text = await getAddress(point);
            },
            markers: Set<Marker>.from(markers.values),
            initialCameraPosition: cameraPosition,
            polylines: rutaPolylines.polylines,
          ),
        ),
        Positioned(
          top: 35,
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                child: SearchOrigen(
                  hintText: 'Buscar origen',
                  textController: origenController,
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              SizedBox(
                width: size.width,
                child: SearchDestino(
                  hintText: 'Buscar destino',
                  displayMicrophone:
                      ref.read(displayMicrophone.notifier).display,
                ),
              ),
              // const SizedBox(
              //   height: 5,
              // ),
              // SizedBox(
              //   width: size.width,
              //   child: const SpeechAddress(),
              // ),
              // if (showMicrophone) const Icon(Icons.mic)
            ],
          ),
        ),
        Positioned(
          bottom: 50,
          left: (size.width - 150) / 2,
          child: Visibility(
            visible: (markers['origen'] != null && markers['destino'] != null && !rutaPolylines.travelSelec),
            child: SizedBox(
              width: 150,
              child: ElevatedButton.icon(
                onPressed: ref.read(mapPolylineProvider.notifier).update,
                icon: const Icon(Icons.route_outlined),
                label: const Text(
                  'Ver Ruta',
                  style: TextStyle(fontSize: 20),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                          20), // Ajusta el radio según tus necesidades
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          bottom: 75,
          child: Align(
              alignment: Alignment.bottomCenter,
              child: Visibility(
                  visible: rutaPolylines.travelSelec,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 10),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.indigo),
                    child: Text(
                      '${ref.read(mapPolylineProvider.notifier).getDuration(rutaPolylines.travelMode!)} Km',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ))),
        ),
        Positioned.fill(
            bottom: 15,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Visibility(
                  visible: rutaPolylines.travelSelec,
                  child: SegmentedButton(
                    style: ButtonStyle(),
                    segments: [
                      ButtonSegment(
                          value: TravelMode.driving, icon: Text('vehiculo')),
                      ButtonSegment(
                          value: TravelMode.walking, icon: Text('caminando')),
                    ],
                    selected: selected,
                    onSelectionChanged: (value) {
                      ref
                          .read(mapPolylineProvider.notifier)
                          .update(travelMode: value.first);
                    },
                  ),
                ))),
        // if (showMicrophone)
        //   Positioned(
        //     bottom: 0,
        //     right: size.width * 0.38,
        //     child:
        //         Microphone(color: Colors.indigo, isListening: showMicrophone),
        // child: AvatarGlow(
        //   endRadius: 65,
        //   duration: Duration(milliseconds: 2000),
        //   glowColor: Colors.grey,
        //   repeat: true,
        //   repeatPauseDuration: Duration(milliseconds: 100),
        //   showTwoGlows: true,
        //   child: CircleAvatar(
        //     backgroundColor: Colors.indigo,
        //     radius: 35,
        //     child: Icon(
        //       Icons.mic,
        //       size: 35,
        //       color: Colors.white,
        //     ),
        //   ),
        // ),
        // ),
      ],
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

class _InfoRoute extends StatelessWidget {
  const _InfoRoute({
    super.key,
    required this.selected,
    required this.ref,
  });

  final Set<TravelMode> selected;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton(
      style: ButtonStyle(),
      segments: [
        ButtonSegment(value: TravelMode.driving, icon: Text('vehiculo')),
        ButtonSegment(value: TravelMode.walking, icon: Text('caminando')),
      ],
      selected: selected,
      onSelectionChanged: (value) {
        ref.read(mapPolylineProvider.notifier).update(travelMode: value.first);
      },
    );
  }
}
