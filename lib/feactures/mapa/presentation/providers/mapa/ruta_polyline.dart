import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
//import 'package:google_maps_webservice/places.dart';

class RutaPolyline{
  LatLng? origen;
  LatLng? destino;
  TravelMode? travelMode;
  Set<Polyline> polylines;
  double distancia;
  bool travelSelec;

  RutaPolyline({
    this.origen,
    this.destino,
    this.travelMode,
    this.polylines = const {},
    this.distancia = 0,
    this.travelSelec = false
  });

  RutaPolyline copyWith({
    LatLng? origen,
    LatLng? destino,
    TravelMode? travelMode,
    Set<Polyline>? polylines,
    double? distancia,
    bool? travelSelec,
  }){
    return RutaPolyline(
      origen: origen?? this.origen, 
      destino: destino?? this.destino, 
      travelMode: travelMode?? this.travelMode,
      polylines: polylines?? this.polylines,
      distancia: distancia?? this.distancia,
      travelSelec: travelSelec?? this.travelSelec
    );
  }
}