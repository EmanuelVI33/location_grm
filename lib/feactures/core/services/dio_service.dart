import 'package:dio/dio.dart';
import 'package:location_grm/feactures/core/constans/constants.dart';
import 'package:location_grm/feactures/core/interceptor/retry_interceptor.dart';

class DioService {
  // final myStatuses = { status408RequestTimeout, status409Conflict };

  static final Dio _dio = Dio(BaseOptions(
    baseUrl: apiUrl,
    connectTimeout: apiTimeout,
    receiveTimeout: apiTimeout,

  ));



  // Método para obtener la instancia de Dio
  static Dio get dio {
    // Añade un interceptor global para manejar errores
    _dio.interceptors.add(InterceptorsWrapper(
      onError: (DioException error, ErrorInterceptorHandler handler) async{
        if(error.type == DioExceptionType.receiveTimeout || error.type == DioExceptionType.connectionError || error.type == DioExceptionType.connectionTimeout){
          print('error $error');
        }else {
          // Manejo de errores de manera uniforme
          print('Global error handler:type: ${error.type}, error: ${error
              .error}, response: ${error.response},msg:  ${error.message}');
          return handler.next(error);
        }
      },
    ));
    // _dio.interceptors.add(RetryInterceptor());



    return _dio;
  }






}
