import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/home/home_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/solicitud/solicitud_page.dart';

class RouterApp {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) {
            return const HomePage();
          },
          routes: [
            GoRoute(
              path: 'mapa',
              builder: (context, state) => const MapaPage(),
            ),
            GoRoute(
              path: 'solicitud',
              builder: (context, state) => const SolicitudPage(),
            )
          ]),
    ],
  );
}
