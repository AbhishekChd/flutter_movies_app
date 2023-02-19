class Resource<T> {
  Status status;
  T? data;
  String? message;

  Resource.loading(this.message) : status = Status.loading;

  Resource.completed(this.data) : status = Status.completed;

  Resource.error(this.message) : status = Status.error;

  @override
  String toString() {
    return "Status: [$status], Data: $data, Message: $message";
  }
}

enum Status { completed, loading, error }
