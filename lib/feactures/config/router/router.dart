import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/login/login_screen.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/welcome.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/solicitud/solicitud_screen.dart';

class RouterApp {
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) {
            return const LoginScreen();
          },
          routes: [
            GoRoute(
              path: 'mapa',
              builder: (context, state) => const MapaPage(),
            ),
            GoRoute(
              path: 'solicitud',
              builder: (context, state) => const SolicitudScreen(),
            ),
          ]),
    ],
  );
}
