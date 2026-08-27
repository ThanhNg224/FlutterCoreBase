/// Base exception hierarchy for the data layer
sealed class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  const AppException({required this.message, this.stackTrace});

  @override
  String toString() => '$runtimeType: $message';
}

class ServerException extends AppException {
  final int? statusCode;
  const ServerException({required super.message, this.statusCode, super.stackTrace});
}

class NetworkException extends AppException {
  const NetworkException({super.message = 'No Internet connection', super.stackTrace});
}

class PlatformException extends AppException {
  final String? errorCode;
  const PlatformException({required super.message, this.errorCode, super.stackTrace});
}

class StorageException extends AppException {
  const StorageException({required super.message, super.stackTrace});
}

class UnauthorizedException extends AppException {
  const UnauthorizedException({super.message = 'Unauthorized access', super.stackTrace});
}

class UnexpectedException extends AppException {
  const UnexpectedException({required super.message, super.stackTrace});
}
