import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_grm/feactures/mapa/domain/entities/route_travel.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/home/option_item.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Home'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text('Ambulancia Ya'),
            // Image.network(
            //     'https://www.pngkit.com/png/detail/251-2511622_ambulance-drawing-side-view-ambulance-cartoon.png'),
            const Icon(
              Icons.emergency,
              size: 40,
              color: Colors.red,
            ),
            // Agregar las dos opciones
            OptionItem(
              optionText: 'Historial de Viaje',
              icon: Icons.check,
              callback: () {
                context.go('/solicitud');
              },
            ),
            const SizedBox(
              height: 10,
            ),
            OptionItem(
              optionText: 'Solicitar Ambulancia',
              icon: Icons.settings,
              callback: () {
                // const origen = LatLng(-19.777269, -63.190394);
                // const destino = LatLng(-19.777249, -63.190894);
                context.go('/viaje');
              },
            ),
          ],
        ),
      ),
    );
  }
}
