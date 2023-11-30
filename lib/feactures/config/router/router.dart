import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/mapa/infrastructure/datasource/DBHelper.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/home/home_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/login/login_screen.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/login/tutorial_screen.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/solicitud/audio_screen.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/solicitud/solicitud_screen.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/viaje/viaje_body.dart';
import 'package:path/path.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: LoginScreen.routeName,
      builder: (BuildContext context, GoRouterState state) {
        return FutureBuilder<bool>(
          future: DBHelper.instance.checkIfUserExists(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final doesUserExist = snapshot.data ?? false;

              if (doesUserExist) {
                return const HomePage();
              } else {
                return const LoginScreen();
              }
            } else {
              // You might want to return a loading indicator while checking for user existence
              return CircularProgressIndicator();
            }
          },
        );
      },
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
      path: '/tutorial',
      name: AppTutorialScreen.routeName,
      builder: (context, state) => const AppTutorialScreen(),
    ),
    GoRoute(
      path: '/viaje',
      name: ViajeBody.routeName,
      builder: (context, state) => const ViajeBody(),
    ),
    GoRoute(
      path: '/audio',
      name: AudioScreen.routeName,
      builder: (context, state) =>  AudioScreen(),
    )
  ],
);
