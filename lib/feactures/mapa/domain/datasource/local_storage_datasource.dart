import 'package:location_grm/feactures/mapa/domain/entities/edificio.dart';

abstract class LocalStorageDatasource {
  Future<List<Edificio?>> getEdificio({
    String? descripcion,
    String? localidad,
  });
}
