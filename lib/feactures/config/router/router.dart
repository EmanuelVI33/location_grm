import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/home/home_page.dart';
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
          builder: (context, state) => const LoginScreen(),
          routes: [
            GoRoute(
              path: 'mapa',
              name: MapaPage.routeName,
              builder: (context, state) => const MapaPage(),
            ),
            GoRoute(

              path: 'home',
              name: HomePage.routeName,
              builder: (context, state) => const HomePage(),
            ),
            GoRoute(
              path: 'solicitud',
              name: SolicitudScreen.routeName,
              builder: (context, state) => const SolicitudScreen(),
            )
          ]),
    ],
  );
}
