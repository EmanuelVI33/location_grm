import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/welcome.dart';

class RouterApp {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) {
            return const MapaPage();
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
