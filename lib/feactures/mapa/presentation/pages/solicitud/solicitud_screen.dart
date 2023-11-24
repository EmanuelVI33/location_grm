import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location_grm/feactures/core/utils/pickImage.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/home/home_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/mapa/mapa_page.dart';
import 'package:location_grm/feactures/mapa/presentation/pages/viaje/viaje_body.dart';

class SolicitudScreen extends StatefulWidget {
  static const routeName = 'solicitud';
  const SolicitudScreen({super.key});

  @override
  State<SolicitudScreen> createState() => _SolicitudScreenState();
}

class _SolicitudScreenState extends State<SolicitudScreen> {
  Uint8List? _file;
  late GoogleMapController mapController;

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
                    decoration: InputDecoration(
                      hintText: 'Describe tu emergencia',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors
                                .grey), // Color del borde del campo de texto
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(
                            color: Colors
                                .blue), // Color del borde cuando está enfocado
                      ),
                      fillColor:
                          Colors.grey[200], // Color de fondo del campo de texto
                      filled: true,
                    ),
                    maxLines: 5,
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors
                          .black87, // Cambia el color del texto del campo de texto
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
                  Stack(children: [
                    SizedBox(
                      width: 300,
                      height: 300,
                      child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(-17.776322, -63.195126),
                          zoom: 14.0,
                        ),
                        onMapCreated: (GoogleMapController controller) {
                          mapController = controller;
                        },
                      ),
                    ),
                    Positioned.fill(
                        child: Align(
                            alignment: Alignment.center, child: _getMarker())),
                  ]),
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
                                      context.pushNamed(ViajeBody.routeName);
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

  Widget _getMarker() {
    return Container(
      width: 40,
      height: 40,
      padding: EdgeInsets.all(2),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(100),
          boxShadow: const [
            BoxShadow(
                color: Colors.grey,
                offset: Offset(0, 3),
                spreadRadius: 4,
                blurRadius: 6)
          ]),
      child: ClipOval(child: Image.asset("assets/6.png")),
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
