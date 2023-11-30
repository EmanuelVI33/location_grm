import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  final double latScene;
  final double lngScene;
  final double latAmbulance;
  final double lngAmbulance;

  const MapScreen({
    Key? key,
    required this.latScene,
    required this.lngScene,
    required this.latAmbulance,
    required this.lngAmbulance,
  }) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mapa'),
      ),
      body: GoogleMap(
        onMapCreated: (controller) {
          setState(() {
            mapController = controller;
          });
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latScene, widget.lngScene),
          zoom: 14.0,
        ),
        markers: _createMarkers(),
      ),
    );
  }

  Set<Marker> _createMarkers() {
    return {
      Marker(
        markerId: MarkerId('Scene'),
        position: LatLng(widget.latScene, widget.lngScene),
        infoWindow: InfoWindow(title: 'Ubicación de la Escena'),
      ),
      Marker(
        markerId: MarkerId('Ambulance'),
        position: LatLng(widget.latAmbulance, widget.lngAmbulance),
        infoWindow: InfoWindow(title: 'Ubicación de la Ambulancia'),
      ),
    };
  }
}
