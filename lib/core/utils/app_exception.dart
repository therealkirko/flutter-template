/// Base exception class for all application exceptions
class AppException implements Exception {
  final String? type;
  final String? message;

  AppException([this.type, this.message]);

  @override
  String toString() {
    return message ?? 'An error occurred';
  }
}

/// Exception for bad requests (400)
class BadRequestException extends AppException {
  BadRequestException([String? type, String? message]) : super(type, message);
}

/// Exception for failed data fetching
class FetchDataException extends AppException {
  FetchDataException([String? type, String? message]) : super(type, message);
}

/// Exception when API is not responding
class ApiNotRespondingException extends AppException {
  ApiNotRespondingException([String? type, String? message])
      : super(type, message);
}

/// Exception for unauthorized access (401)
class UnAuthorizedException extends AppException {
  UnAuthorizedException([String? type, String? message]) : super(type, message);
}

/// Exception for resource not found (404)
class NotFoundException extends AppException {
  NotFoundException([String? type, String? message]) : super(type, message);
}

/// Exception for server errors (500+)
class ServerException extends AppException {
  ServerException([String? type, String? message]) : super(type, message);
}

/// Exception for validation errors (422)
class ValidationException extends AppException {
  ValidationException([String? type, String? message]) : super(type, message);
}

/// Exception for duplicate requests (409)
class DuplicateRequestException extends AppException {
  DuplicateRequestException([String? type, String? message])
      : super(type, message);
}

/// Exception for pending actions
class PendingActionException extends AppException {
  PendingActionException([String? type, String? message])
      : super(type, message);
}

/// Exception for network connectivity issues
class NetworkException extends AppException {
  NetworkException([String? type, String? message]) : super(type, message);
}

/// Exception for timeout errors
class TimeoutException extends AppException {
  TimeoutException([String? type, String? message]) : super(type, message);
}
