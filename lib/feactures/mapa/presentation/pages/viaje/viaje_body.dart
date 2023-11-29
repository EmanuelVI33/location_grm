import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_grm/feactures/mapa/domain/entities/request.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/camera_position_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/map_controller_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/viaje/polyline_travel_provider.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/viaje/route_provider.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:geolocator/geolocator.dart';

class ViajeBody extends ConsumerStatefulWidget {
  static const String routeName = 'viaje';
  const ViajeBody({super.key});

  @override
  ViajeBodyState createState() => ViajeBodyState();
}

class ViajeBodyState extends ConsumerState<ViajeBody> {
  BitmapDescriptor markerIcon =
      BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan);
  Request? request;
  LatLng? myPosition;
  var data;
  GoogleMapController? _mapController;

  @override
  void dispose() {
    // Cancela el temporizador al liberar el estado del widget
    // locationUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    listenEvent(); // Para inicializar
    // determinePosistion();
    getCurrentLocation();

    // locationUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
    //   getCurrentLocation();
    // });
  }

  Future<Position> determinePosistion() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('error');
      }
    }
    return await Geolocator.getCurrentPosition();
  }

  void getCurrentLocation() async {
    Position position = await determinePosistion();
    // ref
    //     .read(myLocationProvider.notifier)
    //     .update(LatLng(position.latitude, position.longitude));
    print('Update position para mandar a la API');
    myPosition = LatLng(position.latitude, position.longitude);
    // if (myPosition != null) {
    //   _apiService.sendLocation(myPosition!);
    // }
    setState(() {});

    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLng(myPosition!),
      );
    }
  }

  void listenEvent() {
    try {
      SSEClient.subscribeToSSE(
          method: SSERequestType.GET,
          url: 'https://0000-181-115-209-197.ngrok-free.app/api/accept',
          header: {
            // "Cookie":
            //     'jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJpYXQiOjE2NDMyMTAyMzEsImV4cCI6MTY0MzgxNTAzMX0.U0aCAM2fKE1OVnGFbgAU_UVBvNwOMMquvPY8QaLD138; Path=/; Expires=Wed, 02 Feb 2022 15:17:11 GMT; HttpOnly; SameSite=Strict',
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
          }).listen(
        (event) {
          print(
              '--------------------------------------------------------------------------------------');
          print(
              '${event.data}-------------------------------------------------------------------------------');
          print(
              '--------------------------------------------------------------------------------------');

          if (event.data != null) {
            final responseMap = requestFromJson(event.data!);
            if (responseMap != null) {
              setState(() {
                request = responseMap;
                data = event.data;
              });
            }
          }

          // Recibir y almacenar
        },
        onDone: () {
          print("SSE stream closed");
        },
        onError: (error) {
          print(
              '--------------------------------------------------------------------------------------');
          print("Error en la conexión SSE: $error");
          print(
              '--------------------------------------------------------------------------------------');
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final cameraPosition = ref.watch(cameraPositionProvider);
    final route = ref.watch(routeProvider);
    final polylines = ref.watch(polylineTravelProvider);

    if (myPosition != null && request != null && request?.message != null) {
      ref.read(polylineTravelProvider.notifier).addPolyline(
          myPosition!,
          LatLng(double.parse(request!.message.latUser),
              double.parse(request!.message.lngScene)));
    }

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
              onMapCreated: (controller) {
                ref
                    .read(mapCreatedProvider.notifier)
                    .setMapController(controller);
                _mapController = controller;
              },
              markers: {
                if (myPosition != null)
                  Marker(
                    markerId: const MarkerId("origen"),
                    position: myPosition!,
                    icon: markerIcon, // Cambia el icono del marcador
                  ),
                if (request != null)
                  Marker(
                    markerId: const MarkerId("scene"),
                    position: LatLng(double.parse(request!.message.latUser),
                        double.parse(request!.message.lngScene)),
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
