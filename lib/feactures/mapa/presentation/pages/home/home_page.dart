import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location_grm/feactures/mapa/domain/entities/route_travel.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/solicitud/solicitud_screen.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/home/option_item.dart';
import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/navigator_bar.dart';

class HomePage extends StatelessWidget {
  static const String routeName = 'home';
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Acción para mostrar el menú
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                alignment: Alignment.center,
                child: Text(
                  'Listo para tus emergencias',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Buscar',
                          border: InputBorder.none,
                        ),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                        cursorColor: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: const [
                    CustomButton(
                      text: 'Llamar ambulancia',
                      icon: Icons.medical_services,
                    ),
                    SizedBox(width: 10),
                    CustomButton(
                      text: 'Primeros Auxilios',
                      icon: Icons.local_hospital,
                    ),
                    SizedBox(width: 10),
                    CustomButton(
                      text: 'Hospitales',
                      icon: Icons.local_hospital,
                    ),
                    // Agrega más botones según sea necesario
                  ],
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Tarjetas de servicios',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black),
              ),
              SizedBox(
                height: 500,
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: [
                    CardItem(
                      title: 'Ambulancias',
                      subtitle: '20 ambulancias',
                      icon: Icons.taxi_alert_rounded,
                      voidCallbackAction: () {
                        context.pushNamed(SolicitudScreen.routeName);
                      },
                    ),
                    CardItem(
                      title: 'Conductores',
                      subtitle: '23 Conductores',
                      icon: Icons.portrait_outlined,
                    ),
                    CardItem(
                      title: 'Encargados',
                      subtitle: '27 Encargados',
                      icon: Icons.medical_information,
                    ),
                    // Agrega más tarjetas según sea necesario
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigator(),
    );
  }
}

class CardItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? voidCallbackAction;

  const CardItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.voidCallbackAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1.0,
        ),
      ),
      child: ListTile(
        contentPadding: EdgeInsets.all(16.0),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        leading: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            icon,
            color: Colors.blue,
            size: 40,
          ),
        ),
        onTap: voidCallbackAction,
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  final String text;
  final IconData icon;

  const CustomButton({
    Key? key,
    required this.text,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.resolveWith<Color>(
          (Set<MaterialState> states) {
            if (states.contains(MaterialState.disabled)) {
              return Colors.grey.withOpacity(
                  0.6); // Color del botón cuando está deshabilitado
            }
            return Colors.amber; // Color del botón predeterminado
          },
        ),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
          EdgeInsets.symmetric(
              vertical: 12, horizontal: 20), // Ajuste del espacio interno
        ),
      ),
      onPressed: () {
        // Acción al presionar el botón
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
