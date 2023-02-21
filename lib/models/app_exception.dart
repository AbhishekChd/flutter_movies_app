import 'package:dio/dio.dart';

class AppException implements Exception {
  int statusCode;
  String statusMessage;
  AppExceptionType exceptionType;

  AppException({required this.statusCode, required this.statusMessage, required this.exceptionType});

  factory AppException.fromJson(Map<String, dynamic> json) {
    var code = json['status_code'] as int;
    AppExceptionType exception;
    switch (code) {
      case 7:
        exception = AppExceptionType.unauthorizedException;
        break;
      default:
        exception = AppExceptionType.unknownException;
    }

    return AppException(statusCode: code, statusMessage: json['status_message'] as String, exceptionType: exception);
  }

  static AppException getException(Object error) {
    DioError e = error as DioError;
    switch (e.type) {
      case DioErrorType.unknown:
        return AppException(
          statusCode: -1,
          statusMessage: e.error.toString(),
          exceptionType: AppExceptionType.unknownException,
        );
      default:
        return AppException.fromJson(e.response!.data);
    }
  }

  @override
  String toString() {
    return "Exception[status: $statusCode, message: $statusMessage], exception: $exceptionType";
  }
}

enum AppExceptionType {
  unauthorizedException("Unauthorized Exception"),
  unknownException("Unknown Exception");

  final String name;

  const AppExceptionType(this.name);
}
