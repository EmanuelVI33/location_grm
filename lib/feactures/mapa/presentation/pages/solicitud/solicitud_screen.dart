import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_grm/feactures/core/utils/pickImage.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/home/home_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/viaje/viaje_body.dart';

import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class SolicitudScreen extends StatefulWidget {
  static const routeName = 'solicitud';
  const SolicitudScreen({super.key});

  @override
  State<SolicitudScreen> createState() => _SolicitudScreenState();
}

class _SolicitudScreenState extends State<SolicitudScreen> {
  Uint8List? _file;
  late GoogleMapController mapController;
  TextEditingController descripcionController = TextEditingController();
  LatLng? selectedLocation;
  LatLng? markerPosition;
  LatLng? userLocation;
  @override
  void initState() {
    super.initState();
    // Obtener la ubicación del usuario al inicio
    getCurrentLocation();
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Subir imagen '),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Tomar fotografia'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  try {
                    Uint8List? file = await pickImage(ImageSource.camera);

                    if (file != null) {
                      setState(() {
                        _file = file;
                      });
                    }
                  } catch (e) {
                    // Manejar cualquier excepción que pueda ocurrir durante la selección de la imagen
                    print('Error al seleccionar la imagen: $e');
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Seleccionar de la galeria'),
                onPressed: () async {
                  Navigator.of(context).pop();

                  try {
                    Uint8List? file = await pickImage(ImageSource.gallery);

                    if (file != null) {
                      setState(() {
                        _file = file;
                      });
                    }
                  } catch (e) {
                    // Manejar cualquier excepción que pueda ocurrir durante la selección de la imagen
                    print('Error al seleccionar la imagen: $e');
                  }
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancelar'),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  void enviarSolicitud() async {
    try {
      // Obtener la posición actual del mapa
      LatLng currentLatLng = await mapController.getLatLng(
        ScreenCoordinate(
          x: MediaQuery.of(context).size.width ~/ 2,
          y: MediaQuery.of(context).size.height ~/ 2,
        ),
      );
      var env = {
        'latUser': userLocation?.latitude,
        'lngUser': userLocation?.longitude,
        'latScene': markerPosition?.latitude,
        'lngScene': markerPosition?.longitude,
        'address': "av. camacho",
        'descripcion': descripcionController.text,
        'victimsNum': 21
      };

      const viar = {
        'id': "5276a769-1175-4966-ab4b-047924ab655a",
        'ci': "123456", // Cambiado a cadena
        'password': "contraseña",
        'fullName': "Nombre Apellido",
        'phone': 123456789,
        'isResponsible': true,
      };
      // Crear una instancia de Dio
      Dio dio = Dio();

      // Crear el cuerpo de la solicitud
      FormData formData = FormData.fromMap({'data': env, 'user': viar});

      // Realizar la solicitud HTTP
      Response response = await dio.post(
        'https://swiftcareb-production.up.railway.app/api/requests',
        data: formData,
      );

      // Verificar el código de respuesta
      if (response.statusCode == 201) {
        // La solicitud fue exitosa, puedes manejar la respuesta si es necesario
        print('Solicitud enviada correctamente');
      } else {
        // La solicitud falló, manejar según sea necesario
        print('Error al enviar la solicitud: ${response.statusCode}');
      }
    } catch (e) {
      // Manejar errores específicos, por ejemplo, problemas con el formato de los datos
      print('Error al enviar la solicitud: $e');
    }
  }

  void updateMarkerPosition(CameraPosition position) {
    if (mounted) {
      setState(() {
        markerPosition = position.target;
      });
    }
  }

  @override
  void dispose() {
    // Obtén la suscripción a las actualizaciones de posición
    final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
    final StreamSubscription<Position> positionStream =
        geolocator.getPositionStream().listen((_) {});

    // Cancela la suscripción
    positionStream.cancel();

    super.dispose();
  }

  void getCurrentLocation() async {
    Position position = await getLocation();
    print(json.encode(position));
    setState(() {
      userLocation = LatLng(position.latitude, position.longitude);
    });
  }

  Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  Future<Position> getLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            Colors.blue.shade900, // Cambia el color de fondo del app bar
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Icon(
              Icons.local_hospital,
              color: Colors.white, // Cambia el color del icono
              size: 35,
            ),
          )
        ],
        title: Text(
          'Solicitud de emergencia',
          style: TextStyle(
            color: Colors.white, // Cambia el color del texto del título
            fontSize: 24, // Ajusta el tamaño del texto del título
            fontWeight: FontWeight.bold, // Establece el peso de la fuente
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    '¿En qué podemos ayudarte?',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Cambia el color del texto
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: descripcionController, // Asignar el controlador
                    decoration: InputDecoration(
                      hintText: 'Describe tu emergencia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.grey,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                          color: Colors.blue,
                        ),
                      ),
                      fillColor: Colors.grey[200],
                      filled: true,
                    ),
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black87,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Seleccione la ubicacion',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                Stack(children: [
                  Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  Stack(
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                      SizedBox(
                        width: 300, // Establece un ancho específico
                        height: 300, // Establece una altura específica
                        child: Expanded(
                          child: GoogleMap(
                            initialCameraPosition: CameraPosition(
                              target: LatLng(-17.776322, -63.195126),
                              zoom: 14.0,
                            ),
                            onMapCreated: (GoogleMapController controller) {
                              mapController = controller;
                            },
                            myLocationEnabled:
                                true, // Habilita la ubicación del usuario
                            onCameraMove: (CameraPosition position) {
                              // Actualiza la posición del marcador mientras se mueve el mapa
                              setState(() {
                                markerPosition = position.target;
                              });
                            },
                            scrollGesturesEnabled:
                                true, // Asegúrate de que esta propiedad está en true
                            markers: Set.of([_getMarker()]),
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
                SizedBox(
                  width: 30,
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Cargar imagenes de la emergencia',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                ),
                if (_file != null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                            child: Image.memory(
                              _file!,
                              width: 300,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap:
                                clearImage, // Reemplaza clearImage con tu función para borrar la imagen
                            child: Container(
                              padding: EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Icon(
                                Icons.clear,
                                color: Colors.red,
                                size: 20,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                if (_file == null)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      children: [
                        Container(
                          width: 300,
                          height: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 2,
                                blurRadius: 5,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        Positioned(
                          top: 130,
                          right: 130,
                          child: IconButton(
                            icon: const Icon(Icons.upload),
                            onPressed: () => _selectImage(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CustomButton(
                          text: 'Cancelar',
                          color: Colors.red,
                          onPressed: () =>
                              context.pushNamed(HomePage.routeName),
                        )),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomButton(
                        text: 'Enviar',
                        color: Colors.green,
                        onPressed: () {
                          enviarSolicitud();
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text(
                                  'Solicitud enviada',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors
                                        .green, // Cambia el color del título
                                  ),
                                ),
                                content: const Text(
                                  'Su solicitud está siendo tratada',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors
                                        .black87, // Cambia el color del contenido
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      // Aquí puedes llamar a la función para enviar la solicitud
                                      enviarSolicitud();
                                    },
                                    child: const Text(
                                      'Aceptar',
                                      style: TextStyle(
                                        color: Colors
                                            .green, // Cambia el color del botón de aceptar
                                      ),
                                    ),
                                  )
                                ],
                              );
                            },
                          );
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Marker _getMarker() {
    if (markerPosition == null) {
      return Marker(markerId: MarkerId('default'));
    }

    return Marker(
      markerId: MarkerId('selected'),
      position: markerPosition!,
      icon: BitmapDescriptor.defaultMarker,
      draggable: true,
    );
  }
}

class CustomButton extends StatelessWidget {
  final Color color;
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.color,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return ElevatedButton(
      onPressed: onPressed,
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(8), // Aumenta la elevación
        backgroundColor: MaterialStateProperty.all(color),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0), // Bordes más redondeados
            // Agrega un borde al botón
            //side: BorderSide(color: colors.secondary, width: 2),
          ),
        ),
        // Agrega una sombra al botón
        shadowColor: MaterialStateProperty.all(Colors.black.withOpacity(0.3)),
        overlayColor: MaterialStateProperty.all(Colors.black.withOpacity(0.1)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0, // Aumenta el espacio entre letras
          ),
        ),
      ),
    );
  }
}
