// import 'dart:convert';
//
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:location_grm/feactures/core/services/dio_service.dart';
// import 'package:location_grm/feactures/mapa/infrastructure/datasource/DBHelper.dart';
// import 'package:location_grm/feactures/mapa/infrastructure/models/solicitud.dart';
// import 'package:location_grm/feactures/mapa/infrastructure/models/usuario.dart';
// import 'package:permission_handler/permission_handler.dart';
// // import 'package:uuid/uuid.dart';
// import 'package:workmanager/workmanager.dart';
//
// class AudioScreen extends StatefulWidget {
//   static const routeName = 'audio';
//   const AudioScreen({Key? key}) : super(key: key);
//
//   @override
//   State<AudioScreen> createState() => _AudioScreenState();
// }
//
// class _AudioScreenState extends State<AudioScreen> {
//   final DBHelper db = DBHelper.instance;
//   Dio dio = DioService.dio;
//
//   Future<void> requestLocationPermission() async {
//     var status = await Permission.location.request();
//
//     if (status.isGranted) {
//       print('ok');
//     } else if (status.isDenied) {
//       print('no ok');
//     }
//   }
//
//   void fetchData() async {
//     // Obtén la instancia de Dio desde tu servicio centralizado
//
//
//     try {
//       // Realiza una solicitud GET
//       Response response = await dio.get('/clientes');
//
//
//       // Imprime la respuesta
//       print('Response status: ${response.statusCode}');
//       print('Response data: ${response.data}');
//       Position position = await Geolocator.getCurrentPosition();
//       print(position);
//       var taskId = Uuid().v4();
//       final List<Solicitud> solicitudes = await db.getAllSolicitud();
//       print('solicitudes[0] ${solicitudes[0].toMap()}');
//
//       String solString = 'id:${solicitudes[0].id},data:${solicitudes[0].data},estado:${solicitudes[0].estado}';
//       Workmanager().registerOneOffTask(
//         taskId,
//         "audioTask", // Set the task name to "audioTask"
//         inputData: {
//           "data": solString,
//         },
//       );
//     } catch (e) {
//       // No necesitas manejar errores aquí, ya que el interceptor global se encarga de ellos
//       print('Error: $e');
//     }
//   }
//
//
//
//   void getAllSolicitudes() async {
//     try {
//       final List<Solicitud> solicitudes = await db.getAllSolicitud();
//       if (solicitudes.isNotEmpty) {
//         // Hacer algo con la lista de usuarios recuperada, por ejemplo, mostrarla en un mensaje
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('All solicitudes'),
//               content: Column(
//                 children: solicitudes.map((sol) => Text('ID: ${sol.id}\ndata: ${sol.data}\nestado: ${sol.estado}\n')).toList(),
//               ),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('Close'),
//                 ),
//               ],
//             );
//           },
//         );
//       } else {
//         // No hay usuarios
//         showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return AlertDialog(
//               title: Text('No Users Found'),
//               content: Text('No users found in the database.'),
//               actions: [
//                 TextButton(
//                   onPressed: () => Navigator.of(context).pop(),
//                   child: Text('Close'),
//                 ),
//               ],
//             );
//           },
//         );
//       }
//     }catch(error){
//       print(error);
//     }
//
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Solicitud por audio'),
//       ),
//       body: Column(
//         children: [
//           TextButton(
//             onPressed: fetchData,
//             child: Text('send request'),
//           ),
//
//           TextButton(
//             onPressed: getAllSolicitudes,
//             child: Text('Get request'),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:flutter_tts/flutter_tts.dart';



class AudioScreen extends StatefulWidget {
  static const routeName = 'audio';
  @override
  _AudioScreenState createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  final FlutterTts _flutterTts = FlutterTts();

  bool _isListening = false;
  String _text = 'Presiona el botón para hablar';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initializeTts();
    _startRecordingAfterDelay();
  }

  Future<void> _initializeTts() async {
    await _flutterTts.setLanguage('es-MX');
  }

  Future<void> _speak(String text) async {
    await _flutterTts.speak(text);
  }

  void _startRecordingAfterDelay() {
    _timer = Timer(Duration(seconds: 3), () {
      _listen();
    });
  }

  Future<void> _listen() async {
    if (!_isListening) {
      bool available = await _speechToText.initialize();
      if (available) {
        setState(() {
          _isListening = true;
          _text = 'Escuchando...';
        });

        _speechToText.listen(
          onResult: (result) {
            setState(() {
              _text = result.recognizedWords;
            });
            _resetTimer();
          },
          listenFor: Duration(seconds: 5), // Tiempo de escucha
        );
      } else {
        print('Speech to text no disponible');
      }
    } else {
      setState(() {
        _isListening = false;
        _text = 'Presiona el botón para hablar';
      });

      _speechToText.stop();
      await _speak(_text); // Reproduce el texto reconocido
      _resetTimer();
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    _startRecordingAfterDelay();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _speechToText.cancel();
    _flutterTts.stop();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Voice to Text'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _text,
              style: TextStyle(fontSize: 20.0),
            ),
          ],
        ),
      ),
    );
  }
}
