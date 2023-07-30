import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:avatar_glow/avatar_glow.dart';

import 'package:location_grm/feactures/mapa/presentation/providers/mapa/camera_position_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/map_controller_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/markers_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/microphone_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/direccion_origen_input_widget.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/microphone.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/search_destino.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/search_origen.dart';

class MapaBody extends ConsumerStatefulWidget {
  const MapaBody({super.key});

  @override
  MapaBodyState createState() => MapaBodyState();
}

class MapaBodyState extends ConsumerState<MapaBody> {
  // // GoogleMapController? mapController;
  // final TextEditingController origenController = TextEditingController();
  // final TextEditingController destinationController = TextEditingController();
  // FocusNode origenFocusNode = FocusNode();
  // FocusNode destinationFocusNode = FocusNode();

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

    return Stack(
      children: [
        // top: 300,
        SizedBox(
          child: GoogleMap(
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: false,
            onMapCreated: (controller) => ref
                .read(mapCreatedProvider.notifier)
                .setMapController(controller),
            markers: Set<Marker>.from(markers.values),
            initialCameraPosition: cameraPosition,
          ),
        ),
        Positioned(
          top: 35,
          child: Column(
            children: [
              SizedBox(
                width: size.width,
                child: const SearchOrigen(
                  hintText: 'Buscar origen',
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
}
