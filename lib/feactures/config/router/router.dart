import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/home/home_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/listaSolicitud/lista_widget.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/login/login_screen.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/login/tutorial_screen.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/solicitud/solicitud_screen.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/viaje/viaje_body.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: LoginScreen.routeName,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/mapaPage',
      name: MapaPage.routeName,
      builder: (context, state) => const MapaPage(),
    ),
    GoRoute(
      path: '/homePage',
      name: HomePage.routeName,
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/solicitud',
      name: SolicitudScreen.routeName,
      builder: (context, state) => const SolicitudScreen(),
    ),
    GoRoute(
      path: '/solicitudes',
      name: ListaPeticiones.routeName,
      builder: (context, state) => const ListaPeticiones(),
    ),
    GoRoute(
      path: '/tutorial',
      name: AppTutorialScreen.routeName,
      builder: (context, state) => const AppTutorialScreen(),
    ),
    GoRoute(
      path: '/viaje',
      name: ViajeBody.routeName,
      builder: (context, state) => const ViajeBody(),
    ),
  ],
);
