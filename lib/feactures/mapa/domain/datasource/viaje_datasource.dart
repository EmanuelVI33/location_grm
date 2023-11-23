import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class ViajeDatasource {
  Future<Polyline> getRoute();
}
