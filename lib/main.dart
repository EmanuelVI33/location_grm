import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/config/router/router.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_page.dart';

// final _router = GoRouter(
//   routes: [
//     GoRoute(
//       path: '/',
//       builder: (context, state) => HomeScreen(),
//     ),
//   ],
// );

void main() {
  runApp(const ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: RouterApp().router,
      debugShowCheckedModeBanner: false,
    );
  }
}
