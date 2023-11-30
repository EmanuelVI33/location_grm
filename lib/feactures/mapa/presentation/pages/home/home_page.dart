import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:location_grm/feactures/core/constans/constants.dart';
import 'package:location_grm/feactures/mapa/domain/entities/ambulancia_pos.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/solicitud/audio_screen.dart';

import 'package:location_grm/feactures/mapa/presentation/pages/solicitud/solicitud_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:location_grm/feactures/mapa/presentation/widgets/navigator_bar.dart';
import 'package:shake/shake.dart';



class HomePage extends StatefulWidget {
  static const String routeName = 'home';
  const HomePage({super.key});


  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  late ShakeDetector _shakeDetector;
  int _shakeCount = 0;
  Timer? _resetTimer;

  @override
  void initState() {
    super.initState();
    _shakeDetector = ShakeDetector.autoStart(
      shakeThresholdGravity: 1.5,
      onPhoneShake: () {
        setState(() {
          _shakeCount++;

          // Reinicia el temporizador cada vez que se detecta una agitación
          _resetTimer?.cancel();
          _resetTimer = Timer(Duration(seconds: 2), () {
            _shakeCount = 0;
          });

          if (_shakeCount >= 3) {
            _resetTimer?.cancel(); // Cancela el temporizador antes de mostrar el mensaje
            _shakeCount = 0; // Reinicia el contador después de mostrar el mensaje
            context.pushNamed(AudioScreen.routeName);
          }
        });
      },
    );
  }

  void listenEvent() {
    try {
      SSEClient.subscribeToSSE(
          method: SSERequestType.GET,
          url: '$apiUrl/accept',
          header: {
            // "Cookie":
            //     'jwt=eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VybmFtZSI6InRlc3QiLCJpYXQiOjE2NDMyMTAyMzEsImV4cCI6MTY0MzgxNTAzMX0.U0aCAM2fKE1OVnGFbgAU_UVBvNwOMMquvPY8QaLD138; Path=/; Expires=Wed, 02 Feb 2022 15:17:11 GMT; HttpOnly; SameSite=Strict',
            "Accept": "text/event-stream",
            "Cache-Control": "no-cache",
          }).listen(
            (event) {
          print(
              '--------------------------------------------------------------------------------------');
          print(
              '${event.data}-------------------------------------------------------------------------------');
          print(
              '--------------------------------------------------------------------------------------');

          if (event.data != null) {

            final responseMap = requestFromJson(event.data!);
            if (responseMap != null) {
              _showMessageDialog(event.data!);
            }
          }

          // Recibir y almacenar
        },
        onDone: () {
          print("SSE stream closed");
        },
        onError: (error) {
          print(
              '--------------------------------------------------------------------------------------');
          print("Error en la conexión SSE: $error");
          print(
              '--------------------------------------------------------------------------------------');
        },
      );
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showMessageDialog(data) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Ubicacion de la ambulancia'),
          content: Text('${data}'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _shakeDetector.stopListening();
    _resetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$_shakeCount'),
      ),
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
