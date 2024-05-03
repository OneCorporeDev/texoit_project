abstract class Failure implements Exception {
  const Failure({
    this.exception,
    this.message,
  });

  final Exception? exception;
  final String? message;

  @override
  String toString() {
    return '$runtimeType(exception: $exception, message: $message)';
  }
}

class ServerFailure extends Failure {
  const ServerFailure({
    super.exception,
    super.message,
  });
}
