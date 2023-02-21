import 'package:flutter_movies_app/models/app_exception.dart';

class Resource<T> {
  Status status;
  T? data;
  AppException? exception;
  String? message;

  Resource.loading(this.message) : status = Status.loading;

  Resource.completed(this.data) : status = Status.completed;

  Resource.error(this.exception, this.message) : status = Status.error;

  @override
  String toString() {
    return "Status: [$status], Data: $data, Message: $message, Exception: $exception";
  }
}

enum Status { completed, loading, error }
