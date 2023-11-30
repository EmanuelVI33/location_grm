import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final cameraPositionProvider = StateProvider<CameraPosition>((ref) {
  // return CameraPosition(target: latlong, zoom: 14);
  return CameraPosition(target: LatLng(-17.781980, -63.185885), zoom: 16);
});
