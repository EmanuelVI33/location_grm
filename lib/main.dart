import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_grm/feactures/config/router/router.dart';
import 'package:location_grm/feactures/config/theme/app_theme.dart';
import 'package:location_grm/feactures/core/services/dio_service.dart';
import 'package:location_grm/feactures/mapa/infrastructure/datasource/DBHelper.dart';
import 'package:location_grm/feactures/mapa/infrastructure/models/solicitud.dart';
import 'package:workmanager/workmanager.dart';

void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch(taskName) {
      case "audioTask":
        try {
          // Parse the JSON data received from the background task
          final jsonData = inputData?['data'].toString();

          // Make an HTTP request using Dio
          Dio dio = DioService.dio;
          print('sending----request-----');
          Response response = await dio.post('/requests/affected',data: jsonData);

          // Log the response
          print('Background task response: ${response.data}');

          return Future.value(response.data);
        } catch (e) {
          print('Error in background task: $e');
          return Future.value(false);
        }
      case "retryTask":
        try {
          DBHelper db = DBHelper.instance;
          final List<Solicitud> solicitudes = await db.getPendingSolicitudes();

          if (solicitudes.isNotEmpty) {
            Dio dio = DioService.dio;

            for (var solicitud in solicitudes) {
              try {
                // Customize this based on your Solicitud model and API endpoint
                Map<String, dynamic> requestData = {
                  'id':solicitud.id,
                  'data': solicitud.data,
                  'estado': solicitud.estado.toString(), // Adjust based on your requirements
                };
                Response response = await  dio.post('/requests/affected',data: requestData);

                // Check the response and update the database accordingly
                if (response.statusCode == 200) {
                  // Update the solicitud in the database based on the response
                  // For example, mark it as sent or update any relevant information

                  await db.updateSolicitud({...requestData,'estado':Status.enviada} as Solicitud);
                } else {
                  print('HTTP request failed with status code: ${response.statusCode}');
                }
              } catch (e) {
                print('Error sending HTTP request: $e');
              }
            }
          }
        } catch (error) {
          print('Error in background task: $error');
        }
        return Future.value(false);
    }
    return Future.value(true);
  });
}





void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // Workmanager().initialize(callbackDispatcher);
  // var taskId = DateTime.now().second.toString();
  // Workmanager().registerPeriodicTask(taskId, 'retryTask',frequency: Duration(minutes: 1));
  runApp(ProviderScope(child: MainApp()));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppTheme().getTheme(),
      routerConfig: appRouter,
      debugShowCheckedModeBanner: false,
    );
  }
}
