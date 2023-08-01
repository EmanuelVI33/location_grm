import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
//import 'package:google_maps_webservice/places.dart' as map;
import 'package:location_grm/feactures/mapa/presentation/providers/mapa/ruta_polyline.dart';

import '../../../../core/constans/constants.dart';
import 'markers_provider.dart';


final mapPolylineProvider = StateNotifierProvider<PolylineNotifier, RutaPolyline>((ref) {
  final marker = ref.watch(markersProvider);
  return PolylineNotifier(marker: marker);
});

class PolylineNotifier extends StateNotifier<RutaPolyline>{
  final marker;
  
  PolylineNotifier({required this.marker}): super(
    RutaPolyline(
      travelMode: TravelMode.driving,
      travelSelec: false
    )
  );

  Future<void> update({TravelMode travelMode = TravelMode.driving}) async{
    var rutaPolyline = state.copyWith(travelMode: travelMode);
    if(marker['origen'] != null && marker['destino'] != null){
      PolylinePoints polylinePoints = PolylinePoints();
      LatLng origen = marker["origen"]!.position;
      LatLng destino = marker["destino"]!.position;
      List<LatLng> polylineCoordinates = [];
      
      PolylineResult rutaPolylineResult = await polylinePoints.getRouteBetweenCoordinates(
        google_api_key,
        PointLatLng(origen.latitude, origen.longitude), 
        PointLatLng(destino.latitude, destino.longitude), 
        travelMode: rutaPolyline.travelMode!
      );

      if (rutaPolylineResult.points.isNotEmpty) {
        for (var point in rutaPolylineResult.points) {
          polylineCoordinates.add(LatLng(point.latitude, point.longitude));
        }
      }
      List<PatternItem> polylinePattern = [
        PatternItem.dash(10),
        PatternItem.gap(5)
      ];
      Set<Polyline> polylines = {};
      polylines.add(Polyline(
        polylineId: PolylineId('1'), 
        points: polylineCoordinates,
        width: 4,
        color: Colors.blue,
        patterns: (travelMode == TravelMode.walking)? polylinePattern : []
      ));

      state = rutaPolyline.copyWith(origen: origen, destino: destino,polylines: polylines, travelSelec: true);
    }
  } 
  void ocultar(){
    state = state.copyWith(travelSelec: false);
  }
    
}
// final mapPolylineProvider = FutureProvider<Set<Polyline>>((ref) async {
//   Set<Polyline> polylines = {};
//   final marker = ref.watch(markersProvider);
//   //debugPrint("esta por aqui ->");
  
//   if(marker['origen'] == null || marker['destino'] == null){
//     debugPrint("---------->"+(marker['origen'] == null || marker['destino'] == null).toString());
//     return polylines;
    
//   } 

//   const travelMode = TravelMode.driving;
//   PolylinePoints polylinePoints = PolylinePoints();
//   LatLng origen = marker["origen"]!.position;
//   LatLng destino = marker["destinno"]!.position;
//   List<LatLng> polylineCoordinates = [];
  
//   debugPrint("-------------------x esta por aqui");
//   PolylineResult rutaPolylineResult = await polylinePoints.getRouteBetweenCoordinates(
//     google_api_key,
//     PointLatLng(origen.latitude, origen.longitude), 
//     PointLatLng(destino.latitude, destino.longitude), 
//     travelMode: travelMode
//   );

//   if (rutaPolylineResult.points.isNotEmpty) {
//     for (var point in rutaPolylineResult.points) {
//       polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//     }
//   }
  
//   polylines.add(Polyline(
//     polylineId: PolylineId('1'), 
//     points: polylineCoordinates,
//     width: 4,
//     color: Colors.blue,
//   ));
//   return polylines;
// });

