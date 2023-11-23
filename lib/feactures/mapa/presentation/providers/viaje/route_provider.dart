import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_grm/feactures/mapa/domain/entities/route_travel.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'route_provider.g.dart';

@riverpod
class Route extends _$Route {
  @override
  RouteTravel build() {
    return RouteTravel(
        origen: const LatLng(-17.781980, -63.185885),
        destino: const LatLng(-17.762769, -63.192391));
  }
}
