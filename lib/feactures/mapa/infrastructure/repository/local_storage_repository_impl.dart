import 'package:location_grm/feactures/mapa/domain/datasource/local_storage_datasource.dart';
import 'package:location_grm/feactures/mapa/domain/entities/edificio.dart';
import 'package:location_grm/feactures/mapa/domain/repository/local_storage_repository.dart';

class LocalStorageRepositoryImpl extends LocalStorageRepository {
  final LocalStorageDatasource datasource;

  LocalStorageRepositoryImpl(this.datasource);

  @override
  Future<List<Edificio?>> getEdificio({
    String? descripcion,
    String? localidad,
  }) async {
    return await datasource.getEdificio(
        descripcion: descripcion, localidad: localidad);
  }
}
