// import 'package:dio/dio.dart';
//
// class RetryInterceptor extends Interceptor {
//   final int maxRetries;
//   final Duration retryDelay;
//
//   RetryInterceptor({this.maxRetries = 3, this.retryDelay = const Duration(seconds: 5)});
//
//   @override
//   Future<void> onError(DioError err, ErrorInterceptorHandler handler) async {
//     if (_shouldRetry(err)) {
//       for (var retryCount = 0; retryCount < maxRetries; retryCount++) {
//         print('Retry attempt ${retryCount + 1}');
//         try {
//           await Future.delayed(retryDelay);
//           final response = await handler.next(err);
//           if (response.statusCode == 200) {
//             print('Retry successful');
//             return;
//           }
//         } catch (e) {
//           print('Retry failed: $e');
//         }
//       }
//     }
//
//     // If all retries fail, resolve the original error
//     return handler.next(err);
//   }
//
//   bool _shouldRetry(DioException error) {
//     return error.type == DioExceptionType.receiveTimeout ||
//         error.type == DioExceptionType.connectionTimeout ||
//         error.type == DioExceptionType.sendTimeout;
//   }
// }
