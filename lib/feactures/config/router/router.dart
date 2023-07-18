import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/core/utils/exemple.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_page.dart';

class RouterApp {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) {
            return const SpeechSampleApp();
          },
          routes: [
            GoRoute(
              path: 'mapa',
              builder: (context, state) => const MapaPage(),
            )
          ]),
    ],
  );
}
