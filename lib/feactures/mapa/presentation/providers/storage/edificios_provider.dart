import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_grm/feactures/mapa/domain/entities/edificio.dart';
import 'package:location_grm/feactures/mapa/domain/repository/local_storage_repository.dart';
import 'package:location_grm/feactures/mapa/presentation/providers/storage/local_storage_provider.dart';

final edificioProvider =
    StateNotifierProvider<EdificioNotifier, List<Edificio>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return EdificioNotifier(edificioCallback: localStorageRepository.getEdificio);
});

typedef EdificioCallback = Future<List<Edificio?>> Function({
  String? descripcion,
  String? localidad,
});

class EdificioNotifier extends StateNotifier<List<Edificio>> {
  // final LocalStorageRepository localStorageRepository;
  EdificioCallback edificioCallback;

  EdificioNotifier({required this.edificioCallback}) : super([]);

  Future<void> getEdificio({
    String? descripcion,
    String? localidad,
  }) async {
    final edificios =
        await edificioCallback(descripcion: descripcion, localidad: localidad);
    List<Edificio> listEdificio = [];

    for (var edificio in edificios) {
      if (edificio != null) {
        listEdificio.add(edificio);
      }
    }

    state = [...listEdificio];
  }
}
