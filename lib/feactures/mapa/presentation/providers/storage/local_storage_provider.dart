import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_grm/feactures/mapa/infrastructure/datasource/isar_datasource.dart';
import 'package:location_grm/feactures/mapa/infrastructure/repository/local_storage_repository_impl.dart';

final localStorageRepositoryProvider = Provider((ref) {
  return LocalStorageRepositoryImpl(IsarDatasource());
});
